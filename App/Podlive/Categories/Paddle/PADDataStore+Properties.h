//
//  Created by Frank Gregor on 31/05/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <Paddle/PADDataStore.h>

@interface PADDataStore (Properties)

@property (nonatomic, readonly) NSString *productName;
@property (nonatomic, readonly) NSString *vendorName;
@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSDecimalNumber *usualPrice;
@property (nonatomic, readonly) NSDecimalNumber *currentPrice;
@property (nonatomic, readonly) NSUInteger trialLength;
@property (nonatomic, readonly) NSUInteger daysRemaining;

@end
