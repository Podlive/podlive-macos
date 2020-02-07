//
//  Created by Frank Gregor on 28/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannelGridViewController.h"
#import "CCNChannelGridSectionHeaderView.h"
#import "CCNChannelGridItemDetailView.h"
#import "CCNChannelGridNoStreamItemView.h"
#import "CCNChannelGridItem.h"
#import "CCNChannelGridFlowLayout.h"
#import "CCNChannel.h"
#import "CCNImageCache.h"

#import "CCNChannel+Convenience.h"
#import "NSDictionary+Podlive.h"
#import "NSImage+Podlive.h"
#import "NSView+Podlive.h"

#import "PFUser+Podlive.h"

static NSString *const kItemIdentifier               = @"item";
static NSString *const kDetailedItemIdentifier       = @"detailedItem";
static NSString *const kHeaderIdentifier             = @"sectionHeader";
static NSString *const kNoStreamItemHeaderIdentifier = @"noStreamHeader";
static NSString *const kItemDetailViewIdentifier     = @"itemDetailViewIdentifier";

typedef void(^CCNChannelGridViewDataSourceUpdatedCompletion)(NSSet<NSIndexPath *> *itemsToDelete, NSSet<NSIndexPath *> *itemsToInsert);


@interface CCNChannelGridViewController () <NSCollectionViewDelegate, NSCollectionViewDataSource, CCNChannelGridItemDelegate, CCNChannelGridItemDetailViewDelegate>
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSCollectionView *collectionView;
@property (nonatomic, readonly) CCNChannelGridFlowLayout *channelGridFlowLayout;

@property (nonatomic, readonly) NSArray<CCNChannel *> *liveChannels;
@property (nonatomic, readonly) NSArray<CCNChannel *> *offlineChannels;
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<CCNChannel *> *> *channels;
@end

@implementation CCNChannelGridViewController

- (void)loadView {
    self.view = NSView.new;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addVibrancyBlendingMode:NSVisualEffectBlendingModeBehindWindow];
}

- (void)viewDidLoad {
    [self setupUI];
    [self setupConstraints];
    [self setupNotifications];

    @weakify(self);

    let channelManager = CCNChannelManager.sharedManager;
    [channelManager updateWithCompletion:^{
        @strongify(self);

        self.channels = channelManager.channelsForCurrentFilterCriteria;

        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.collectionView.alphaValue = 0;
            [self.collectionView reloadData];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.75;

                    @strongify(self);
                    self.collectionView.animator.alphaValue = 1.0;

                } completionHandler:nil];
            });
        });
    }];

    [super viewDidLoad];
}

// MARK: - Setup

- (void)setupNotifications {
    let nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self selector:@selector(handlePushNotificationChannelStateUpdated:)         name:CCNPushNotificationChannelStateUpdated object:nil];
    [nc addObserver:self selector:@selector(handleDidChangeChannelFilterCriteriaNotification:)  name:CCNDidChangeChannelFilterCriteriaNotification object:nil];
}

- (void)setupUI {
    self.view.wantsLayer = YES;

    NSScrollView *scrollView = NSScrollView.new;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.wantsLayer = YES;
    scrollView.borderType = NSNoBorder;
    scrollView.scrollerStyle = NSScrollerStyleOverlay;
    scrollView.hasVerticalScroller = YES;
    scrollView.hasHorizontalScroller = NO;
    scrollView.automaticallyAdjustsContentInsets = NO;
    self.scrollView = scrollView;


    NSCollectionView *collectionView = NSCollectionView.new;
    collectionView.wantsLayer = YES;
    collectionView.collectionViewLayout = CCNChannelGridFlowLayout.new;
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = NO;
    collectionView.allowsEmptySelection = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.layer.backgroundColor = NSColor.clearColor.CGColor;
    collectionView.backgroundColors = @[ NSColor.clearColor ];

    [collectionView registerClass:CCNChannelGridItem.class              forItemWithIdentifier:kItemIdentifier];
    [collectionView registerClass:CCNChannelGridSectionHeaderView.class forSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withIdentifier:kHeaderIdentifier];
    [collectionView registerClass:CCNChannelGridNoStreamItemView.class  forSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withIdentifier:kNoStreamItemHeaderIdentifier];
    [collectionView registerClass:CCNChannelGridItemDetailView.class    forSupplementaryViewOfKind:CCNCollectionElementKindItemDetail   withIdentifier:kItemDetailViewIdentifier];

    self.collectionView = collectionView;


    self.scrollView.documentView = self.collectionView;
    [self.view addSubview:self.scrollView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.scrollView.superview.topAnchor constant:38],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.scrollView.superview.bottomAnchor],
        [self.scrollView.leftAnchor constraintEqualToAnchor:self.scrollView.superview.leftAnchor],
        [self.scrollView.rightAnchor constraintEqualToAnchor:self.scrollView.superview.rightAnchor],
    ]];
}

