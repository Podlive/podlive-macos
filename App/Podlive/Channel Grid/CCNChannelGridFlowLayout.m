//
//  Created by Frank Gregor on 06/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CCNChannelGridFlowLayout.h"
#import "CCNChannelGridItem.h"
#import "CCNChannelGridItemDetailView.h"
#import "NSBKeyframeAnimation+Animations.h"

const CGFloat kGridItemWidth = 156.0;
const CGFloat kGridItemHeight = 224.0;
const CGFloat kGridItemPadding = 16.0;

const CGFloat kSectionheaderHeight = 40.0;
const CGFloat kSectionInsetYPadding = 8.0;
const CGFloat kSectionInsetXPadding = 10.0;

const CGFloat kLinePadding = 10.0;

const CGFloat kCollapsedHeight = 0;
const CGFloat kDetailViewExpandedHeight = 280.0;
const CGFloat kDetailViewTopMargin = 5.0;

NSCollectionViewSupplementaryElementKind const CCNCollectionElementKindItemDetail     = @"CCNCollectionElementKindItemDetail";
NSCollectionViewSupplementaryElementKind const CCNSelectedItemFrameKeyPath            = @"selectedItemFrame";


@interface CCNChannelGridFlowLayout () {
    CVDisplayLinkRef _displayLink;
}
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) NSRect selectedItemFrame;
@property (nonatomic, assign, getter=isAnimating) BOOL animating;
@property (nonatomic, assign, getter=isPushAnimation) BOOL pushAnimation;
@property (nonatomic, readonly) BOOL isExpanded;
@property (nonatomic, readonly) BOOL canAnimate;
@property (nonatomic, strong) NSArray *animatableHeightValues;
@property (nonatomic, assign) NSUInteger currentStep;
@property (nonnull, copy) CCNChannelGridFlowLayoutAnimationCompletion animationCompletion;
@end

@implementation CCNChannelGridFlowLayout

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.sectionInset            = NSEdgeInsetsMake(kSectionInsetYPadding, kSectionInsetXPadding, kSectionInsetYPadding, kSectionInsetXPadding);
    self.minimumInteritemSpacing = kGridItemPadding;
    self.minimumLineSpacing      = kLinePadding;
    self.itemSize                = NSMakeSize(kGridItemWidth, kGridItemHeight);
//    self.headerReferenceSize     = NSMakeSize(CGFLOAT_MAX, kSectionheaderHeight);

    self.selectedItemFrame = NSZeroRect;
    self.animating = NO;

    return self;
}

// MARK: - API

- (void)expandDetailViewAtIndexPath:(NSIndexPath *)indexPath completion:(CCNChannelGridFlowLayoutAnimationCompletion)completion {
    self.selectedIndexPath = indexPath;
    [self expandWithCompletion:completion];
}

- (void)collapseDetailViewWithCompletion:(CCNChannelGridFlowLayoutAnimationCompletion)completion {
    [self collapseWithCompletion:completion];
}

- (NSSize)collectionViewContentSize {
    var contentSize = [super collectionViewContentSize];

    if (self.selectedIndexPath) {
        contentSize.height += [self.animatableHeightValues[self.currentStep] doubleValue];
    }

    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(NSRect)rect {
    // Grab computed attributes from parent
    NSMutableArray<__kindof NSCollectionViewLayoutAttributes *> *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    if (self.selectedIndexPath) {
        // and find the selected item
        for (NSCollectionViewLayoutAttributes *layoutAttributes in attributes) {
            if (layoutAttributes.indexPath == self.selectedIndexPath) {
                if (layoutAttributes.representedElementCategory == NSCollectionElementCategoryItem) {
                    self.selectedItemFrame = layoutAttributes.frame;
                }
            }
        }

        // The frame of all items after the selected item whose are placed in the next+ rows
        // must be adjusted according to the height of detailed supplementary view.
        for (NSCollectionViewLayoutAttributes *layoutAttributes in attributes) {
            layoutAttributes.frame = [self frameForDisplacedAttributes:layoutAttributes];
        }

        // calculate layout attributes for detail view and add it to the attributes set
        // -> deail view will be displayed
        [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:CCNCollectionElementKindItemDetail atIndexPath:self.selectedIndexPath]];
    }

    return attributes;
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:CCNCollectionElementKindItemDetail]) {
        let layoutAttributes = [NSCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        let detailedViewRect = NSMakeRect(NSMinX(self.collectionView.frame),
                                          NSMaxY(self.selectedItemFrame) + kDetailViewTopMargin,
                                          self.collectionViewContentSize.width,
                                          [self.animatableHeightValues[self.currentStep] doubleValue]);

        layoutAttributes.frame = detailedViewRect;

        return layoutAttributes;
    }

    let superAttributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    superAttributes.frame = [self frameForDisplacedAttributes:superAttributes];
    return superAttributes;
}

