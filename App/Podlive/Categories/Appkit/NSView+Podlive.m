//
//  Created by Frank Gregor on 05.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//

#import <objc/runtime.h>
#import "NSView+Podlive.h"

@implementation NSView (Podlive)

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        Class class = [self class];

        // init:
        SEL orignalInitSelector = @selector(init);
        SEL swizzledInitSelector = @selector(init_ccn);
        Method originalInitMethod = class_getInstanceMethod(class, orignalInitSelector);
        Method swizzledInitMethod = class_getInstanceMethod(class, swizzledInitSelector);

        BOOL didAddMethod = class_addMethod(class, orignalInitSelector,
                                            method_getImplementation(swizzledInitMethod),
                                            method_getTypeEncoding(swizzledInitMethod));

        if (didAddMethod) {
            class_replaceMethod(class, swizzledInitSelector,
                                method_getImplementation(originalInitMethod),
                                method_getTypeEncoding(originalInitMethod));
        } else {
            method_exchangeImplementations(originalInitMethod, swizzledInitMethod);
        }

        // initWithFrame:
        SEL orignalInitWithFrameSelector = @selector(initWithFrame:);
        SEL swizzledInitWithFrameSelector = @selector(init_ccn_WithFrame:);
        Method originalInitWithFrameMethod = class_getInstanceMethod(class, orignalInitWithFrameSelector);
        Method swizzledInitWithFrameMethod = class_getInstanceMethod(class, swizzledInitWithFrameSelector);

        didAddMethod = class_addMethod(class, orignalInitWithFrameSelector,
                                       method_getImplementation(swizzledInitWithFrameMethod),
                                       method_getTypeEncoding(swizzledInitWithFrameMethod));

        if (didAddMethod) {
            class_replaceMethod(class, swizzledInitWithFrameSelector,
                                method_getImplementation(originalInitWithFrameMethod),
                                method_getTypeEncoding(originalInitWithFrameMethod));
        } else {
            method_exchangeImplementations(originalInitWithFrameMethod, swizzledInitWithFrameMethod);
        }
    });
}

// MARK: - Method Swizzling

- (instancetype)init_ccn_WithFrame:(NSRect)frame {
    self = [self init_ccn_WithFrame:frame];
    if (!self) return nil;

    [self _configureComponent];

    return self;
}

- (instancetype)init_ccn {
    self = [self init_ccn];
    if (!self) return nil;

    [self _configureComponent];

    return self;
}

- (void)_configureComponent {
    self.wantsLayer = YES;
}

// MARK: - Managing Views

- (BOOL)hasSubView:(NSView *)theSubView {
    return [self.subviews containsObject:theSubView];
}

- (void)bringSubViewToFront:(NSView *)theSubView {
    if ([self hasSubView:theSubView]) {
        [theSubView removeFromSuperviewWithoutNeedingDisplay];
        [self addSubview:theSubView positioned:NSWindowAbove relativeTo:nil];
    }
}

- (void)addVibrancyBlendingMode:(NSVisualEffectBlendingMode)mode {
    Class vibrantClass = [NSVisualEffectView class];
    if (vibrantClass) {
        NSVisualEffectView *vibrant = [[vibrantClass alloc] initWithFrame:self.bounds];
        [vibrant setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
        // uncomment for dark mode instead of light mode
//        [vibrant setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
        [vibrant setBlendingMode:mode];
        [self addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];
    }
}

// MARK: - Managing Animations

- (void)startRotationWithDuration:(CFTimeInterval)duration clockwise:(BOOL)clockwise {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:(clockwise ? -M_PI * 2 : M_PI * 2)];
    CGRect frame = self.layer.frame;
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    self.layer.position = center;
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)stopRotation {
    [self.layer removeAllAnimations];
}

// MARK: - Custom Accessors

- (NSColor *)backgroundColor {
    return objc_getAssociatedObject(self, @selector(backgroundColor));
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    objc_setAssociatedObject(self, @selector(backgroundColor), backgroundColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.wantsLayer = YES;
    self.layer.backgroundColor = backgroundColor.CGColor;
    [self setNeedsDisplay:YES];
}

@end
