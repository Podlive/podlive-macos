//
//  Created by Frank Gregor on 04/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNPlayerVolumeSlider;

typedef void (^CCNPlayerVolumeSliderAction)(CCNPlayerVolumeSlider *slider);

@interface CCNPlayerVolumeSlider : NSSlider

+ (instancetype)sliderWithAction:(CCNPlayerVolumeSliderAction)actionHandler;
@property (nonatomic, copy) CCNPlayerVolumeSliderAction actionHandler;

@property (nonatomic, strong) NSColor *minimumTrackTintColor;
@property (nonatomic, strong) NSColor *maximumTrackTintColor;

@end

FOUNDATION_EXPORT NSString *const CCNPlayerVolumeSliderActionNotification;                  // notification object is the CCNPlayerVolumeSlider instance, userInfo dictionary is nil
