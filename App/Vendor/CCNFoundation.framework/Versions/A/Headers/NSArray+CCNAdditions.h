//
//  Created by Frank Gregor on 26.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

#import <Foundation/Foundation.h>

// MARK: - NSArray Additions

@interface NSArray (CCNAdditions)

- (NSUInteger)indexOfFirstObjectWithIntegerValue:(NSInteger)theValue;
- (BOOL)containsObjectWithIntegerValue:(NSInteger)theValue;

@end


// MARK: - NSMutableArray Additions

@interface NSMutableArray (CCNAdditions)

- (void)moveObjectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (instancetype)popFirstObject;
- (void)removeFirstObject;

@end
