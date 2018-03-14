//
//  Created by Frank Gregor on 25.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (CCNAdditions)

- (NSString *)string;
- (NSInteger)valueForLastIndex;
- (NSInteger)valueForIndexAtPosition:(NSInteger)position;
- (NSIndexPath *)indexPathWithValue:(NSInteger)value forIndexAtPosition:(NSInteger)position;
- (NSIndexPath *)indexPathWithLength:(NSInteger)length;
- (NSIndexPath *)indexPathByIncrementingLastIndex;

@end
