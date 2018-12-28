//
//  Created by Frank Gregor on 12/02/15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//

@interface NSTextField (Tools)

- (void)setStringValue:(NSString *_Nonnull)stringValue animated:(BOOL)animated;
- (void)setAttributedStringValue:(NSAttributedString *_Nonnull)attributedStringValue animated:(BOOL)animated;
- (BOOL)containsValidURL;

@end
