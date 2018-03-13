//
//  Created by Frank Gregor on 23/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//


@protocol CCNUserInfoViewDelegate <NSObject>
- (void)userInfoViewControllerWantsLogoutAction;
@end

@interface CCNUserInfoView : NSView

@property (nonatomic, weak) id<CCNUserInfoViewDelegate> delegate;

@end
