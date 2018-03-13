//
//  Created by Frank Gregor on 25.11.15.
//  Copyright © 2015 cocoa:naut. All rights reserved.
//

//#import "Reachability.h"

@protocol CCNReachability <NSObject>
@optional
- (void)reachabilityChanged:(Reachability *)reachability;
@end
