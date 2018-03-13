//
//  Created by Frank Gregor on 28/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNChannel;
@class CCNPlayerPlayPauseButton;

@interface CCNChannelGridItemControlView : NSView

@property (nonatomic, weak) CCNChannel *channel;
@property (nonatomic, readonly) CCNPlayerPlayPauseButton *playPauseButton;
@property (nonatomic, readonly) NSButton *subscribeButton;

@end
