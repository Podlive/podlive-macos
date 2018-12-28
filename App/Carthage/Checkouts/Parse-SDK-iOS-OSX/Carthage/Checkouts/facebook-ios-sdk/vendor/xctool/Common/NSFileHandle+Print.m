//
// Copyright 2004-present Facebook. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NSFileHandle+Print.h"

@implementation NSFileHandle (Print)
- (void)printString:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
  [self writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
  va_end(args);
}
@end
