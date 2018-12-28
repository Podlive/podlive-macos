//
//  Created by Frank Gregor on 25.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

// MARK: - Tools

@interface NSString (Tools)

- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag;
- (BOOL)isValidURL;
- (BOOL)isValidEmailAddress;
- (BOOL)isEmptyString;
- (BOOL)isNotEmptyString;
- (NSString *)removeTabsAndReturns;
- (NSString *)newlineToCR;
- (NSArray *)componentsSeparatedByString:(NSString *)separatorString ignoringEmptyComponents:(BOOL)ignoringEmptyComponents;
- (NSString *)stringByTrimmingCharacters;

- (NSString *)md5HEX;
- (NSString *)hmacMD5WithSecret:(NSString*)aSecret;
- (NSString *)SHA1String;

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;

@end
