//
//  Created by Frank Gregor on 27/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNChannelGridItemControlView;
@class CCNChannel;

@interface CCNChannelGridItemView : NSView

@property (nonatomic, readonly) NSView *imageContainer;
@property (nonatomic, readonly) NSImageView *imageView;
@property (nonatomic, readonly) NSTextField *textField;
@property (nonatomic, readonly) NSTextField *channelStatusLabel;
@property (nonatomic, strong) CCNChannelGridItemControlView *controlView;
@property (nonatomic, assign) BOOL trackingAreaEnabled;

@end
