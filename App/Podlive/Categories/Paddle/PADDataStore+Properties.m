//
//  Created by Frank Gregor on 31/05/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Paddle/Paddle.h>
#import "PADDataStore+Properties.h"

@implementation PADDataStore (Properties)

- (NSString *)productName {
    return (NSString *)[PADDataStore.sharedInstance objectForKey:kPADProductName];
}

- (NSString *)vendorName {
    return (NSString *)[PADDataStore.sharedInstance objectForKey:kPADDevName];
}

- (NSString *)currency {
    return (NSString *)[PADDataStore.sharedInstance objectForKey:kPADCurrency];
}

- (NSDecimalNumber *)usualPrice {
    return [NSDecimalNumber decimalNumberWithString:[PADDataStore.sharedInstance objectForKey:kPADUsualPrice]];
}

- (NSDecimalNumber *)currentPrice {
    return [NSDecimalNumber decimalNumberWithString:[PADDataStore.sharedInstance objectForKey:kPADCurrentPrice]];
}

- (NSUInteger)trialLength {
    return [[PADDataStore.sharedInstance objectForKey:kPADTrialDuration] integerValue];
}

- (NSUInteger)daysRemaining {
    return [Paddle.sharedInstance daysRemainingOnTrial].integerValue;
}

@end