// MARK: - Helper

- (void)updateDataSourceWithCompletion:(CCNChannelGridViewDataSourceUpdatedCompletion)completion {
    let currentLiveChannels    = self.channels[@(CCNChannelSectionLive)];
    let currentOfflineChannels = self.channels[@(CCNChannelSectionOffline)];

    let currentChannels = CCNChannelManager.sharedManager.channelsForCurrentFilterCriteria;
    let newLiveChannels    = currentChannels[@(CCNChannelSectionLive)];
    let newOfflineChannels = currentChannels[@(CCNChannelSectionOffline)];

    let itemsToDelete      = NSMutableSet.new;
    let itemsToInsert      = NSMutableSet.new;


    // All Deletions
    for ( NSInteger idx = 0; idx < currentLiveChannels.count; idx++ ) {
        let entry = currentLiveChannels[idx];
        if ([newLiveChannels containsObject:entry] == NO) {
            [itemsToDelete addObject:[NSIndexPath indexPathForItem:idx inSection:CCNChannelSectionLive]];
        }
    }
    for ( NSInteger idx = 0; idx < currentOfflineChannels.count; idx++ ) {
        let entry = currentOfflineChannels[idx];
        if ([newOfflineChannels containsObject:entry] == NO) {
            [itemsToDelete addObject:[NSIndexPath indexPathForItem:idx inSection:CCNChannelSectionOffline]];
        }
    }


    // All Inserts
    for ( NSInteger idx = 0; idx < newLiveChannels.count; idx++ ) {
        let entry = newLiveChannels[idx];
        if ([currentLiveChannels containsObject:entry] == NO) {
            [itemsToInsert addObject:[NSIndexPath indexPathForItem:idx inSection:CCNChannelSectionLive]];
        }
    }
    for ( NSInteger idx = 0; idx < newOfflineChannels.count; idx++ ) {
        let entry = newOfflineChannels[idx];
        if ([currentOfflineChannels containsObject:entry] == NO) {
            [itemsToInsert addObject:[NSIndexPath indexPathForItem:idx inSection:CCNChannelSectionOffline]];
        }
    }

    if (completion) {
        completion([NSSet setWithSet:itemsToDelete], [NSSet setWithSet:itemsToInsert]);
    }
}

- (void)updateCollectionViewWithItemsToDelete:(NSSet *)itemsToDelete itemsToInsert:(NSSet *)itemsToInsert {
    self.channels = CCNChannelManager.sharedManager.channelsForCurrentFilterCriteria;

    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.animator performBatchUpdates:^{
            @strongify(self);
            [self.collectionView deleteItemsAtIndexPaths:itemsToDelete];
            [self.collectionView insertItemsAtIndexPaths:itemsToInsert];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

        } completionHandler:^(BOOL finished) {
            @strongify(self);
            [self updateHeaderViews];
        }];
    });
}

- (void)updateHeaderViews {
    [self updateHeaderViewForSection:0];
    [self updateHeaderViewForSection:1];
}

- (void)updateHeaderViewForSection:(NSUInteger)section {
    let indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    let view = (CCNChannelGridSectionHeaderView *)[self.collectionView supplementaryViewForElementKind:NSCollectionElementKindSectionHeader atIndexPath:indexPath];
    if ([view isKindOfClass:CCNChannelGridSectionHeaderView.class]) {
        view.numberOfStreams = [self numberOfStreamsInSectionForIndexPath:indexPath];
        view.headerSection = indexPath.section;
    }
}

- (NSUInteger)numberOfStreamsInSectionForIndexPath:(NSIndexPath *)indexPath {
    return self.channels[@(indexPath.section)].count;
}

- (BOOL)showNoStreamHeaderForIndexPath:(NSIndexPath *)indexPath {
    let numberOfStreams = [self numberOfStreamsInSectionForIndexPath:indexPath];
    return (indexPath.section == CCNChannelSectionLive && numberOfStreams == 0);
}

