//
//  Created by Frank Gregor on 03/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSViewController+Podlive.h"

@implementation NSViewController (Podlive)

+ (instancetype)viewController {
    return [[[self class] alloc] initWithNibName:nil bundle:nil];
}

- (void)configureDefaults {}

@end
