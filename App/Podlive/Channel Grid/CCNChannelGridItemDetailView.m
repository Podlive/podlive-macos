//
//  Created by Frank Gregor on 20/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannelGridItemDetailView.h"
#import "CCNChannelGridItem.h"
#import "CCNChannel.h"
#import "CCNChannelGridFlowLayout.h"

#import "NSColor+Podlive.h"
#import "NSFont+Podlive.h"
#import "NSImage+Podlive.h"


static const CGFloat kCCNChannelGridItemArrowHeight = 11.0;
static const CGFloat kCCNChannelGridItemArrowWidth = 42.0;



@interface CCNChannelGridItemDetailView ()
@property (nonatomic, strong) NSView *container;
@property (nonatomic, readonly) NSEdgeInsets containerEgeInset;
@property (nonatomic, readonly) NSSize arrowSize;

@property (nonatomic, strong) NSImageView *coverart;
@property (nonatomic, strong) NSTextField *title;
@property (nonatomic, strong) NSTextField *author;
@property (nonatomic, strong) NSTextField *channelDesription;
@property (nonatomic, strong) NSButton *websiteButton;
@property (nonatomic, strong) NSButton *twitterButton;
@property (nonatomic, strong) NSButton *chatButton;
@property (nonatomic, readonly) CGFloat imageEdgeLength;
@end

@implementation CCNChannelGridItemDetailView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    return self;
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (event.keyCode == CCNEscapeKeyCode) {
        if ([self.delegate respondsToSelector:@selector(gridItemDetailViewShouldClose:)]) {
            [self.delegate gridItemDetailViewShouldClose:self];
        }
        return YES;
    }
    else {
        return [super performKeyEquivalent:event];
    }
}

- (void)dealloc {
    CCNLogInfo(@"dealloc");

    _channel = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.coverart removeFromSuperview];
    self.coverart = nil;

    [self.title removeFromSuperview];
    self.title = nil;

    [self.author removeFromSuperview];
    self.author = nil;

    [self.channelDesription removeFromSuperview];
    self.channelDesription = nil;

    [self.websiteButton removeFromSuperview];
    self.websiteButton = nil;

    [self.twitterButton removeFromSuperview];
    self.twitterButton = nil;

    [self.chatButton removeFromSuperview];
    self.chatButton = nil;

    [self.container removeFromSuperview];
    self.container = nil;

    self.delegate = nil;
    self.selectedItemFrame = NSZeroRect;
}

- (void)setupUI {
    @weakify(self);

    let container = NSView.new;
    container.translatesAutoresizingMaskIntoConstraints = NO;
    self.container = container;
    [self addSubview:self.container];


    let coverart = NSImageView.new;
    coverart.translatesAutoresizingMaskIntoConstraints = NO;
    coverart.layer.cornerRadius  = 5.0;
    coverart.layer.masksToBounds = YES;
    coverart.imageScaling = NSImageScaleProportionallyUpOrDown;
    self.coverart = coverart;
    [self.container addSubview:self.coverart];

    [NSImage loadFromURL:self.channel.coverartThumbnail200URL
        placeholderImage:NSImage.channelPlaceholder
         prefetchHandler:^(NSImage *cachedImage) {
             @strongify(self);
             self.coverart.image = cachedImage;
         }
         fetchCompletion:^(NSImage *fetchedImage, BOOL isCached) {
             @strongify(self);
             self.coverart.image = fetchedImage;
         }];
    
    
    let title = [self defaultTextField];
    title.font = [NSFont fontWithName:NSFont.podliveBoldFontName size:26.0];
    title.textColor = NSColor.gridItemDetailTextColor;
    title.stringValue = self.channel.name;
    title.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [title sizeToFit];
    self.title = title;
    [self.container addSubview:self.title];


    if (self.channel.creator && ![self.channel.creator isEqual:[NSNull null]]) {
        let author = [self defaultTextField];
        author.font = [NSFont fontWithName:NSFont.podliveRegularFontName size:13.0];
        author.textColor = NSColor.disabledControlTextColor;
        author.stringValue = [self.channel.creator copy];
        author.cell.wraps = YES;
        author.lineBreakMode = NSLineBreakByTruncatingTail;
        [author sizeToFit];
        self.author = author;
        [self.container addSubview:self.author];
    }


    if (self.channel.channelDescription) {
        let channelDesription = [self defaultTextField];
        channelDesription.font = [NSFont fontWithName:NSFont.podliveRegularFontName size:16.0];
        channelDesription.textColor = NSColor.gridItemDetailTextColor;
        channelDesription.stringValue = [self.channel.channelDescription copy];
        channelDesription.usesSingleLineMode = NO;
        channelDesription.maximumNumberOfLines = 7;
        [channelDesription sizeToFit];
        self.channelDesription = channelDesription;
        [self.container addSubview:self.channelDesription];
    }


    if (self.channel.websiteURL) {
        let websiteButton = [self defaultButtonWithImageName:@"detail-website"];
        websiteButton.actionHandler = ^(NSButton *actionButton) {
            @strongify(self);
            [NSWorkspace.sharedWorkspace openURL:self.channel.websiteURL];
        };
        self.websiteButton = websiteButton;
        [self.container addSubview:self.websiteButton];
    }


    if (self.channel.twitterURL) {
        let twitterButton = [self defaultButtonWithImageName:@"detail-twitter"];
        twitterButton.actionHandler = ^(NSButton *actionButton) {
            @strongify(self);
            [NSWorkspace.sharedWorkspace openURL:self.channel.twitterURL];
        };
        self.twitterButton = twitterButton;
        [self.container addSubview:self.twitterButton];
    }


    if (self.channel.chatURL) {
        let chatButton = [self defaultButtonWithImageName:@"detail-chat"];
        chatButton.actionHandler = ^(NSButton *actionButton) {
            @strongify(self);
            [NSWorkspace.sharedWorkspace openURL:self.channel.chatURL];
        };
        self.chatButton = chatButton;
        [self.container addSubview:self.chatButton];
    }
}

