# Podlive for macOS
## Preamble
Podlive is a client for iOS, macOS and tvOS to listen to live streaming podcasts. We currently support all livestreams broadcasting via [Ultraschall](http://ultraschall.fm) with [Studio Link On Air](https://studio-link.de).

Our backend is a [Parse-Server](http://parseplatform.org) which is used to collect and control podcast meta data, manage push notifications and all marked favorites for each registered user.

## How to contribute?
The goal to develop this software was a lag of a personal need, at the beginning. It was just a fun and hobby project, and it still is being developed under the same premise.

We really would like to see passionate developers with tons of ideas to improve and push forward this Mac client. And there is just one requirement: *I would like to see it Objective-C only*.

Please don’t get me wrong, I’m a Swift developer too. But my private passion still is on ObjC. So, Podlive for Mac may be born with the idea in mind to let ObjC a living language, who knows it (naive minded, isn’t it?)...  
And for all you Swift fans, the code style of this project looks very familiar. 😉

To contribute, just clone this project and start to develop. To avoid spamming us with tons of issues, this repository only allows pull-requests. So, if you are going to help us, please fork this project, make you changes/additions and open a pull request. Thanks for understanding.

In order to test your changes you have to use our test-backend. This requires access keys, which aren’t included in this repository.

**NOTE: To use these keys please send a request to our [email address](mailto:mail@podlive.io?Subject=Parse-Server-Key-Request)**.

## Developer Notes
Podlive uses GitFlow. There are two branches, `master` and `develop`. Here on GitHub the `develop` branch is our default branch. To make your additions you just have to create your working branch with `develop` as parent. If you’re done, open a pull request.

For more detailed code guidelines please have look at the [Developer Notes](Developer-Notes.md) document.

## Documentations

* [Parse macOS Guide](http://parseplatform.github.io/docs/macos/guide/)
* [Parse macOS SDK, latest](https://github.com/ParsePlatform/Parse-SDK-iOS-OSX/releases/tag/1.14.3)
* [Parse API Reference](https://parseplatform.github.io/Parse-SDK-iOS-OSX/api/)
* [Introducing Parse Push for macOS](http://blog.parse.com/announcements/introducing-parse-push-for-os-x/)
* [List of Radio-Stream URLs](http://www.chip.de/artikel/Webradio-Live-Stream-Alle-Sender-im-ueberblick_56137550.html)
* [APNS Payload Key Reference](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1)