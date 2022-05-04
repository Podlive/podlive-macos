//
//  Created by Frank Gregor on 25.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

#ifndef CCNFoundation_ConsoleLogging_h
#define CCNFoundation_ConsoleLogging_h

#import <Availability.h>

// paste this: CONFIGURATION_$(CONFIGURATION)
// over      : "Apple LLVM - Preprocessing" section on project "Build Settings"
#if defined (CONFIGURATION_Debug)
    #define CCNLog(aParam, ...)         NSLog(@"%s(%d): " aParam, ((strrchr(__FILE__, '/') ? : __FILE__- 1) + 1), __LINE__, ##__VA_ARGS__)
    #define CCNLogInfo(aParam, ...)     CCNLog(@"[INFO] %@", [NSString stringWithFormat:aParam, ##__VA_ARGS__])
    #define CCNLogError(aParam, ...)    CCNLog(@"[ERROR] %@", [NSString stringWithFormat:aParam, ##__VA_ARGS__])
    #define CCNLogRect(aRect)           CCNLog(@"[%s] x: %f, y: %f, width: %f, height: %f", #aRect, aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height)
    #define CCNLogSize(aSize)           CCNLog(@"[%s] width: %f, height: %f", #aSize, aSize.width, aSize.height)
    #define CCNLogRange(aRange)         CCNLog(@"[%s] location: %lu; length: %lu", #aRange, aRange.location, aRange.length)
    #define CCNLogPoint(aPoint)         CCNLog(@"[%s] x: %fu; y: %fu", #aPoint, aPoint.x, aPoint.y)
    #define CCNBoolToString(boolValue)  CCNLog(@"[%s] %@", #boolValue, (boolValue ? @"YES" : @"NO"))
#else
    #define CCNLog(xx, ...)             ((void)0)
    #define CCNLogInfo(aParam, ...)     ((void)0)
    #define CCNLogError(aParam, ...)    ((void)0)
    #define CCNLogRect(aRect)           ((void)0)
    #define CCNLogSize(aSize)           ((void)0)
    #define CCNLogRange(aRange)         ((void)0)
    #define CCNLogPoint(aPoint)         ((void)0)
    #define CCNBoolToString(boolValue)  ((void)0)
#endif

#endif



// This #define simplifies the definition of external string constants.
#define NSSTRING_CONSTANT(var) NSString *const var = @#var

// This #define simplfies the definition of static observation contexts.
#define NSSTRING_CONTEXT(var) static NSString *var = @#var



// ObjC Typ Inference
#define var __auto_type
#define let const __auto_type
