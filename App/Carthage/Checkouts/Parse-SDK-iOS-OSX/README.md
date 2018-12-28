# Parse SDK for iOS/OS X/watchOS/tvOS

[![Maintenance help wanted](https://img.shields.io/badge/maintenance-help%20wanted-red.svg)](https://github.com/parse-community/Parse-SDK-iOS-OSX/issues/1356)
![Platforms][platforms-svg]
[![License][license-svg]][license-link]

[![Podspec][podspec-svg]][podspec-link]
[![Carthage compatible][carthage-svg]](carthage-link)
[![Dependencies][dependencies-svg]][dependencies-link]
[![References][references-svg]][references-link]

[![Build Status][build-status-svg]][build-status-link]
[![Build Status][circleci-status-svg]][circleci-status-link]
[![Coverage Status][coverage-status-svg]][coverage-status-link]

[![Join Chat][gitter-svg]][gitter-link]

A library that gives you access to the powerful Parse cloud platform from your iOS or OS X app.
For more information about Parse and its features, see the public [documentation][docs].

## Getting Started

To use parse, head on over to the [releases][releases] page, and download the latest build.
And you're off!. Take a look at the public [documentation][docs] & [API][api] and start building.

Notice the API docs aren't totally up to date when it comes to latest Swift signature of the methods and more importantly regarding [Push Notifications](http://blog.parse.com/learn/engineering/the-dangerous-world-of-client-push/) which are **no longer supported by Parse server**, keep an eye on [its repo](https://github.com/ParsePlatform/parse-server)

### Other Installation Options

#### [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod 'Parse'
```

Run `pod install`, and you should now have the latest parse release.

If you wish to use the Facebook or Twitter utils or ParseUI,
you can now leverage Cocoapods 'subspecs'

```ruby
pod 'Parse/FacebookUtils'
pod 'Parse/TwitterUtils'
pod 'Parse/UI'
```

Note that in this case, the Parse framework will contain all headers and classes, so you just have to use:

```swift
import Parse
```

```objc
@import Parse;
```

#### [Carthage](https://github.com/carthage/carthage)

Add the following line to your Cartfile:
```
github "parse-community/Parse-SDK-iOS-OSX"
```
Run `carthage update`, and you should now have the latest version of Parse SDK in your Carthage folder.

This will also compile the ParseTwitterUtils, ParseFacebookUtilsV4 as well as ParseUI frameworks.

#### Compiling for yourself

If you want to manually compile the SDK, clone it locally, and run the following commands in the root directory of the repository:

```
# To pull in extra dependencies (Bolts and OCMock)
git submodule update --init --recursive

# To install bundler
gem install bundler

# To install all the gems via bundler
bundle install

# Build & Package the Frameworks
bundle exec rake package:frameworks
```

Compiled frameworks will be in multiple archives inside the `build/release` folder: 
- `Parse-iOS.zip`
- `Parse-macOS.zip`
- `Parse-tvOS.zip`
- `Parse-watchOS.zip`
- `ParseFacebookUtils-iOS.zip`
- `ParseFacebookUtils-tvOS.zip`
- `ParseTwitterUtils-iOS.zip`
- `ParseUI.zip`


#### Using Parse as a sub-project

You can also include parse as a subproject inside of your application if you'd prefer, although we do not recommend this, as it will increase your indexing time significantly. To do so, just drag and drop the Parse.xcodeproj file into your workspace. Note that unit tests will be unavailable if you use Parse like this, as OCMock will be unable to be found.

## How Do I Contribute?

We want to make contributing to this project as easy and transparent as possible. Please refer to the [Contribution Guidelines][contributing].

## Preparing for a new release

### Update the version number

You can use the rake task in order to bump the version number, it's safe, and will properly update all version numbers

```
$ bundle exec rake package:set_version[X.X.X]
```

Replace X.X.X by the version number and push to the repository.

## Dependencies

We use the following libraries as dependencies inside of Parse:

 - [Bolts][bolts-framework], for task management.
 - [OCMock][ocmock-framework], for unit testing.

## Other Parse Projects

 - [ParseUI for iOS][parseui-link]

## License

```
Copyright (c) 2015-present, Parse, LLC.
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. An additional grant
of patent rights can be found in the PATENTS file in the same directory.
```

As of April 5, 2017, Parse, LLC has transferred this code to the parse-community organization, and will no longer be contributing to or distributing this code.

 [docs]: http://docs.parseplatform.org/ios/guide/
 [api]: http://parseplatform.org/Parse-SDK-iOS-OSX/api/

 [parseui-link]: https://github.com/parse-community/ParseUI-iOS

 [releases]: https://github.com/parse-community/Parse-SDK-iOS-OSX/releases
 [contributing]: https://github.com/parse-community/Parse-SDK-iOS-OSX/blob/master/CONTRIBUTING.md

 [bolts-framework]: https://github.com/BoltsFramework/Bolts-ObjC
 [ocmock-framework]: http://ocmock.org

 [build-status-svg]: https://img.shields.io/travis/parse-community/Parse-SDK-iOS-OSX/master.svg
 [build-status-link]: https://travis-ci.org/parse-community/Parse-SDK-iOS-OSX/branches

 [circleci-status-svg]: https://circleci.com/gh/parse-community/Parse-SDK-iOS-OSX.svg?style=shield
 [circleci-status-link]: https://circleci.com/build-insights/gh/parse-community/Parse-SDK-iOS-OSX/master

 [coverage-status-svg]: https://img.shields.io/codecov/c/github/parse-community/Parse-SDK-iOS-OSX/master.svg
 [coverage-status-link]: https://codecov.io/github/parse-community/Parse-SDK-iOS-OSX?branch=master

 [license-svg]: https://img.shields.io/badge/license-BSD-lightgrey.svg
 [license-link]: https://github.com/parse-community/Parse-SDK-iOS-OSX/blob/master/LICENSE

 [podspec-svg]: https://img.shields.io/cocoapods/v/Parse.svg
 [podspec-link]: https://cocoapods.org/pods/Parse

 [carthage-svg]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
 [carthage-link]: https://github.com/carthage/carthage

 [platforms-svg]: http://img.shields.io/cocoapods/p/Parse.svg?style=flat

 [dependencies-svg]: https://img.shields.io/badge/dependencies-2-yellowgreen.svg
 [dependencies-link]: https://github.com/parse-community/Parse-SDK-iOS-OSX/blob/master/Vendor

 [references-svg]: https://www.versioneye.com/objective-c/parse/reference_badge.svg
 [references-link]: https://www.versioneye.com/objective-c/parse/references

 [gitter-svg]: https://img.shields.io/badge/gitter-join%20chat%20%E2%86%92-brightgreen.svg
 [gitter-link]: https://gitter.im/ParsePlatform/Chat
