//
//  Created by Frank Gregor on 24/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//


typedef void (^CCNImageAsyncPrefetchHandler)(__weak NSImage *_Nullable cachedImage);
typedef void (^CCNImageAsyncLoadCompletion)(NSImage *_Nullable fetchedImage, BOOL isCached);


// MARK: - NSImage+AsyncLoading
@interface NSImage (AsyncLoading)
+ (void)loadFromURL:(NSURL *_Nonnull)imageURL completion:(nonnull CCNImageAsyncLoadCompletion)fetchCompletion;
+ (void)loadFromURL:(NSURL *_Nonnull)imageURL placeholderImage:(NSImage *_Nonnull)placeholderImage prefetchHandler:(nonnull CCNImageAsyncPrefetchHandler)prefetchHandler fetchCompletion:(nonnull CCNImageAsyncLoadCompletion)fetchCompletion;
+ (void)cacheImageInBackgroundWithURL:(NSURL *_Nonnull)imageURL;
@end

// MARK: - CCNImageCache
@interface CCNImageCache : NSObject

+ (nonnull instancetype)sharedInstance;

@property (nonatomic, readonly) dispatch_queue_t _Nonnull cacheQueue;

- (void)cacheImage:(NSImage *_Nonnull)inImage forKey:(NSString *_Nonnull)imageKey;
- (NSImage *_Nonnull)cachedImageForKey:(NSString *_Nonnull)imageKey;
- (BOOL)hasImageForKey:(NSString *_Nonnull)imageKey;

@end
