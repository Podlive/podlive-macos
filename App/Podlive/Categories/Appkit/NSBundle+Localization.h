//
//  Created by Frank Gregor on 07.03.19.
//  Copyright © 2019 cocoa:naut. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Localization)

+ (NSString *)localizedMenuStringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
