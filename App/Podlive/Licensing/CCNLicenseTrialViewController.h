//
//  Created by Frank Gregor on 24/05/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNLicenseTrialViewController;

@protocol CCNLicenseTrialViewControllerDelegate <NSObject>
- (void)applicationShouldTerminateAfterTrialPeriodEnds;
@end

@interface CCNLicenseTrialViewController : NSViewController

@property (weak) id<CCNLicenseTrialViewControllerDelegate> delegate;

@end
