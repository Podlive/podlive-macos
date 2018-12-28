//
//  Created by Frank Gregor on 12/02/15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//

#import "NSTextField+Tools.h"

@implementation NSTextField (Tools)

- (void)setStringValue:(NSString *_Nonnull)stringValue animated:(BOOL)animated {
    if (!animated) {
        self.stringValue = stringValue;
        return;
    }

    __block NSTextField *overlayTextField  = [NSTextField new];
    [self.superview addSubview:overlayTextField];
    overlayTextField.frame                 = self.frame;
    overlayTextField.autoresizingMask      = self.autoresizingMask;
    overlayTextField.alignment             = self.alignment;
    overlayTextField.font                  = self.font;
    overlayTextField.textColor             = self.textColor;
    overlayTextField.editable              = self.editable;
    overlayTextField.selectable            = self.selectable;
    overlayTextField.backgroundColor       = self.backgroundColor;
    overlayTextField.drawsBackground       = self.drawsBackground;
    overlayTextField.bordered              = self.bordered;
    overlayTextField.bezeled               = self.bezeled;
    overlayTextField.enabled               = self.enabled;
    overlayTextField.attributedStringValue = self.attributedStringValue;
    overlayTextField.wantsLayer            = YES;

    self.alphaValue = 0.0;
    self.stringValue = stringValue;

    __weak typeof(self) wSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            wSelf.animator.alphaValue = 1.0;
            overlayTextField.animator.alphaValue = 0;

        } completionHandler:^{
            [overlayTextField removeFromSuperview];
            overlayTextField = nil;
        }];
    }];
}

- (void)setAttributedStringValue:(NSAttributedString *_Nonnull)attributedStringValue animated:(BOOL)animated {
    if (!animated) {
        self.attributedStringValue = attributedStringValue;
        return;
    }

    __block NSTextField *overlayTextField  = [NSTextField new];
    overlayTextField.frame                 = self.frame;
    overlayTextField.autoresizingMask      = self.autoresizingMask;
    overlayTextField.alignment             = self.alignment;
    overlayTextField.font                  = self.font;
    overlayTextField.textColor             = self.textColor;
    overlayTextField.editable              = self.editable;
    overlayTextField.selectable            = self.selectable;
    overlayTextField.backgroundColor       = self.backgroundColor;
    overlayTextField.drawsBackground       = self.drawsBackground;
    overlayTextField.bordered              = self.bordered;
    overlayTextField.bezeled               = self.bezeled;
    overlayTextField.enabled               = self.enabled;
    overlayTextField.attributedStringValue = self.attributedStringValue;
    overlayTextField.wantsLayer            = YES;
    [self.superview addSubview:overlayTextField];

    self.attributedStringValue = attributedStringValue;
    self.alphaValue = 0.0;


    __weak typeof(self) wSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            wSelf.animator.alphaValue = 1.0;
            overlayTextField.animator.alphaValue = 0;

        } completionHandler:^{
            [overlayTextField removeFromSuperview];
            overlayTextField = nil;
        }];
    }];
}

- (BOOL)containsValidURL {
    if (!self.stringValue || self.stringValue.length == 0) {
        return YES;
    }

    NSString *regex = @"^((((https?|ftps?|gopher|telnet|nntp)://)|(mailto:|news:))(%[0-9A-Fa-f]{2}|[-()_.!~*';/?:@&=+$,A-Za-z0-9])+)([).!';/?:,][[:blank:]])?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [predicate evaluateWithObject:self.stringValue];
}

@end