// MARK: - Notifications

- (void)handlePushNotificationChannelStateUpdated:(NSNotification *)note {
    let userInfo = note.userInfo;

    let theChannelId = (NSString *)userInfo[kUserInfoChannelStateId];
    let channelIndexPathOld = (NSIndexPath *)[self.channels indexPathForChannelWithId:theChannelId];

    if (!channelIndexPathOld) {
        return;
    }

    
    let channelManager = CCNChannelManager.sharedManager;
    let layout         = (CCNChannelGridFlowLayout *)self.collectionView.collectionViewLayout;
    let serialQueue    = dispatch_queue_create("com.cocoanaut.serial-queue", DISPATCH_QUEUE_SERIAL);


    @weakify(self);
    [channelManager updateWithCompletion:^{
        dispatch_async(serialQueue, ^{
            @strongify(self);

            let theChannel = [channelManager channelWithId:theChannelId];
            if (channelManager.channelFilterCriteria == CCNChannelFilterCriteriaSubscribed && ![PFUser.currentUser isSubscribedToChannel:theChannel]) {
                return;
            }

            self.channels = channelManager.channelsForCurrentFilterCriteria;
            let channelIndexPathNew = (NSIndexPath *)[self.channels indexPathForChannelWithId:theChannelId];


            void (^disableHandler)(void) = ^{
                @strongify(self);
                let player = CCNPlayer.sharedInstance;
                if ([player.currentChannel isEqual:theChannel] && !theChannel.isOnline) {
                    [player stop];
                }

                let ctx = NSCollectionViewFlowLayoutInvalidationContext.new;
                let indexPaths = [NSSet setWithObject:channelIndexPathNew];
                [ctx invalidateSupplementaryElementsOfKind:CCNCollectionElementKindItemDetail atIndexPaths:indexPaths];
                [layout invalidateLayoutWithContext:ctx];

                [self.collectionView.animator moveItemAtIndexPath:channelIndexPathOld toIndexPath:channelIndexPathNew];
                [self updateHeaderViews];
            };

            dispatch_async(dispatch_get_main_queue(), ^{
                if (layout.selectedIndexPath) {
                    [self.collectionView.animator deselectItemsAtIndexPaths:[NSSet setWithArray:@[ layout.selectedIndexPath ]]];
                    [layout collapseDetailViewWithCompletion:^{
                        disableHandler();
                    }];
                }
                else {
                    disableHandler();
                }
            });
        });
    }];
}

- (void)handleDidChangeChannelFilterCriteriaNotification:(NSNotification *)note {
    @weakify(self);
    let transitionHandler = ^{
        @strongify(self);
        [self updateDataSourceWithCompletion:^(NSSet<NSIndexPath *> *itemsToDelete, NSSet<NSIndexPath *> *itemsToInsert) {
            @strongify(self);
            [self updateCollectionViewWithItemsToDelete:itemsToDelete itemsToInsert:itemsToInsert];
        }];
    };

    let layout = (CCNChannelGridFlowLayout *)self.collectionView.collectionViewLayout;
    if (layout.selectedIndexPath) {
        [layout collapseDetailViewWithCompletion:transitionHandler];
    }
    else {
        transitionHandler();
    }
}

// MARK: - Custom Accessors

- (NSArray<CCNChannel *> *)liveChannels {
    return self.channels[@(CCNChannelSectionLive)];
}

- (NSArray<CCNChannel *> *)offlineChannels {
    return self.channels[@(CCNChannelSectionOffline)];
}

- (CCNChannelGridFlowLayout *)channelGridFlowLayout {
    static dispatch_once_t onceToken;
    static CCNChannelGridFlowLayout *layout = nil;
    dispatch_once(&onceToken, ^{
        layout = CCNChannelGridFlowLayout.new;
    });
    return layout;
}

// MARK: - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    let layout = collectionView.collectionViewLayout;
    let selectedIndexPath = indexPaths.allObjects.firstObject;
    [layout expandDetailViewAtIndexPath:selectedIndexPath completion:nil];
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [collectionView.collectionViewLayout collapseDetailViewWithCompletion:nil];
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    let indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    return ([self showNoStreamHeaderForIndexPath:indexPath] ? NSMakeSize(CGFLOAT_MAX, 120.0) : NSMakeSize(CGFLOAT_MAX, 40.0));
}

