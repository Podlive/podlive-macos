//
//  Created by Frank Gregor on 07.03.19.
//  Copyright © 2019 cocoa:naut. All rights reserved.
//

#import "NSBundle+Localization.h"

@implementation NSBundle (Localization)

+ (NSString *)localizedMenuStringForKey:(NSString *)key {
    return [[NSBundle mainBundle] localizedStringForKey:key value:nil table:@"MenuCommands"];
}

@end
