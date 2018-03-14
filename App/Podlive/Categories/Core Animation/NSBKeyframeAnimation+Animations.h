//
//  Created by Nacho Soto on 8/12/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//
//  Found: https://github.com/adam-siton/AUIAutoLayoutAnimator


#import "NSBKeyframeAnimation.h"
#import "NSBKeyframeAnimationFunctions.h"

typedef NS_ENUM(NSUInteger, NSBAnimationType) {
    AnimationTypeEaseInQuad = 0,
    AnimationTypeEaseOutQuad,
    AnimationTypeEaseInOutQuad,
    AnimationTypeEaseInCubic,
    AnimationTypeEaseOutCubic,
    AnimationTypeEaseInOutCubic,
    AnimationTypeEaseInQuart,
    AnimationTypeEaseOutQuart,
    AnimationTypeEaseInOutQuart,
    AnimationTypeEaseInQuint,
    AnimationTypeEaseOutQuint,
    AnimationTypeEaseInOutQuint,
    AnimationTypeEaseInSine,
    AnimationTypeEaseOutSine,
    AnimationTypeEaseInOutSine,
    AnimationTypeEaseInExpo,
    AnimationTypeEaseOutExpo,
    AnimationTypeEaseInOutExpo,
    AnimationTypeEaseInCirc,
    AnimationTypeEaseOutCirc,
    AnimationTypeEaseInOutCirc,
    AnimationTypeEaseInElastic,
    AnimationTypeEaseOutElastic,
    AnimationTypeEaseInOutElastic,
    AnimationTypeEaseInBack,
    AnimationTypeEaseOutBack,
    AnimationTypeEaseInOutBack,
    AnimationTypeEaseInBounce,
    AnimationTypeEaseOutBounce,
    AnimationTypeEaseInOutBounce,
    AnimationTypeAll,
    AnimationTypeCount
};

@interface NSBKeyframeAnimation (Animations)

+ (NSArray *)calculatePositionValuesForFunction:(NSBAnimationType)animationType startValue:(CGFloat)startValue endValue:(CGFloat)endValue withDuration:(CGFloat)duration;
+ (NSUInteger)numberOfStepsForDuration:(CGFloat)duration;

+ (NSString *)animatonNameForType:(NSBAnimationType)animationType;
+ (NSBKeyframeAnimationFunction)animationFunctionForType:(NSBAnimationType)animationType;

@end
