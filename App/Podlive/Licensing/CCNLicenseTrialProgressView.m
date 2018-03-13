//
//  Created by Frank Gregor on 24.05.17.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNLicenseTrialProgressView.h"

@interface CCNLicenseTrialProgressView ()
@property (nonatomic, assign) CGFloat innerProgress;
@end

@implementation CCNLicenseTrialProgressView

- (void)drawRect:(NSRect)dirtyRect {
    [PodliveGUIKit drawProgressBarWithFrame:self.bounds color:self.borderColor progressBarActiveColor:self.activeColor progress:self.progress];
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0) {
        self.innerProgress = 1.0;
    }
    else if (progress < 0) {
        self.innerProgress = 0.0;
    }
    else {
        self.innerProgress = progress;
    }
    [self setNeedsDisplay:YES];
}

- (CGFloat)progress {
    return self.innerProgress * (self.bounds.size.width-4);
}

@end
