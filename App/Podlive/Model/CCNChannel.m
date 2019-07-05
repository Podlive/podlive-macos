//
//  Created by Frank Gregor on 21/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNChannel.h"
#import "CCNChannel+Convenience.h"
#import "NSString+Tools.h"

NSString *const CCNChannelFieldCoverart             = @"coverart";
NSString *const CCNChannelFieldCoverartThumbnail200 = @"coverartThumbnail200";
NSString *const CCNChannelFieldCoverartThumbnail800 = @"coverartThumbnail800";
NSString *const CCNChannelFieldCreator              = @"creator";
NSString *const CCNChannelFieldName                 = @"name";
NSString *const CCNChannelFieldEmail                = @"email";
NSString *const CCNChannelFieldDescription          = @"description";
NSString *const CCNChannelFieldStreamUrl            = @"streamUrl";
NSString *const CCNChannelFieldState                = @"state";
NSString *const CCNChannelFieldStreamingBackend     = @"streamingBackend";
NSString *const CCNChannelFieldWebsiteUrl           = @"websiteUrl";
NSString *const CCNChannelFieldChatUrl              = @"chatUrl";
NSString *const CCNChannelFieldListenerCount        = @"listenerCount";
NSString *const CCNChannelFieldFollowerCount        = @"followerCount";
NSString *const CCNChannelFieldTwitterUsername      = @"twitterUsername";
NSString *const CCNChannelFieldIsEnabled            = @"isEnabled";


@interface PFFileObject (URL)
@property (nonatomic, readonly) NSURL *tlsURL;
@end


// MARK: - PFFileObject+URL

@implementation PFFileObject (URL)
- (NSURL *)tlsURL {
    return [NSURL URLWithString:[self.url stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"]];
}
@end



// MARK: - CCNChannel

@interface CCNChannel ()
@property (nonatomic) PFObject *parseObject;
@property (nonatomic, readonly) NSImage *placeholderImage;
@end

@implementation CCNChannel

// MARK: - Channel Initialization

+ (nullable instancetype)channelWithObject:(__kindof PFObject*_Nullable)inParseObject {
    return [[[self class] alloc] initWithObject:inParseObject];
}

- (instancetype)initWithObject:(__kindof PFObject*_Nullable)inParseObject {
    self = [super init];
    if (!self) return nil;

    self.parseObject = inParseObject;
    
    return self;
}

- (instancetype)init {
    return [self initWithObject:nil];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[CCNChannel class]]) {
        let otherChannel = (CCNChannel *)object;
        if ([otherChannel.channelId isEqual:self.channelId]) {
            return YES;
        }
    }
    else if ([object isKindOfClass:[NSString class]]) {
        let otherChannelId = (NSString *)object;
        if ([otherChannelId isEqual:self.channelId]) {
            return YES;
        }
    }
    return NO;
}

// MARK: - Channel Properties

- (NSString *)channelId {
    return self.parseObject.objectId;
}

- (NSURL *)coverartURL {
    PFFileObject *const theFile = self.parseObject[CCNChannelFieldCoverart];
    if (theFile) {
        return theFile.tlsURL;
    }
    return nil;
}

- (NSURL *)coverartThumbnail200URL {
    PFFileObject *const theFile = self.parseObject[CCNChannelFieldCoverartThumbnail200];
    if (theFile) {
        return theFile.tlsURL;
    }
    return nil;
}

- (NSURL *)coverartThumbnail800URL {
    PFFileObject *const theFile = self.parseObject[CCNChannelFieldCoverartThumbnail800];
    if (theFile) {
        return theFile.tlsURL;
    }
    return nil;
}

- (NSString *)creator {
    return self.parseObject[CCNChannelFieldCreator];
}

- (NSString *)name {
    return self.parseObject[CCNChannelFieldName];
}

- (NSString *)email {
    return self.parseObject[CCNChannelFieldEmail];
}

- (NSString *)channelDescription {
    return self.parseObject[CCNChannelFieldDescription];
}

- (NSURL *)streamURL {
    let streamURL = [NSURL URLWithString:self.parseObject[CCNChannelFieldStreamUrl]];
    return streamURL;
}

- (CCNChannelState)state {
    return [CCNChannel channelStateForStateString:self.parseObject[CCNChannelFieldState]];
}

- (CCNStreamingBackend)streamingBackend {
    return [CCNChannel streamingBackendForBackendString:self.parseObject[CCNChannelFieldStreamingBackend]];
}

- (NSURL *)websiteURL {
    if (self.parseObject[CCNChannelFieldWebsiteUrl] != NSNull.null) {
        NSString *_string = [self.parseObject[CCNChannelFieldWebsiteUrl] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (_string && [_string isNotEmptyString]) {
            let websiteURL = [NSURL URLWithString:_string];
            return websiteURL;
        }
    }
    return nil;
}

- (NSURL *)chatURL {
    if (self.parseObject[CCNChannelFieldChatUrl] != NSNull.null) {
        NSString *_string = [self.parseObject[CCNChannelFieldChatUrl] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (_string && [_string isNotEmptyString]) {
            let chatURL = [NSURL URLWithString:_string];
            return chatURL;
        }
    }
    return nil;
}

- (NSString *)twitterUsername {
    return self.parseObject[CCNChannelFieldTwitterUsername];
}

- (NSInteger)listenerCount {
    return [self.parseObject[CCNChannelFieldListenerCount] integerValue];
}

- (NSInteger)followerCount {
    return [self.parseObject[CCNChannelFieldFollowerCount] integerValue];
}

- (BOOL)isEnabled {
    return [self.parseObject[CCNChannelFieldIsEnabled] boolValue];
}


// MARK: - Computed Properties

- (NSURL *)twitterURL {
    if (self.twitterUsername && self.twitterUsername != (id)NSNull.null) {
        if (self.twitterUsername.isNotEmptyString) {
            let twitterURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", self.twitterUsername]];
            return twitterURL;
        }
    }
    return nil;
}

- (BOOL)isOnline {
    return (self.state != CCNChannelStateUndefined && self.state != CCNChannelStateOffline);
}

// MARK: - Debugging

- (NSString *)description {
    let desc = NSMutableString.new;
    [desc appendFormat:@"channelID: %@", self.channelId];
    if (self.creator) {
        [desc appendFormat:@", creator: %@", self.creator];
    }
    if (self.name) {
        [desc appendFormat:@", name: %@", self.name];
    }
    if (self.followerCount) {
        [desc appendFormat:@", name: %li", self.followerCount];
    }
    if (self.email) {
        [desc appendFormat:@", email: %@", self.email];
    }
    if (self.websiteURL) {
        [desc appendFormat:@", website: %@", self.websiteURL.absoluteString];
    }
    if (self.twitterURL) {
        [desc appendFormat:@", twitter: %@", self.twitterURL.absoluteString];
    }
    if (self.chatURL) {
        [desc appendFormat:@", chat: %@", self.chatURL.absoluteString];
    }
    if (self.streamURL) {
        [desc appendFormat:@", stream: %@", self.streamURL.absoluteString];
    }

    return desc;
}

// MARK: - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithObject:self.parseObject];
}

@end
