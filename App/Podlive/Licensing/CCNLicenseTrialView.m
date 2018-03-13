//
//  Created by Frank Gregor on 24.05.17.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNLicenseTrialView.h"
#import "CCNLicenseTrialProgressView.h"

@interface CCNLicenseTrialView ()
@property (nonatomic, strong) NSView *productContainer;
@end

@implementation CCNLicenseTrialView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;
    self.frame = NSMakeRect(0, 0, 450.0, 300.0);

    [self setupUI];

    return self;
}

- (void)setupUI {
    let title = [self defaultTextField];
    title.font = [NSFont systemFontOfSize:23.0];
    title.textColor = [NSColor controlTextColor];
    _title = title;
    [self addSubview:_title];

    let subTitle = [self defaultTextField];
    subTitle.font = [NSFont systemFontOfSize:15.0];
    subTitle.textColor = [NSColor controlLightTextColor];
    subTitle.usesSingleLineMode = NO;
    subTitle.maximumNumberOfLines = 3;
    [subTitle sizeToFit];
    _subTitle = subTitle;
    [self addSubview:_subTitle];


    let daysRemaining = [self defaultTextField];
    daysRemaining.font = [NSFont boldSystemFontOfSize:NSFont.systemFontSize];
    daysRemaining.textColor = [NSColor controlTextColor];
    daysRemaining.alignment = NSTextAlignmentCenter;
    _daysRemaining = daysRemaining;
    [self addSubview:_daysRemaining];

    let progressView = CCNLicenseTrialProgressView.new;
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    _progressView = progressView;
    [self addSubview:_progressView];



    let productContainer = NSView.new;
    productContainer.translatesAutoresizingMaskIntoConstraints = NO;
    productContainer.backgroundColor = NSColor.whiteColor;
    productContainer.layer.borderColor = NSColor.grayColor.CGColor;
    productContainer.layer.borderWidth = 0.5;
    _productContainer = productContainer;
    [self addSubview:_productContainer];

    let icon = [NSImage imageNamed:@"app-icon"];
    icon.size = NSMakeSize(64.0, 64.0);
    let appIcon = [NSImageView imageViewWithImage:icon];
    appIcon.translatesAutoresizingMaskIntoConstraints = NO;
    _appIcon = appIcon;
    [_productContainer addSubview:_appIcon];

    let appName = [self defaultTextField];
    appName.font = [NSFont boldSystemFontOfSize:18.0];
    appName.textColor = [NSColor controlTextColor];
    appName.stringValue = [NSApplication applicationName];
    _appName = appName;
    [_productContainer addSubview:_appName];

    let appAuthor = [self defaultTextField];
    appAuthor.font = [NSFont systemFontOfSize:15.0];
    appAuthor.textColor = [NSColor controlTextColor];
    _appAuthor = appAuthor;
    [_productContainer addSubview:_appAuthor];

    let price = [self defaultTextField];
    price.font = [NSFont systemFontOfSize:21.0];
    price.textColor = [NSColor controlTextColor];
    _price = price;
    [_productContainer addSubview:_price];



    let useTrialQuitButton = [self defaultButtonWithTitle:@""];
    _useTrialQuitButton = useTrialQuitButton;
    [self addSubview:_useTrialQuitButton];

    let activateButton = [self defaultButtonWithTitle:NSLocalizedString(@"Activate License", @"Button Label")];
    _activateButton = activateButton;
    [_activateButton sizeToFit];
    [self addSubview:_activateButton];

    let buyButton = [self defaultButtonWithTitle:NSLocalizedString(@"Buy License", @"Button Label")];
    buyButton.keyEquivalent = @"\r";
    _buyButton = buyButton;
    [_buyButton sizeToFit];
    [self addSubview:_buyButton];
}

