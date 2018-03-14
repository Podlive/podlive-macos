//
//  Created by Frank Gregor on 13/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//


typedef NS_ENUM(NSInteger, CCNPlayerImageType) {
    CCNPlayerImageTypeUndefined = -1,
    CCNPlayerImageTypeTimer     = 0,
    CCNPlayerImageTypeListener  = 1
};


@interface CCNPlayerImageView : NSView

+ (instancetype)viewWithSize:(NSSize)viewSize;
+ (instancetype)viewWithSize:(NSSize)viewSize imageType:(CCNPlayerImageType)imageType;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;

@property (nonatomic, assign) CCNPlayerImageType imageType;
@property (nonatomic, strong) NSColor *tintColor;

@end
