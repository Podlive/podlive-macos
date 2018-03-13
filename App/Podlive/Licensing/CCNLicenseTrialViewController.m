//
//  Created by Frank Gregor on 24/05/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Paddle/PADDataStore.h>
#import "PADDataStore+Properties.h"

#import "AppDelegate.h"
#import "CCNLicenseTrialViewController.h"
#import "CCNLicenseTrialView.h"
#import "CCNLicenseTrialProgressView.h"

@interface CCNLicenseTrialViewController ()
@end

@implementation CCNLicenseTrialViewController

- (void)loadView {
    self.view = CCNLicenseTrialView.new;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear {
    [super viewWillAppear];

    let padDataStore  = PADDataStore.sharedInstance;

//    daysRemaining = 0;
    let contentView = (CCNLicenseTrialView *)self.view;
    if (padDataStore.daysRemaining > 0) {
        contentView.useTrialQuitButton.title = NSLocalizedString(@"Continue Trial", @"Button Label");
        contentView.useTrialQuitButton.actionHandler = ^(NSButton *actionButton) {
            [self.navigationController dismissController:self];
        };
    }
    else {
        contentView.useTrialQuitButton.title = [NSString stringWithFormat:NSLocalizedString(@"Quit %@", @"Button Label"), padDataStore.productName];
        contentView.useTrialQuitButton.actionHandler = ^(NSButton *actionButton) {
//            [self.delegate applicationShouldTerminateAfterTrialPeriodEnds];
        };
    }
    [contentView.useTrialQuitButton sizeToFit];

    contentView.progressView.borderColor  = NSColor.lightGrayColor;
    contentView.progressView.activeColor  = NSColor.trialRemainingColor;
    contentView.progressView.progress     = (1.0 / padDataStore.trialLength) * padDataStore.daysRemaining;
    contentView.title.stringValue         = [NSString stringWithFormat:NSLocalizedString(@"Thank you for trying %@", @"LicenseTrialView Title"), padDataStore.productName];
    contentView.subTitle.stringValue      = [NSString stringWithFormat:NSLocalizedString(@"Thank you for downloading a trial of %@. I hope you enjoy it!", @"LicenseTrialView Subtitle"), padDataStore.productName];
    contentView.daysRemaining.stringValue = [NSString stringWithFormat:NSLocalizedString(@"You have %@ days remaining in your trial period.", @"LicenseTrialView Days Remaining Message"), @(padDataStore.daysRemaining)];
    contentView.appAuthor.stringValue     = [NSString stringWithFormat:NSLocalizedString(@"by %@", @"App Author Name Label"), padDataStore.vendorName];

    NSNumberFormatter *priceFormatter = NSNumberFormatter.new;
    priceFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    priceFormatter.locale = NSLocale.currentLocale;
    contentView.price.stringValue = [NSString stringWithFormat:NSLocalizedString(@"%@", @"Currency Label"), [priceFormatter stringFromNumber:padDataStore.currentPrice]];
}

@end