- (void)updateConstraints {
    var constraints = NSMutableArray.new;

    [constraints addObjectsFromArray:@[
        [self.title.topAnchor constraintEqualToAnchor:self.title.superview.topAnchor constant:kOuterEdgeMargin],
        [self.title.centerXAnchor constraintEqualToAnchor:self.title.superview.centerXAnchor],
//        [self.title.rightAnchor constraintEqualToAnchor:self.title.superview.rightAnchor constant:-kOuterEdgeMargin],

        [self.subTitle.topAnchor constraintEqualToAnchor:self.title.bottomAnchor constant:kInnerEdgeMargin],
//        [self.subTitle.centerXAnchor constraintEqualToAnchor:self.title.superview.centerXAnchor],
        [self.subTitle.leftAnchor constraintEqualToAnchor:self.subTitle.superview.leftAnchor constant:kOuterEdgeMargin],
        [self.subTitle.rightAnchor constraintEqualToAnchor:self.subTitle.superview.rightAnchor  constant:-kOuterEdgeMargin],

        [self.daysRemaining.topAnchor constraintEqualToAnchor:self.subTitle.bottomAnchor constant:kInnerEdgeMargin*4],
        [self.daysRemaining.leftAnchor constraintEqualToAnchor:self.daysRemaining.superview.leftAnchor constant:kOuterEdgeMargin],
        [self.daysRemaining.rightAnchor constraintEqualToAnchor:self.daysRemaining.superview.rightAnchor constant:-kOuterEdgeMargin],

        [self.progressView.topAnchor constraintEqualToAnchor:self.daysRemaining.bottomAnchor constant:kInnerEdgeMargin],
        [self.progressView.leftAnchor constraintEqualToAnchor:self.progressView.superview.leftAnchor constant:kOuterEdgeMargin],
        [self.progressView.rightAnchor constraintEqualToAnchor:self.progressView.superview.rightAnchor constant:-kOuterEdgeMargin],
        [self.progressView.heightAnchor constraintEqualToConstant:10.0],

        [self.productContainer.topAnchor constraintEqualToAnchor:self.progressView.bottomAnchor constant:kInnerEdgeMargin*2],
        [self.productContainer.leftAnchor constraintEqualToAnchor:self.productContainer.superview.leftAnchor constant:-self.productContainer.layer.borderWidth],
        [self.productContainer.rightAnchor constraintEqualToAnchor:self.productContainer.superview.rightAnchor constant:self.productContainer.layer.borderWidth*2],

        [self.appIcon.leftAnchor constraintEqualToAnchor:self.appIcon.superview.leftAnchor constant:kOuterEdgeMargin],
        [self.appIcon.topAnchor constraintEqualToAnchor:self.appIcon.superview.topAnchor constant:kInnerEdgeMargin],
        [self.appIcon.bottomAnchor constraintEqualToAnchor:self.appIcon.superview.bottomAnchor constant:-kInnerEdgeMargin],
        [self.appIcon.widthAnchor constraintEqualToConstant:self.appIcon.image.size.width],
        [self.appIcon.heightAnchor constraintEqualToConstant:self.appIcon.image.size.height],

        [self.appName.topAnchor constraintEqualToAnchor:self.appIcon.topAnchor constant:kInnerEdgeMargin],
        [self.appName.leftAnchor constraintEqualToAnchor:self.appIcon.rightAnchor constant:kOuterEdgeMargin],

        [self.appAuthor.leftAnchor constraintEqualToAnchor:self.appName.leftAnchor],
        [self.appAuthor.bottomAnchor constraintEqualToAnchor:self.appIcon.bottomAnchor constant:-kInnerEdgeMargin],

        [self.price.centerYAnchor constraintEqualToAnchor:self.price.superview.centerYAnchor],
        [self.price.rightAnchor constraintEqualToAnchor:self.price.superview.rightAnchor constant:-kOuterEdgeMargin],

        [self.useTrialQuitButton.leftAnchor constraintEqualToAnchor:self.useTrialQuitButton.superview.leftAnchor constant:kOuterEdgeMargin],
        [self.useTrialQuitButton.bottomAnchor constraintEqualToAnchor:self.useTrialQuitButton.superview.bottomAnchor constant:-kOuterEdgeMargin],

        [self.buyButton.rightAnchor constraintEqualToAnchor:self.buyButton.superview.rightAnchor constant:-kOuterEdgeMargin],
        [self.buyButton.bottomAnchor constraintEqualToAnchor:self.buyButton.superview.bottomAnchor constant:-kOuterEdgeMargin],
        [self.activateButton.rightAnchor constraintEqualToAnchor:self.buyButton.leftAnchor constant:-kInnerEdgeMargin],
        [self.activateButton.bottomAnchor constraintEqualToAnchor:self.activateButton.superview.bottomAnchor constant:-kOuterEdgeMargin],
    ]];
    [NSLayoutConstraint activateConstraints:constraints];
    constraints = nil;

    [super updateConstraints];
}

// MARK: - Helper

- (__kindof NSTextField *)defaultTextField {
    let _textField = NSTextField.new;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.wantsLayer = YES;
    _textField.usesSingleLineMode = YES;
    _textField.backgroundColor = NSColor.clearColor;
    _textField.bordered = NO;
    _textField.editable = NO;
    _textField.selectable = NO;
    
    return _textField;
}

- (NSButton *)defaultButtonWithTitle:(NSString *)buttonTitle {
    let _button = [NSButton buttonWithTitle:buttonTitle actionHandler:nil];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.wantsLayer = YES;
    _button.state = NSOffState;
    [_button setButtonType:NSButtonTypeMomentaryPushIn];
    
    return _button;
}

@end
