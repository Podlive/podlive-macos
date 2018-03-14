//
//  Created by Frank Gregor on 04/04/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNBaseButton;

typedef NS_ENUM(NSUInteger, CCNBaseButtonStyle) {
    CCNBaseButtonStyleRoundedRect,
    CCNBaseButtonStyleRound
};

typedef void (^CCNButtonAction)(__kindof CCNBaseButton *actionButton);


@interface CCNBaseButton : NSView

+ (instancetype)buttonWithSize:(NSSize)buttonSize actionHandler:(CCNButtonAction)actionHandler;
- (instancetype)initWithSize:(NSSize)buttonSize actionHandler:(CCNButtonAction)actionHandler NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@property (nonatomic, assign) NSSize buttonSize;
@property (nonatomic, copy) CCNButtonAction actionHandler;

@property (nonatomic, assign) CCNBaseButtonStyle style;                     // default: CCNBaseButtonStyleRoundedRect; If type == CCNBaseButtonStyleRound the vallue of property cornerRadius will be ignored and set to buttonSize.width/2 instead
@property (nonatomic, assign) CGFloat cornerRadius;                         // default: 5.0
@property (nonatomic, assign) CGFloat borderWidth;                          // default: 2.0
@property (nonatomic, strong) NSColor *tintColor;                           // default: NSColor.lightGrayColor
@property (nonatomic, strong) NSColor *tintHighlightColor;                  // default: NSColor.whiteColor
@property (nonatomic, assign) NSInteger state;                              // default: NSOffState

@property (nonatomic, readonly, getter=isMouseHovered) BOOL mouseHovered;

@end
