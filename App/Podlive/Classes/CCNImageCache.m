//
//  Created by Frank Gregor on 24/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "CCNImageCache.h"


// MARK: - NSImage+AsyncLoading

@implementation NSImage (AsyncLoading)

+ (void)loadFromURL:(NSURL *_Nonnull)imageURL completion:(nonnull CCNImageAsyncLoadCompletion)fetchCompletion {
    NSParameterAssert(imageURL != nil);

    CCNImageCache *imageCache = [CCNImageCache sharedInstance];
    dispatch_async(imageCache.cacheQueue, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:imageURL]
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        NSImage *fetchedImage = [[NSImage alloc] initWithData:data];
                                                        fetchCompletion(fetchedImage, NO);
                                                    });
                                                }];
        [task resume];
    });
}

+ (void)loadFromURL:(NSURL *_Nonnull)imageURL placeholderImage:(NSImage *_Nonnull)placeholderImage prefetchHandler:(nonnull CCNImageAsyncPrefetchHandler)prefetchHandler fetchCompletion:(nonnull CCNImageAsyncLoadCompletion)fetchCompletion {
    NSParameterAssert(imageURL != nil);

    CCNImageCache *imageCache = [CCNImageCache sharedInstance];
    if ([imageCache hasImageForKey:imageURL.absoluteString]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            prefetchHandler([imageCache cachedImageForKey:imageURL.absoluteString]);
        });
        return;
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            prefetchHandler(placeholderImage);
        });
    }

    dispatch_async(imageCache.cacheQueue, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:imageURL]
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSImage *fetchedImage = [[NSImage alloc] initWithData:data];
                                                    if (fetchedImage) {
                                                        [imageCache cacheImage:fetchedImage forKey:imageURL.absoluteString];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            fetchCompletion(fetchedImage, NO);
                                                        });
                                                    }
                                                }];
        [task resume];
    });
}

+ (void)cacheImageInBackgroundWithURL:(NSURL *_Nonnull)imageURL {
    NSParameterAssert(imageURL != nil);

    CCNImageCache *imageCache = [CCNImageCache sharedInstance];
    if ([imageCache hasImageForKey:imageURL.absoluteString]) {
        return;
    }

    dispatch_async(imageCache.cacheQueue, ^{
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:imageURL]
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSImage *fetchedImage = [[NSImage alloc] initWithData:data];
                                                    if (fetchedImage) {
                                                        [imageCache cacheImage:fetchedImage forKey:imageURL.absoluteString];
                                                    }
                                                }];
        [task resume];
    });
}

@end


// MARK: - NSString+Crypto

@implementation NSString (Crypto)

- (NSString *_Nullable)SHA1String {
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

@end


// MARK: - CCNImageCache

@implementation CCNImageCache

+ (nonnull instancetype)sharedInstance {
    static dispatch_once_t _onceToken;
    static CCNImageCache *_sharedInstance;
    dispatch_once(&_onceToken, ^{
        _sharedInstance = [[[self class] alloc] initSingleton];
    });
    return _sharedInstance;
}

- (instancetype)initSingleton {
    self = [super init];
    if (self) {
        // put your inits here
    }
    return self;
}

- (instancetype)init {
    @throw [[self class] initException];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    @throw [[self class] initException];
}

// MARK: - Init Exception

+ (NSException *)initException {
    NSString *exceptionMessage = [NSString stringWithFormat:@"'%@' is a Singleton, and you must NOT init manually! Use +sharedInstance instead.", [self className]];
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:exceptionMessage userInfo:nil];
}

// MARK: - API

- (void)cacheImage:(NSImage *_Nonnull)inImage forKey:(NSString *_Nonnull)imageKey {
    if (!inImage || !imageKey) {
        return;
    }
    [self _cacheImage:inImage forKey:imageKey];
}

- (NSImage *_Nonnull)cachedImageForKey:(NSString *_Nonnull)imageKey {
    NSParameterAssert(imageKey != nil);
    return [self _cachedImageForKey:imageKey];
}

- (BOOL)hasImageForKey:(NSString *_Nonnull)imageKey {
    NSParameterAssert(imageKey != nil);
    NSString *cachedFilePath = [self _cacheFilePathForKey:imageKey];
    return [[NSFileManager defaultManager] fileExistsAtPath:cachedFilePath];
}

// MARK: - Custom Accessors

- (dispatch_queue_t)cacheQueue {
    static dispatch_once_t onceToken;
    static dispatch_queue_t _cacheQueue;
    dispatch_once(&onceToken, ^{
        _cacheQueue = dispatch_queue_create("com.cocoanaut.image-cache.queue", DISPATCH_QUEUE_SERIAL);
    });
    return _cacheQueue;
}


// MARK: - Private Helper

- (void)_cacheImage:(NSImage *_Nonnull)inImage forKey:(NSString *_Nonnull)imageKey {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.cacheQueue, ^{
        [[inImage TIFFRepresentation] writeToFile:[weakSelf _cacheFilePathForKey:imageKey] atomically:YES];
    });
}

- (NSImage *_Nonnull)_cachedImageForKey:(NSString *_Nonnull)imageKey {
    NSString *cachedFilePath = [self _cacheFilePathForKey:imageKey];
    NSData *cacheData = [NSData dataWithContentsOfFile:cachedFilePath];
    NSImage *cachedImage = [[NSImage alloc] initWithData:cacheData];
    return cachedImage;
}

- (NSString *)_cacheDirectory {
    static dispatch_once_t onceToken;
    static NSString *_cacheDirectory = nil;
    dispatch_once(&onceToken, ^{
        _cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", NSStringFromClass([CCNImageCache class])]];
        [[NSFileManager defaultManager] createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    });
    return _cacheDirectory;
}

- (NSString *)_cacheFilePathForKey:(NSString *_Nonnull)imageKey {
    NSParameterAssert(imageKey != nil);
    NSString *SHA1String = [NSString stringWithFormat:@"%@", [imageKey SHA1String]];
    return [[self _cacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", SHA1String]];
}

@end
