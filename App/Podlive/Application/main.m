//
//  Created by Frank Gregor on 21/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CCNApplicationDelegate.h"

int main(int argc, const char * argv[]) {
    CCNApplicationDelegate * NS_VALID_UNTIL_END_OF_SCOPE delegate = CCNApplicationDelegate.new;
    let application = NSApplication.sharedApplication;
    application.delegate = delegate;
    [application run];
    application.delegate = nil;

    return 0;
}
