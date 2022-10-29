//
//  Created by Frank Gregor on 01/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNUserManager.h"
#import "NSString+Tools.h"
#import "CCNImageCache.h"

@interface CCNUserManager ()
@property (assign, getter=isSaveOperationInProgress) BOOL saveOperationInProgress;
@property id notificationObserver;
@end

@implementation CCNUserManager

+ (instancetype)sharedManager {
    static dispatch_once_t _onceToken;
    static id _sharedInstance;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[self alloc] initSingleton];
    });
    return _sharedInstance;
}

- (instancetype)initSingleton {
    self = [super init];
    if (!self) return nil;

    _saveOperationInProgress = NO;
    _notificationObserver = nil;

    return self;
}

- (instancetype)init {
    @throw [[self class] initException];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [[self class] initException];
}

// MARK: - Init Exception

+ (NSException *)initException {
    let exceptionMessage = [NSString stringWithFormat:@"'%@' is a Singleton, and you must NOT init manually! Use +sharedInstance instead.", [self className]];
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:exceptionMessage userInfo:nil];
}

- (void)startListening {
    if (self.notificationObserver) {
        CCNLogError(@"This should never happen! %@ already is notification observer.", [self class]);
        return;
    }

    self.notificationObserver = [NSNotificationCenter.defaultCenter addObserverForName:CCNUserUpdatedNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        let nc = NSNotificationCenter.defaultCenter;

        [PFUser.currentUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [nc postNotificationName:CCNChannelSubscriptionUpdatedNotification object:nil];
            [nc postNotificationName:CCNDidChangeChannelFilterCriteriaNotification object:nil];
        }];

        [PFInstallation.currentInstallation fetchInBackgroundWithBlock:nil];
    }];
}

// MARK: - Auth Management

- (void)updateUserWithCompletion:(CCNEmptyHandler)completion {
    [PFUser.currentUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:CCNUserUpdatedNotification object:nil];
            if (completion) {
                completion();
            }
        });
    }];

    [PFInstallation.currentInstallation fetchInBackground];
}

- (void)saveAnonymousUser {
    let currentUser = PFUser.currentUser;
    let installation = PFInstallation.currentInstallation;

    if ([PFAnonymousUtils isLinkedWithUser:currentUser]) {
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                installation[kUserKeyPath] = currentUser;
                [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        CCNLogInfo(@"anonymous user successfully saved: %@", currentUser);
                    }
                }];
            }
            else {
                CCNLogError(@"could not save currentUser: %@ (%@)", currentUser, error.localizedDescription);
            }
        }];
    }
}

- (void)signupInBackgroundWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email success:(CCNSignUpSuccessHandler)success failure:(CCNSignUpFailureHandler)failure {
    let nc = NSNotificationCenter.defaultCenter;

    let user = PFUser.currentUser;
    user.username = [username copy];
    user.password = [password copy];
    user.email    = [email copy];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (success) {
                success(user);
            }
            [nc postNotificationName:CCNSignUpSuccessNotification object:user];
            [nc postNotificationName:CCNChannelSubscriptionUpdatedNotification object:nil];
        }
        else {
            if (failure) {
                failure(error);
            }
            [nc postNotificationName:CCNSignUpFailureNotification object:error];
        }
    }];
}

- (void)loginInBackgroundWithUsername:(NSString *)username password:(NSString *)password success:(CCNLoginSuccessHandler)success failure:(CCNLoginFailureHandler)failure {
    let nc = NSNotificationCenter.defaultCenter;

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *currentUser, NSError *error) {
        if (currentUser) {
            let installation = PFInstallation.currentInstallation;
            installation[kUserKeyPath] = currentUser;
            
            if (success) {
                success(currentUser);
            }
            [nc postNotificationName:CCNLogInSuccessNotification object:currentUser];
        }
        else {
            if (failure) {
                failure(error);
            }
            [nc postNotificationName:CCNLogInFailureNotification object:error];
        }
    }];
}

- (void)logOutInBackgroundWithCompletion:(PFUserLogoutResultBlock)completion {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        if (!error) {
            if (PFUser.currentUser == nil) {
                [PFUser enableAutomaticUser];
            }

            PFInstallation.currentInstallation.channels = NSArray.new;
            [self saveAnonymousUser];

            [NSNotificationCenter.defaultCenter postNotificationName:CCNLogOutNotification object:nil];

            if (completion) {
                completion(nil);
            }
        }
        else {
            if (completion) {
                completion(error);
            }
        }
    }];
}

- (void)resetPasswordForEmail:(NSString *)email success:(CCNResetPasswordSuccessHandler)success failure:(CCNResetPasswordFailureHandler)failure {
    NSParameterAssert(email != nil);

    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (success) {
                success();
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

- (void)deleteAccountWithCompletion:(CCNDeleteAccountResultHandler)completion {
    if (PFUser.currentUser.delete) {
        [self logOutInBackgroundWithCompletion:^(NSError *error) {
            if (error != nil) {
                completion(NO);
                return;
            }
            completion(YES);
        }];
    } else {
        completion(NO);
    }
}

// MARK: - User Content

// Info's found here: http://en.gravatar.com/site/implement/images/
- (void)avatarImageForUser:(PFUser *)inUser withPlaceholderImage:(NSImage *)placeholderImage completion:(CCNAvatarImageHandler)completion {
    let avatarSize = 96.0;
    if (inUser.email) {
        let imageURLString = [NSString stringWithFormat:@"https://www.gravatar.com/avatar/%@?s=%@&d=404", [inUser.email md5HEX], @(avatarSize)];
        [NSImage loadFromURL:[NSURL URLWithString:imageURLString]
            placeholderImage:placeholderImage
             prefetchHandler:^(NSImage *cachedImage) {
                 if (completion) {
                     cachedImage.size = placeholderImage.size;
                     completion(cachedImage);
                 }
             }
             fetchCompletion:^(NSImage *fetchedImage, BOOL isCached) {
                 if (completion) {
                     fetchedImage.size = placeholderImage.size;
                     completion(fetchedImage);
                 }
             }];
    }
}

- (BOOL)userIsAuthenticated {
    return PFUser.currentUser.email != nil && PFUser.currentUser.isAuthenticated;
}

- (NSString *)userEmail {
    return PFUser.currentUser.email;
}

@end
