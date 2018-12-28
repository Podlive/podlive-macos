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

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKShareKit/FBSDKGameRequestContent.h>

#import <XCTest/XCTest.h>

#import "FBSDKShareUtility.h"

@interface FBSDKGameRequestContentTests : XCTestCase
@end

@implementation FBSDKGameRequestContentTests

- (void)testProperties
{
  FBSDKGameRequestContent *content = [[self class] _contentWithAllProperties];
  XCTAssertEqualObjects(content.recipients, [[self class] _recipients]);
  XCTAssertEqualObjects(content.message, [[self class] _message]);
  XCTAssertEqual(content.actionType, [[self class] _actionType]);
  XCTAssertEqualObjects(content.objectID, [[self class] _objectID]);
  XCTAssertEqual(content.filters, [[self class] _filters]);
  XCTAssertEqualObjects(content.recipientSuggestions, [[self class] _recipientSuggestions]);
  XCTAssertEqualObjects(content.data, [[self class] _data]);
  XCTAssertEqualObjects(content.title, [[self class] _title]);
}

- (void)testCopy
{
  FBSDKGameRequestContent *content = [[self class] _contentWithAllProperties];
  XCTAssertEqualObjects([content copy], content);
}

- (void)testCoding
{
  FBSDKGameRequestContent *content = [[self class] _contentWithAllProperties];
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:content];
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  [unarchiver setRequiresSecureCoding:YES];
  FBSDKGameRequestContent *unarchivedObject = [unarchiver decodeObjectOfClass:[FBSDKGameRequestContent class]
                                                                      forKey:NSKeyedArchiveRootObjectKey];
  XCTAssertEqualObjects(unarchivedObject, content);
}

- (void)testValidationWithMinimalProperties
{
  return [self _testValidationWithContent:[[self class] _contentWithMinimalProperties]];
}

- (void)testValidationWithManyProperties
{
  return [self _testValidationWithContent:[[self class] _contentWithManyProperties]];
}

- (void)testValidationWithNoProperties
{
  FBSDKGameRequestContent *content = [[FBSDKGameRequestContent alloc] init];
  [self _testValidationWithContent:content errorArgumentName:@"message"];
}

- (void)testValidationWithTo
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.recipients = [[self class] _recipients];
  [self _testValidationWithContent:content];
}

- (void)testValidationWithActionTypeSend
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.actionType = FBSDKGameRequestActionTypeSend;
  [self _testValidationWithContent:content errorArgumentName:@"objectID"];
}

- (void)testValidationWithActionTypeSendAndobjectID
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.actionType = FBSDKGameRequestActionTypeSend;
  content.objectID = [[self class] _objectID];
  [self _testValidationWithContent:content];
}

- (void)testValidationWithActionTypeAskFor
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.actionType = FBSDKGameRequestActionTypeAskFor;
  [self _testValidationWithContent:content errorArgumentName:@"objectID"];
}

- (void)testValidationWithActionTypeAskForAndobjectID
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.actionType = FBSDKGameRequestActionTypeAskFor;
  content.objectID = [[self class] _objectID];
  [self _testValidationWithContent:content];
}

- (void)testValidationWithActionTypeTurn
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.actionType = FBSDKGameRequestActionTypeTurn;
  [self _testValidationWithContent:content];
}

- (void)testValidationWithActionTypeTurnAndobjectID
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.actionType = FBSDKGameRequestActionTypeTurn;
  content.objectID = [[self class] _objectID];
  [self _testValidationWithContent:content errorArgumentName:@"objectID"];
}

- (void)testValidationWithFilterAppUsers
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.filters = FBSDKGameRequestFilterAppUsers;
  [self _testValidationWithContent:content];
}

- (void)testValidationWithFilterAppNonUsers
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.filters = FBSDKGameRequestFilterAppNonUsers;
  [self _testValidationWithContent:content];
}

