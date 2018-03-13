//
//  Created by Frank Gregor on 12.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//


typedef void (^CCNTimerHandler)(NSTimer *timer);

@interface NSTimer (Blocks)

+ (NSTimer *)scheduledTimerWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(CCNTimerHandler)handler;                                    // the timer will fire immediately!
+ (NSTimer *)scheduledTimerWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats immediately:(BOOL)immediately handler:(CCNTimerHandler)handler;

@end