- (void)updateConstraints {
    var constraints = NSMutableArray.new;

    [constraints addObjectsFromArray:@[
        [self.container.topAnchor constraintLessThanOrEqualToAnchor:self.topAnchor constant:self.arrowSize.height],
        [self.container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.container.leftAnchor constraintEqualToAnchor:self.leftAnchor],
        [self.container.rightAnchor constraintEqualToAnchor:self.rightAnchor],

        [self.coverart.centerYAnchor constraintEqualToAnchor:self.coverart.superview.centerYAnchor],
        [self.coverart.leftAnchor constraintEqualToAnchor:self.coverart.superview.leftAnchor constant:self.containerEgeInset.left],
        [self.coverart.heightAnchor constraintEqualToConstant:self.imageEdgeLength],
        [self.coverart.widthAnchor constraintEqualToAnchor:self.coverart.heightAnchor],

        [self.title.topAnchor constraintEqualToAnchor:self.coverart.topAnchor],
        [self.title.leftAnchor constraintEqualToAnchor:self.coverart.rightAnchor constant:kOuterEdgeMargin],
        [self.title.rightAnchor constraintEqualToAnchor:self.title.superview.rightAnchor constant:-kOuterEdgeMargin],
        [self.title.heightAnchor constraintEqualToConstant:NSHeight(self.title.frame)],
    ]];

    var leftAnchor   = self.title.leftAnchor;
    var rightAnchor  = self.coverart.rightAnchor;
    var bottomAnchor = self.title.bottomAnchor;

    if (self.author) {
        [constraints addObjectsFromArray:@[
            [self.author.leftAnchor constraintEqualToAnchor:self.title.leftAnchor],
            [self.author.topAnchor constraintEqualToAnchor:bottomAnchor constant:-kInnerEdgeMargin/2],
            [self.author.heightAnchor constraintEqualToConstant:NSHeight(self.author.frame)],
        ]];
        bottomAnchor = self.author.bottomAnchor;
    }

    if (self.channelDesription) {
        [constraints addObjectsFromArray:@[
            [self.channelDesription.topAnchor constraintEqualToAnchor:bottomAnchor constant:kInnerEdgeMargin],
            [self.channelDesription.leftAnchor constraintEqualToAnchor:leftAnchor],
            [self.channelDesription.rightAnchor constraintEqualToAnchor:self.channelDesription.superview.rightAnchor constant:-self.containerEgeInset.right],
        ]];
        bottomAnchor = self.channelDesription.bottomAnchor;
    }

    if (self.websiteButton) {
        [constraints addObjectsFromArray:@[
            [self.websiteButton.leftAnchor constraintEqualToAnchor:rightAnchor constant:kOuterEdgeMargin],
            [self.websiteButton.bottomAnchor constraintEqualToAnchor:self.coverart.bottomAnchor],
            [self.websiteButton.topAnchor constraintGreaterThanOrEqualToAnchor:bottomAnchor]
        ]];
        rightAnchor = self.websiteButton.rightAnchor;
    }

    if (self.twitterButton) {
        [constraints addObjectsFromArray:@[
            [self.twitterButton.leftAnchor constraintEqualToAnchor:rightAnchor constant:kOuterEdgeMargin],
            [self.twitterButton.bottomAnchor constraintEqualToAnchor:self.coverart.bottomAnchor],
            [self.twitterButton.topAnchor constraintGreaterThanOrEqualToAnchor:bottomAnchor]
        ]];
        rightAnchor = self.twitterButton.rightAnchor;
    }

    if (self.chatButton) {
        [constraints addObjectsFromArray:@[
            [self.chatButton.leftAnchor constraintEqualToAnchor:rightAnchor constant:kOuterEdgeMargin],
            [self.chatButton.bottomAnchor constraintEqualToAnchor:self.coverart.bottomAnchor],
            [self.chatButton.topAnchor constraintGreaterThanOrEqualToAnchor:bottomAnchor]
        ]];
    }

    [NSLayoutConstraint activateConstraints:constraints];

    constraints = nil;
    rightAnchor = nil;

    [super updateConstraints];
}