- (void)testValidationWithToAndFilters
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.recipients = [[self class] _recipients];
  content.filters = [[self class] _filters];
  [self _testValidationWithContent:content errorArgumentName:@"recipients"];
}

- (void)testValidationWithToAndSuggestions
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.recipients = [[self class] _recipients];
  content.recipientSuggestions = [[self class] _recipientSuggestions];
  [self _testValidationWithContent:content errorArgumentName:@"recipients"];
}

- (void)testValidationWithFiltersAndSuggestions
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.filters = [[self class] _filters];
  content.recipientSuggestions = [[self class] _recipientSuggestions];
  [self _testValidationWithContent:content errorArgumentName:@"recipientSuggestions"];
}

- (void)testValidationWithToAndFiltersAndSuggestions
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.recipients = [[self class] _recipients];
  content.filters = [[self class] _filters];
  content.recipientSuggestions = [[self class] _recipientSuggestions];
  [self _testValidationWithContent:content errorArgumentName:@"recipients"];
}

- (void)testValidationWithLongData
{
  FBSDKGameRequestContent *content = [[self class] _contentWithMinimalProperties];
  content.data = [NSString stringWithFormat:@"%.254f", 1.f]; // 256 characters
  [self _testValidationWithContent:content errorArgumentName:@"data"];
}

#pragma mark - Helper Methods

- (void)_testValidationWithContent:(FBSDKGameRequestContent *)content
{
  NSError *error;
  XCTAssertNotNil(content);
  XCTAssertNil(error);
  XCTAssertTrue([content validateWithOptions:FBSDKShareBridgeOptionsDefault error:&error]);
  XCTAssertNil(error);
}

- (void)_testValidationWithContent:(FBSDKGameRequestContent *)content errorArgumentName:(NSString *)argumentName
{
  NSError *error;
  XCTAssertNil(error);
  XCTAssertFalse([content validateWithOptions:FBSDKShareBridgeOptionsDefault error:&error]);
  XCTAssertNotNil(error);
  XCTAssertEqual(error.code, FBSDKErrorInvalidArgument);
  XCTAssertEqualObjects(error.userInfo[FBSDKErrorArgumentNameKey], argumentName);
}

+ (FBSDKGameRequestContent *)_contentWithMinimalProperties
{
  FBSDKGameRequestContent *content = [[FBSDKGameRequestContent alloc] init];
  content.message = [self _message];
  return content;
}

+ (FBSDKGameRequestContent *)_contentWithAllProperties
{
  FBSDKGameRequestContent *content = [[FBSDKGameRequestContent alloc] init];
  content.actionType = [self _actionType];
  content.data = [self _data];
  content.filters = [self _filters];
  content.message = [self _message];
  content.objectID = [self _objectID];
  content.recipientSuggestions = [self _recipientSuggestions];
  content.title = [self _title];
  content.recipients = [self _recipients];
  return content;
}

+ (FBSDKGameRequestContent *)_contentWithManyProperties
{
  FBSDKGameRequestContent *content = [[FBSDKGameRequestContent alloc] init];
  content.data = [self _data];
  content.message = [self _message];
  content.title = [self _title];
  return content;
}

+ (NSArray *)_recipients
{
  return @[@"recipient-id-1", @"recipient-id-2"];
}

+ (NSString *)_message
{
  return @"Here is an awesome item for you!";
}

+ (FBSDKGameRequestActionType)_actionType
{
  return FBSDKGameRequestActionTypeSend;
}

+ (NSString *)_objectID
{
  return @"id-of-an-awesome-item";
}

+ (FBSDKGameRequestFilter)_filters
{
  return FBSDKGameRequestFilterAppUsers;
}

+ (NSArray *)_recipientSuggestions
{
  return @[@"suggested-recipient-id-1", @"suggested-recipient-id-2"];
}

+ (NSString *)_data
{
  return @"some-data-highly-important";
}

+ (NSString *)_title
{
  return @"Send this awesome item to your friends!";
}

@end
