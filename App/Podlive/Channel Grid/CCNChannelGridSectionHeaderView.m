//
//  Created by Frank Gregor on 03/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannelGridSectionHeaderView.h"
#import "NSColor+Podlive.h"
#import "NSFont+Podlive.h"

@interface CCNChannelGridSectionHeaderView ()
@property (nonatomic, strong) NSTextField *titleTextField;
@end

@implementation CCNChannelGridSectionHeaderView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _headerSection = CCNChannelSectionLive;

    [self setupUI];

    return self;
}

- (void)setupUI {
    let titleTextField = NSTextField.new;
    titleTextField.translatesAutoresizingMaskIntoConstraints = NO;
    titleTextField.selectable = NO;
    titleTextField.editable = NO;
    titleTextField.font = [NSFont fontWithName:NSFont.podliveMediumFontName size:16.0];
    titleTextField.alignment = NSTextAlignmentLeft;
    titleTextField.bordered = NO;
    titleTextField.textColor = NSColor.gridSectionHeaderTextColor;
    titleTextField.backgroundColor = NSColor.clearColor;
    self.titleTextField = titleTextField;
    [self addSubview:self.titleTextField];
}

- (void)updateConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.titleTextField.leftAnchor constraintEqualToAnchor:self.titleTextField.superview.leftAnchor constant:kOuterEdgeMargin/2],
        [self.titleTextField.centerYAnchor constraintEqualToAnchor:self.titleTextField.superview.centerYAnchor constant:-2],
    ]];

    [super updateConstraints];
}

// MARK: - Helper

- (void)updateUI {
    let streamsFormatString = (self.numberOfStreams == 1 ? @"Stream" : @"Streams");
    let statusFormatString = (self.headerSection == CCNChannelSectionLive ? @"Live" : @"Offline");

    self.titleTextField.stringValue = [[NSString stringWithFormat:@"%@ %@ %@", @(self.numberOfStreams), statusFormatString, streamsFormatString] uppercaseString];
}

// MARK: - Custom Accessors

- (void)setNumberOfStreams:(NSInteger)numberOfStreams {
    _numberOfStreams = numberOfStreams;
    [self updateUI];
}

- (void)setHeaderSection:(CCNHeaderType)headerSection {
    _headerSection = headerSection;
    [self updateUI];
}

@end