// MARK: - NSCollectionViewDataSource

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channels[@(section)].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return self.channels.count;
}

- (NSView *)collectionView:(NSCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    // Section Header
    if ([elementKind isEqualToString:NSCollectionElementKindSectionHeader]) {
        if ([self showNoStreamHeaderForIndexPath:indexPath]) {
            let header = (CCNChannelGridNoStreamItemView *)[collectionView makeSupplementaryViewOfKind:elementKind withIdentifier:kNoStreamItemHeaderIdentifier forIndexPath:indexPath];
            let channelFilterCriteria = CCNChannelManager.sharedManager.channelFilterCriteria;
            if (channelFilterCriteria == CCNChannelSectionLive) {
                header.labelText = NSLocalizedString(@"unfortunately, no live stream...", nil);
            }
            else {
                header.labelText = NSLocalizedString(@"unfortunately, no favorite live stream...", nil);
            }
            return header;
        }
        else {
            let header = (CCNChannelGridSectionHeaderView *)[collectionView makeSupplementaryViewOfKind:elementKind withIdentifier:kHeaderIdentifier forIndexPath:indexPath];
            header.numberOfStreams = [self numberOfStreamsInSectionForIndexPath:indexPath];
            header.headerSection = indexPath.section;
            return header;
        }
    }

    // Channel Detail
    else if ([elementKind isEqualToString:CCNCollectionElementKindItemDetail]) {
        let channel = [self.channels[@(indexPath.section)] objectAtIndex:indexPath.item];
        CCNChannelGridItemDetailView *detailedView = (CCNChannelGridItemDetailView *)[collectionView makeSupplementaryViewOfKind:elementKind withIdentifier:kItemDetailViewIdentifier forIndexPath:indexPath];
        detailedView.channel  = channel;
        detailedView.delegate = self;

        [detailedView bind:CCNSelectedItemFrameKeyPath
                  toObject:collectionView.collectionViewLayout
               withKeyPath:CCNSelectedItemFrameKeyPath
                   options:(@{ NSContinuouslyUpdatesValueBindingOption : @(YES) })];

        return detailedView;
    }

    return NSView.new;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    let theChannel = [self.channels[@(indexPath.section)] objectAtIndex:indexPath.item];

    let item = (CCNChannelGridItem *)[collectionView makeItemWithIdentifier:kItemIdentifier forIndexPath:indexPath];
    item.channel = theChannel;
    item.delegate = self;

    if (theChannel.coverartThumbnail200URL) {
        NSTimeInterval animationDuration = 0.15;
        let timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        @weakify(item);
        [NSImage loadFromURL:theChannel.coverartThumbnail200URL
            placeholderImage:NSImage.channelPlaceholder
             prefetchHandler:^(NSImage *cachedImage) {
                 @strongify(item);
                 item.imageView.image = cachedImage;
             }
             fetchCompletion:^(NSImage *fetchedImage, BOOL isCached) {
                 [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                     @strongify(item);
                     context.duration = animationDuration;
                     context.timingFunction = timingFunction;
                     item.imageView.animator.alphaValue = 0;

                 } completionHandler:^{
                     @strongify(item);
                     item.imageView.image = fetchedImage;

                     [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                         @strongify(item);
                         context.duration = animationDuration;
                         context.timingFunction = timingFunction;
                         item.imageView.animator.alphaValue = 1;

                     } completionHandler:nil];
                 }];
             }];
    }

    return item;
}

// MARK: - CCNChannelGridItemDelegate

- (void)handlePlayPauseActionForGridItem:(CCNChannelGridItem *)gridItem {
    [CCNPlayer.sharedInstance setupPlayerWithChannel:gridItem.channel];
}

- (void)handleSubscribeActionForGridItem:(CCNChannelGridItem *)gridItem {
    [PFUser.currentUser toggleSubscriptionForChannel:gridItem.channel];

    let nc = NSNotificationCenter.defaultCenter;
    [nc postNotificationName:CCNChannelSubscriptionUpdatedNotification object:gridItem.channel];
}

// MARK: - CCNChannelGridItemDetailViewDelegate

- (void)gridItemDetailViewShouldClose:(CCNChannelGridItemDetailView *)detailView {
    if (self.collectionView.selectionIndexPaths.count > 0) {
        [self.collectionView deselectAll:self.collectionView.selectionIndexPaths];
    }
}

@end
