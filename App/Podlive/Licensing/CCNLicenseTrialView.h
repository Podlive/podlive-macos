//
//  Created by Frank Gregor on 24.05.17.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNLicenseTrialProgressView;

@interface CCNLicenseTrialView : NSView

@property (nonatomic, readonly) CCNLicenseTrialProgressView *progressView;

@property (nonatomic, readonly) NSTextField *title;
@property (nonatomic, readonly) NSTextField *subTitle;
@property (nonatomic, readonly) NSTextField *price;
@property (nonatomic, readonly) NSTextField *priceTitle;
@property (nonatomic, readonly) NSTextField *currency;
@property (nonatomic, readonly) NSTextField *daysRemaining;

@property (nonatomic, readonly) NSTextField *appName;
@property (nonatomic, readonly) NSTextField *appAuthor;
@property (nonatomic, readonly) NSImageView *appIcon;

@property (nonatomic, readonly) NSButton *useTrialQuitButton;
@property (nonatomic, readonly) NSButton *activateButton;
@property (nonatomic, readonly) NSButton *buyButton;

@end
