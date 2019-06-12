// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <XCTest/XCTest.h>

#import "FBSDKCoreKit+Internal.h"

@interface FBSDKUtilityTests : XCTestCase

@end

@implementation FBSDKUtilityTests

- (void)testSHA256Hash {
  NSString *hashed = [FBSDKUtility SHA256Hash:@"facebook"];

  XCTAssertEqualObjects(hashed, @"3d59f7548e1af2151b64135003ce63c0a484c26b9b8b166a7b1c1805ec34b00a");
}

- (void)testURLDecodeShouldNotModifyUnencodedUrlString {
  NSString *unencoded = @"https://www.facebook.com/index.html?a=b&c=d";

  XCTAssertEqualObjects(unencoded, [FBSDKUtility URLDecode:unencoded]);
}

- (void)testURLEncode {
  NSString *unencoded = @"https://www.facebook.com/index.html?a=b&c=d";
  NSString *encoded = @"https%3A%2F%2Fwww.facebook.com%2Findex.html%3Fa%3Db%26c%3Dd";

  XCTAssertEqualObjects(encoded, [FBSDKUtility URLEncode:unencoded]);
  XCTAssertEqualObjects(unencoded, [FBSDKUtility URLDecode:encoded]);
}

- (void)testURLEncodeWithJSON {
  NSString *url = @"https://m.facebook.com/v3.2/dialog/oauth?auth_type=rerequest&client_id=123456789&default_audience=friends&display=touch&e2e={\"init\":123456.1234567890}&fbapp_pres=0&redirect_uri=fb111111111111111://authorize/&response_type=token,signed_request&return_scopes=true&scope=&sdk=ios&sdk_version=4.39.0&state={\"challenge\":\"aBcDeFghiJKlmnOpQRS%tU\",\"0_auth_logger_id\":\"01234ABC-12AB-34DE-1234-ABCDEFG12345\",\"com.facebook.some_identifier\":true,\"3_method\":\"sfvc_auth\"}";
  NSString *encoded = @"https%3A%2F%2Fm.facebook.com%2Fv3.2%2Fdialog%2Foauth%3Fauth_type%3Drerequest%26client_id%3D123456789%26default_audience%3Dfriends%26display%3Dtouch%26e2e%3D%7B%22init%22%3A123456.1234567890%7D%26fbapp_pres%3D0%26redirect_uri%3Dfb111111111111111%3A%2F%2Fauthorize%2F%26response_type%3Dtoken%2Csigned_request%26return_scopes%3Dtrue%26scope%3D%26sdk%3Dios%26sdk_version%3D4.39.0%26state%3D%7B%22challenge%22%3A%22aBcDeFghiJKlmnOpQRS%25tU%22%2C%220_auth_logger_id%22%3A%2201234ABC-12AB-34DE-1234-ABCDEFG12345%22%2C%22com.facebook.some_identifier%22%3Atrue%2C%223_method%22%3A%22sfvc_auth%22%7D";

  XCTAssertEqualObjects(encoded, [FBSDKUtility URLEncode:url]);
  XCTAssertEqualObjects(url, [FBSDKUtility URLDecode:encoded]);
}

- (void)testNewEncodeWorksLikeLegacy {
  for (int i = 0; i < 256; i++) {
    NSString *str = [NSString stringWithFormat:@"%c", (char)i];
    if ([str isEqualToString:@"{"] || [str isEqualToString:@"}"]) {
      continue; // Curly braces were not included in legacy URL encode
    }
    XCTAssertEqualObjects([FBSDKUtility URLEncode:str], [self legacyURLEncode:str]);
  }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSString *)legacyURLEncode:(NSString *)value
{
  return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                               (CFStringRef)value,
                                                                               NULL, // characters to leave unescaped
                                                                               CFSTR(":!*();@/&?+$,='"),
                                                                               kCFStringEncodingUTF8);
}
#pragma clang diagnostic pop

@end
