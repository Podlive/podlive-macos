//
//  Created by Frank Gregor on 30/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef NS_ENUM(NSInteger, CCNPreferencesId) {
    CCNPreferencesIdUndefined  = -1,
    CCNPreferencesIdGeneral = 0,
    CCNPreferencesIdAudio,
    CCNPreferencesIdSync,
};

@interface CCNPreferencesBase : NSViewController

@property (nonatomic, assign) CCNPreferencesId preferencesId;
@property (nonatomic, readonly) NSString *preferencesIdentifier;

@end
