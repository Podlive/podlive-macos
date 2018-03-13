//
//  Created by Frank Gregor on 01/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef void (^CCNSignUpSuccessHandler)(PFUser *user);
typedef void (^CCNSignUpFailureHandler)(NSError *error);
typedef void (^CCNLoginSuccessHandler)(PFUser *user);
typedef void (^CCNLoginFailureHandler)(NSError *error);
typedef void (^CCNLogoutHandler)(NSError *error);
typedef void (^CCNResetPasswordSuccessHandler)(void);
typedef void (^CCNResetPasswordFailureHandler)(NSError *error);
typedef void (^CCNAvatarImageHandler)(NSImage *fetchedImage);

@interface CCNUserManager : NSObject

+ (instancetype)sharedManager;
- (void)startListening;

// MARK: - User Authentication

- (void)updateUserWithCompletion:(CCNEmptyHandler)completion;
- (void)saveAnonymousUser;
- (void)signupInBackgroundWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email success:(CCNSignUpSuccessHandler)success failure:(CCNSignUpFailureHandler)failure;
- (void)loginInBackgroundWithUsername:(NSString *)username password:(NSString *)password success:(CCNLoginSuccessHandler)success failure:(CCNLoginFailureHandler)failure;
- (void)logOutInBackgroundWithCompletion:(CCNLogoutHandler)completion;
- (void)resetPasswordForEmail:(NSString *)email success:(CCNResetPasswordSuccessHandler)success failure:(CCNResetPasswordFailureHandler)failure;

// MARK: - User Content

- (void)avatarImageForUser:(PFUser *)inUser withPlaceholderImage:(NSImage *)placeholderImage completion:(CCNAvatarImageHandler)completion;

@property (nonatomic, readonly) BOOL userIsAuthenticated;
@property (nonatomic, readonly) NSString *userEmail;

@end