// MARK: - Custom Accessors

- (NSEdgeInsets)containerEgeInset {
    let containerEgeInset = NSEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
    return containerEgeInset;
}

- (CGFloat)imageEdgeLength {
    let imageEdgeLength = kDetailViewExpandedHeight - (self.containerEgeInset.top + self.containerEgeInset.bottom + self.arrowSize.height);
    return imageEdgeLength;
}

- (NSSize)arrowSize {
    return NSMakeSize(kCCNChannelGridItemArrowWidth, kCCNChannelGridItemArrowHeight);
}

- (void)setChannel:(CCNChannel *)channel {
    _channel = channel;

    [self setupUI];
    [self setNeedsDisplay:YES];
    [self setNeedsUpdateConstraints:YES];
}

// MARK: - Helper

- (NSTextField *)defaultTextField {
    let _textField = NSTextField.new;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.wantsLayer = YES;
    _textField.textColor = NSColor.textColor;
    _textField.backgroundColor = NSColor.clearColor;
    _textField.bordered = NO;
    _textField.editable = NO;
    _textField.selectable = YES;

    return _textField;
}

- (NSButton *)defaultButtonWithImageName:(NSString *)imageName {
    var _image = [NSImage imageNamed:imageName];
    _image = [_image imageTintedWithColor:NSColor.gridItemDetailTextColor];
    _image.size = NSMakeSize(24.0, 24.0);

    let _button = [NSButton buttonWithImage:_image actionHandler:nil];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.wantsLayer = YES;
    _button.bordered = NO;

    [_button sizeToFit];

    return _button;
}

// MARK: - NSView Drawing

- (void)drawRect:(NSRect)dirtyRect {
    let itemCenterPoint = NSMakePoint(NSMinX(self.selectedItemFrame) + NSWidth(self.selectedItemFrame)/2, NSMinY(self.selectedItemFrame) + NSHeight(self.selectedItemFrame)/2);
    let backgroundRect  = NSMakeRect(NSMinX(self.bounds), NSMinY(self.bounds), NSWidth(self.bounds)+2, NSHeight(self.bounds) - self.arrowSize.height);
    let arrowLeftPoint  = NSMakePoint(itemCenterPoint.x - self.arrowSize.width/2, NSMaxY(backgroundRect));
    let arrowTopPoint   = NSMakePoint(itemCenterPoint.x, NSMaxY(self.bounds) - 1);
    let arrowRightPoint = NSMakePoint(itemCenterPoint.x + self.arrowSize.width/2, NSMaxY(backgroundRect));

    let backgroundPath = NSBezierPath.bezierPath;
    backgroundPath.lineWidth = 0.5;

    [backgroundPath moveToPoint:NSMakePoint(NSMinX(backgroundRect), NSMaxY(backgroundRect))];
    [backgroundPath lineToPoint:arrowLeftPoint];
    [backgroundPath curveToPoint:arrowTopPoint
                   controlPoint1:NSMakePoint(itemCenterPoint.x - self.arrowSize.width/4, NSMaxY(backgroundRect))
                   controlPoint2:NSMakePoint(itemCenterPoint.x - self.arrowSize.width/7, NSMaxY(backgroundRect) + self.arrowSize.height)];
    [backgroundPath curveToPoint:arrowRightPoint
                   controlPoint1:NSMakePoint(itemCenterPoint.x + self.arrowSize.width/7, NSMaxY(backgroundRect) + self.arrowSize.height)
                   controlPoint2:NSMakePoint(itemCenterPoint.x + self.arrowSize.width/4, NSMaxY(backgroundRect))];
    [backgroundPath lineToPoint:NSMakePoint(NSMaxX(backgroundRect), NSMaxY(backgroundRect))];
    [backgroundPath lineToPoint:NSMakePoint(NSMaxX(backgroundRect), NSMinY(backgroundRect))];
    [backgroundPath lineToPoint:NSMakePoint(NSMinX(backgroundRect), NSMinY(backgroundRect))];
    [backgroundPath closePath];

    [[NSColor.gridItemDetailColor colorWithAlphaComponent:self.container.alphaValue] setFill];
    [backgroundPath fill];

    [[NSColor.gridItemDetailTopLineColor colorWithAlphaComponent:self.container.alphaValue] setStroke];
    [backgroundPath stroke];


    let bottomLinePath = NSBezierPath.bezierPath;
    bottomLinePath.lineWidth = 1;
    [bottomLinePath moveToPoint:NSMakePoint(NSMinX(backgroundRect), NSMinY(backgroundRect)+bottomLinePath.lineWidth/2)];
    [bottomLinePath lineToPoint:NSMakePoint(NSMaxX(backgroundRect), NSMinY(backgroundRect)+bottomLinePath.lineWidth/2)];

    [[NSColor.gridItemDetailBottomLineColor colorWithAlphaComponent:self.container.alphaValue] setStroke];
    [bottomLinePath stroke];
}

@end
