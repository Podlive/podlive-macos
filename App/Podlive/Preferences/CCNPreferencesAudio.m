//
//  Created by Frank Gregor on 30/06/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

#import "CCNPreferencesAudio.h"
#import "CCNPreferencesWindowControllerProtocol.h"

#import "NSUserDefaults+Podlive.h"

@interface CCNPreferencesAudio () <CCNPreferencesWindowControllerProtocol>
@property (weak) IBOutlet NSTextField *volumeLabel;
@property (weak) IBOutlet NSTextField *volumeDescriptionLabel;
@property (weak) IBOutlet NSPopUpButton *volumePopup;
@end

@implementation CCNPreferencesAudio

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.preferencesId = CCNPreferencesIdAudio;

    return self;
}

- (void)viewDidLoad {
    [self setupUI];

    [super viewDidLoad];
}

- (void)setupUI {
    self.volumeLabel.stringValue = NSLocalizedString(@"Save Volume Level", @"Volume Level Selector Label");


    [self.volumePopup removeAllItems];
    [self.volumePopup addItemsWithTitles:@[
        NSLocalizedString(@"Globally", @"Volume Level Selector Item"),
        NSLocalizedString(@"Per Podcast", @"Volume Level Selector Item")
    ]];
    self.volumePopup.target = self;
    self.volumePopup.action = @selector(volumePopupAction:);

    [self updateUI];
}

- (void)updateUI {
    let defaults = NSUserDefaults.standardUserDefaults;

    [self.volumePopup selectItemAtIndex:defaults.volumeLevelPersistenceBehaviour];
    self.volumeDescriptionLabel.stringValue = [self descriptionForVolumeLevelPersistenceBehaviour:defaults.volumeLevelPersistenceBehaviour];
}

// MARK: - Actions

- (IBAction)volumePopupAction:(NSPopUpButton *)sender {
    let defaults = NSUserDefaults.standardUserDefaults;
    defaults.volumeLevelPersistenceBehaviour = [sender indexOfSelectedItem];

    [self updateUI];
}

// MARK: - Helper

- (NSString *)descriptionForVolumeLevelPersistenceBehaviour:(CCNPlayerVolumeLevelPersistenceBehaviour)behaviour {
    NSString *desc = nil;
    switch (behaviour) {
        case CCNPlayerVolumeLevelPersistenceBehaviourGlobal:
            desc = NSLocalizedString(@"The current volume level will be saved globally for all channels.", @"Prefs: Volume Level Description");
            break;
        case CCNPlayerVolumeLevelPersistenceBehaviourPerChannel:
            desc = NSLocalizedString(@"The current volume level of a streaming channel will be saved separately for this channel only.\n\nSwitching to another streaming channel adjusts the volume level automatically.", @"Prefs: Volume Level Description");
            break;
    }
    return desc;
}

#pragma mark - CCNPreferencesWindowControllerDelegate

- (NSString *)preferenceIdentifier  { return self.preferencesIdentifier; }
- (NSString *)preferenceTitle       { return NSLocalizedString( @"Audio", @"Preferences ViewController Title"); }

- (NSImage *)preferenceIcon {
    let image = [NSImage imageNamed:@"prefs-audio"];
    [image setTemplate:YES];
    return image;
}

@end
