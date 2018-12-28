//
//  Created by Frank Gregor on 13.12.17.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannelGridNoStreamItemView.h"
#import "NSColor+Podlive.h"
#import "NSFont+Podlive.h"
#import "NSImage+Tools.h"
#import "NSView+Podlive.h"

static const CGFloat kViewCornerRadius = 5.0;
static const NSEdgeInsets kContainerEdgeInsets = {8.0, 8.0, 0.0, 8.0};

@interface CCNChannelGridNoStreamItemView()
@property (nonatomic, strong) NSView *container;
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, strong) NSImageView *icon;
@end

@implementation CCNChannelGridNoStreamItemView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.wantsLayer = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self setupUI];

    return self;
}

- (void)setupUI {
    let container = NSView.new;
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.wantsLayer = YES;
    container.layer.cornerRadius = kViewCornerRadius;
    container.backgroundColor = NSColor.lightGrayColor;
    self.container = container;
    [self addSubview:self.container];


    let icon = NSImageView.new;
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    icon.layer.cornerRadius  = 5.0;
    icon.layer.masksToBounds = YES;
    icon.imageScaling = NSImageScaleProportionallyUpOrDown;

    let image = [[NSImage imageNamed:@"no-live-stream"] imageTintedWithColor:NSColor.controlTextColor];
    image.size = NSMakeSize(56.0, 56.0);
    icon.image = image;
    self.icon = icon;
    [self.container addSubview:self.icon];


    let textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.maximumNumberOfLines = 2;
    textField.backgroundColor = NSColor.clearColor;
    textField.wantsLayer = YES;
    textField.selectable = NO;
    textField.editable = NO;
    textField.bordered = NO;
    textField.textColor = NSColor.controlTextColor;
    textField.font = [NSFont fontWithName:NSFont.podliveRegularFontName size:20.0];
    self.textField = textField;
    [self.container addSubview:self.textField];
}

// MARK: - Auto Layout

- (void)updateConstraints {
    var constraints = NSMutableArray.new;

    [constraints addObjectsFromArray:@[
        [self.container.topAnchor constraintEqualToAnchor:self.container.superview.topAnchor constant:kContainerEdgeInsets.top],
        [self.container.bottomAnchor constraintEqualToAnchor:self.container.superview.bottomAnchor constant:-kContainerEdgeInsets.bottom],
        [self.container.leftAnchor constraintEqualToAnchor:self.container.superview.leftAnchor constant:kContainerEdgeInsets.left],
        [self.container.rightAnchor constraintEqualToAnchor:self.container.superview.rightAnchor constant:-kContainerEdgeInsets.right],

        [self.icon.centerXAnchor constraintEqualToAnchor:self.icon.superview.centerXAnchor],
        [self.icon.centerYAnchor constraintEqualToAnchor:self.icon.superview.centerYAnchor constant:-self.icon.image.size.height/4],

        [self.textField.centerXAnchor constraintEqualToAnchor:self.textField.superview.centerXAnchor],
        [self.textField.topAnchor constraintEqualToAnchor:self.icon.bottomAnchor]
    ]];

    [NSLayoutConstraint activateConstraints:constraints];
    constraints = nil;

    [super updateConstraints];
}

// MARK: - Custom Accessors

- (void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    self.textField.stringValue = labelText;
}

// MARK: - NSView

- (void)drawRect:(NSRect)dirtyRect {
    self.container.backgroundColor = [NSColor.gridItemDetailColor colorWithAlphaComponent:0.5];
    self.textField.textColor = NSColor.controlTextColor;
    self.icon.image = [self.icon.image imageTintedWithColor:NSColor.controlTextColor];
}

@end
