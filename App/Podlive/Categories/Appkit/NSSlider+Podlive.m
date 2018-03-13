//
//  NSSlider+Podlive.m
//  Podlive
//
//  Created by Frank Gregor on 30/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "NSSlider+Podlive.h"

@implementation NSSlider (Podlive)

/* This method is part of the NSAnimatablePropertyContainer which is adopted by NSView (and hence all its
 * subclasses.  It is used to retrieve the default animation that should be performed to animate a given
 * property. If no default animation is provided, the property is not considered implicitly animatable.
 *
 * By default NSSlider does not provide an implicit animation for its "floatValue" property.  So, we will
 * provide one with this category thus making the "floatValue" animatable.
 */
+ (id)defaultAnimationForKey:(NSString *)key {
    if ([key isEqualToString:@"floatValue"]) {
        // By default, use simple linear interpolation.
        return [CABasicAnimation animation];
    }

    /* You may wish to add handlers here for the other many properties that can affect a slider's value
     * such as intValue, doubleValue, ... */
    else {
        // Defer to super's implementation for any keys we don't specifically handle.
        return [super defaultAnimationForKey:key];
    }
}

@end
