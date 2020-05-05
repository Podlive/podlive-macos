//
//  Created by Frank Gregor on 27/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@import Carbon;

#import "CCNApplicationDelegate.h"
#import "CCNApplicationViewController.h"
#import "CCNChannelGridItemView.h"
#import "CCNChannelGridItemControlView.h"
#import "CCNChannel.h"

#import "CCNPlayer.h"
#import "CCNPlayerView.h"
#import "CCNPlayerViewController.h"
#import "CCNPlayerPlayPauseButton.h"

#import "NSFont+Podlive.h"
#import "NSView+Podlive.h"


static const CGFloat kImageCornerRadius = 5.0;
//static const CGFloat kImageContainerEdgeInset = 6.0;
static const CGFloat kLabelTopConstraintConstant = 2.0;


@interface CCNChannelGridItemView ()
@property (nonatomic, strong) NSView *imageContainer;
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, strong) NSTextField *channelStatusLabel;
@end

@implementation CCNChannelGridItemView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.wantsLayer = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.layer.cornerRadius = kImageCornerRadius;

    [self setupUI];
    [self setupNotifications];

    return self;
}

- (void)setupUI {
    let imageContainer = NSView.new;
    imageContainer.translatesAutoresizingMaskIntoConstraints = NO;
    imageContainer.layer.cornerRadius = kImageCornerRadius;
    imageContainer.shadow = nil;
    imageContainer.layer.masksToBounds = NO;
    imageContainer.backgroundColor = NSColor.clearColor;
    self.imageContainer = imageContainer;
    [self addSubview:self.imageContainer];


    let imageView = [[NSImageView alloc] initWithFrame:NSZeroRect];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.wantsLayer = YES;
    imageView.layer.cornerRadius = self.imageContainer.layer.cornerRadius;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0.0;
    imageView.layer.borderColor = nil;
    imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    self.imageView = imageView;
    [self.imageContainer addSubview:self.imageView];


    let textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.maximumNumberOfLines = 2;
    textField.backgroundColor = NSColor.clearColor;
    textField.wantsLayer = YES;
    textField.selectable = NO;
    textField.editable = NO;
    textField.bordered = NO;
    textField.textColor = NSColor.controlTextColor;
    textField.font = [NSFont fontWithName:NSFont.podliveRegularFontName size:13.0];
    self.textField = textField;
    [self addSubview:self.textField];


    let channelStatusLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
    channelStatusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    channelStatusLabel.backgroundColor = NSColor.clearColor;
    channelStatusLabel.wantsLayer = YES;
    channelStatusLabel.selectable = NO;
    channelStatusLabel.editable = NO;
    channelStatusLabel.bordered = NO;
    channelStatusLabel.textColor = [NSColor.controlTextColor colorWithAlphaComponent:0.42];
    channelStatusLabel.alignment = NSTextAlignmentCenter;
    channelStatusLabel.font = [NSFont fontWithName:NSFont.podliveRegularFontName size:13.0];
    self.channelStatusLabel = channelStatusLabel;
    [self addSubview:self.channelStatusLabel];
}

- (void)setupNotifications {

}

// MARK: - Handle Keyboard Events

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    let flags = event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask;
    let keyCode = event.keyCode;
    
    if (kVK_Escape == keyCode) {
        
    }
    
    // Search triggered: command+F
    if (NSEventModifierFlagCommand == flags && kVK_ANSI_F == keyCode) {
        [NSNotificationCenter.defaultCenter postNotificationName:CCNSearchViewShouldAppearNotification object:nil];
        return YES;
    }
    
    return NO;
}

// MARK: - Auto Layout

- (void)updateConstraints {
    var constraints = NSMutableArray.new;

    [constraints addObjectsFromArray:@[
        [self.imageView.centerXAnchor constraintEqualToAnchor:self.imageView.superview.centerXAnchor],
        [self.imageView.topAnchor constraintEqualToAnchor:self.imageView.superview.topAnchor],
        [self.imageView.widthAnchor constraintEqualToAnchor:self.imageView.superview.widthAnchor],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor],

        [self.textField.topAnchor constraintEqualToAnchor:self.imageContainer.bottomAnchor constant:kLabelTopConstraintConstant],
        [self.textField.leftAnchor constraintEqualToAnchor:self.textField.superview.leftAnchor],
        [self.textField.rightAnchor constraintEqualToAnchor:self.textField.superview.rightAnchor],

        [self.channelStatusLabel.topAnchor constraintEqualToAnchor:self.textField.bottomAnchor],
        [self.channelStatusLabel.leftAnchor constraintEqualToAnchor:self.channelStatusLabel.superview.leftAnchor],
        [self.channelStatusLabel.rightAnchor constraintEqualToAnchor:self.channelStatusLabel.superview.rightAnchor],

        [self.imageContainer.topAnchor constraintEqualToAnchor:self.imageContainer.superview.topAnchor],
        [self.imageContainer.centerXAnchor constraintEqualToAnchor:self.imageContainer.superview.centerXAnchor],
        [self.imageContainer.widthAnchor constraintEqualToAnchor:self.imageContainer.superview.widthAnchor],
        [self.imageContainer.heightAnchor constraintEqualToAnchor:self.imageContainer.widthAnchor],
    ]];

    if (self.controlView) {
        [constraints addObjectsFromArray:@[
            [self.controlView.topAnchor constraintEqualToAnchor:self.controlView.superview.topAnchor],
            [self.controlView.leftAnchor constraintEqualToAnchor:self.controlView.superview.leftAnchor],
            [self.controlView.rightAnchor constraintEqualToAnchor:self.controlView.superview.rightAnchor],
            [self.controlView.bottomAnchor constraintEqualToAnchor:self.controlView.superview.bottomAnchor],
        ]];
    }
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = nil;

    [super updateConstraints];
}

@end