- (NSSet<NSIndexPath *> *)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind {
    if ([elementKind isEqualToString:CCNCollectionElementKindItemDetail]) {
        return [self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:elementKind];
    }
    return [NSSet setWithArray:@[]];
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NSMakeSize(kGridItemWidth, kGridItemHeight);
}

// MARK: - Frame Calculation

- (NSRect)frameForDisplacedAttributes:(NSCollectionViewLayoutAttributes *)inAttributes {
    var attributesFrame = inAttributes.frame;
    if (self.selectedIndexPath) {
        if (NSMinY(attributesFrame) > (NSMaxY(self.selectedItemFrame))) {
            attributesFrame.origin.y += [self.animatableHeightValues[self.currentStep] doubleValue] + kDetailViewTopMargin;
        }
    }
    return attributesFrame;
}

// MARK: - Custom Accessors

- (BOOL)isExpanded {
    return (self.currentStep == self.animatableHeightValues.count-1);
}

- (BOOL)canAnimate {
    if (self.pushAnimation) {
        return (self.currentStep < self.animatableHeightValues.count-1);
    }
    else {
        return (self.currentStep > 0);
    }
}

// MARK: - Animation Handling

- (void)expandWithCompletion:(CCNChannelGridFlowLayoutAnimationCompletion)completion {
    self.animationCompletion = completion;
    [self _performAnimationForPush:YES];
}

- (void)collapseWithCompletion:(CCNChannelGridFlowLayoutAnimationCompletion)completion {
    self.animationCompletion = completion;
    [self _performAnimationForPush:NO];
}

- (void)_performAnimationForPush:(BOOL)push {
    self.pushAnimation = push;
    self.animatableHeightValues = [NSBKeyframeAnimation calculatePositionValuesForFunction:(push ? AnimationTypeEaseOutCubic : AnimationTypeEaseInCubic)
                                                                                startValue:kCollapsedHeight
                                                                                  endValue:kDetailViewExpandedHeight
                                                                              withDuration:0.32];
    self.currentStep = (push ? 0 : self.animatableHeightValues.count-1);

    if (!self.animating)
        [self _createDisplayLink];

    self.animating = YES;
}

- (void)_createDisplayLink {
    CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
    CVDisplayLinkSetOutputCallback(_displayLink, &FlowLayoutAnimationCallback, (__bridge void *)(self));
    CVDisplayLinkStart(_displayLink);
}

- (void)_releaseDisplayLink {
    if (_displayLink) {
        CVDisplayLinkStop(_displayLink);
        CVDisplayLinkRelease(_displayLink);
        _displayLink = NULL;
    }
}

// MARK: - CVDisplayLink Output Render Callback

static CVReturn FlowLayoutAnimationCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext) {
    CCNChannelGridFlowLayout *layout = (__bridge CCNChannelGridFlowLayout*)displayLinkContext;

    if (layout.canAnimate) {
        if (layout.isPushAnimation) {
            layout.currentStep++;
        }
        else {
            layout.currentStep--;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [layout invalidateLayout];
            let detailView = (CCNChannelGridItemDetailView *)[layout.collectionView supplementaryViewForElementKind:CCNCollectionElementKindItemDetail atIndexPath:layout.selectedIndexPath];
            CGFloat currentHeight = [(NSNumber *)layout.animatableHeightValues[layout.currentStep] doubleValue];
            CGFloat alphaValue = currentHeight  / kDetailViewExpandedHeight;
            detailView.container.alphaValue = alphaValue;
            [detailView.container.subviews makeObjectsPerformSelector:@selector(alphaValue) withObject:@(alphaValue)];
        });
    }
    else {
        [layout _releaseDisplayLink];
        if (layout.animationCompletion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                layout.animationCompletion();
            });
        }

        if (!layout.isPushAnimation) {
            layout.selectedIndexPath = nil;
        }
        layout.animating = NO;
    }
    
    return kCVReturnSuccess;
}

@end
