//
//  Created by Frank Gregor on 20/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNChannel;
@class CCNChannelGridItemDetailView;
@class CCNChannelGridItemDetailContainerView;

@protocol CCNChannelGridItemDetailViewDelegate <NSObject>
@optional
- (void)gridItemDetailViewShouldClose:(CCNChannelGridItemDetailView *)detailView;
@end


@interface CCNChannelGridItemDetailView : NSView <NSCollectionViewElement>

@property (nonatomic, weak) CCNChannel *channel;
@property (nonatomic, assign) NSRect selectedItemFrame;                                     // this property is bind to CCNChannelGridFlowLayout.selectedItemFrame and uses CCNSelectedItemFrameKeyPath constant
@property (nonatomic, weak) id<CCNChannelGridItemDetailViewDelegate> delegate;
@property (nonatomic, readonly) NSView *container;

@end
