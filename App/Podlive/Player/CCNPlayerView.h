//
//  Created by Frank Gregor on 15/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNPlayerPlayPauseButton;
@class CCNPlayerStopButton;
@class CCNPlayerVolumeControl;

@interface CCNPlayerView : NSView

@property (nonatomic, readonly) CCNPlayerPlayPauseButton *playPauseButton;
@property (nonatomic, readonly) CCNPlayerStopButton *stopButton;
@property (nonatomic, readonly) CCNPlayerVolumeControl *volumeControl;
@property (nonatomic, readonly) NSTextField *timeTextField;
@property (nonatomic, readonly) NSTextField *listenerTextField;

@end
