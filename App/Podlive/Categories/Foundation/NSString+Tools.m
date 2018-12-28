//
//  Created by Frank Gregor on 25.12.14.
//  Copyright (c) 2014 cocoa:naut. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+Tools.h"


NSString* HEXStringOfCArray(unsigned char *cArray, CC_LONG length) {
    NSString *hexString = [[NSString alloc] init];
    for (int i = 0; i < length; i++) {
        hexString = [hexString stringByAppendingFormat:@"%02x", cArray[i]];
    }
    return hexString;
}

// MARK: - CCNAdditions

@implementation NSString (Tools)

- (BOOL)containsString:(NSString *)aString {
    return [self containsString:aString ignoringCase:NO];
}

- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag {
    unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
    NSRange range = [self rangeOfString:aString options:mask];
    return (range.length > 0);
}

- (BOOL)isValidURL {
    return ([NSURL URLWithString:self] != nil);
}

- (BOOL)isValidEmailAddress {
    if (self.length == 0) {
        return NO;
    }

    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isEmptyString {
    return [self isEqualToString:@""];
}

- (BOOL)isNotEmptyString {
    return ![self isEmptyString];
}

- (NSString *)removeTabsAndReturns {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"\n\r\t"];

    NSMutableString *outputString = [NSMutableString string];
    NSString *temp;
    while ([scanner scanUpToCharactersFromSet:charSet intoString:&temp]) {
        [outputString appendString:temp];
    }

    return [outputString copy];
}

- (NSString *)newlineToCR {
    NSMutableString *str = [NSMutableString stringWithString:self];
    [str replaceOccurrencesOfString:@"\n" withString:@"\r"
                            options:NSLiteralSearch
                              range:NSMakeRange(0, [str length])];
    return [str copy];
}

- (NSArray *)componentsSeparatedByString:(NSString *)separatorString ignoringEmptyComponents:(BOOL)ignoringEmptyComponents {
    NSArray *components = [self componentsSeparatedByString:separatorString];

    if (ignoringEmptyComponents == YES) {
        NSMutableArray *nonEmptyComponents = [NSMutableArray array];
        for (NSString *content in components) {
            if (content && ![[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                [nonEmptyComponents addObject:content];
            }
        }
        components = [NSArray arrayWithArray:nonEmptyComponents];
    }
    
    return components;
}

- (NSString *)stringByTrimmingCharacters {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithRange:NSMakeRange(0, [self length])]];
}


- (NSString *)md5HEX {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return HEXStringOfCArray(result, CC_MD5_DIGEST_LENGTH);
}

- (NSString*)hmacMD5WithSecret:(NSString*)aSecret {
    const char *cAuthPassword = [aSecret cStringUsingEncoding:NSASCIIStringEncoding];
    CC_LONG cAuthPasswordLength = (CC_LONG)strlen(cAuthPassword);

    const char *cDataString = [self cStringUsingEncoding:NSASCIIStringEncoding];
    CC_LONG cDataStringLength = (CC_LONG)strlen(cDataString);

    unsigned char digest[CC_MD5_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgMD5,               /* kCCHmacAlgSHA1, kCCHmacAlgMD5 */
           cAuthPassword,
           cAuthPasswordLength,         /* length of key in bytes */
           cDataString,
           cDataStringLength,           /* length of data in bytes */
           digest);

    return HEXStringOfCArray(digest, CC_MD5_DIGEST_LENGTH);
}

- (NSString*)SHA1String {
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], (CC_LONG)[stringBytes length], digest)) {
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%02x", digest[i]];
        }
        return output;
    }
    return nil;
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger timeInterval = (NSInteger)interval;
    NSInteger seconds      = timeInterval % 60;
    NSInteger minutes      = (timeInterval / 60) % 60;
    NSInteger hours        = (timeInterval / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

@end

