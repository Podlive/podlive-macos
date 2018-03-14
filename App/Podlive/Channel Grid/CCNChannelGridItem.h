//
//  Created by Frank Gregor on 28/02/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@class CCNChannel;
@class CCNChannelGridItem;

@protocol CCNChannelGridItemDelegate <NSObject>
- (void)handlePlayPauseActionForGridItem:(CCNChannelGridItem *)gridItem;
- (void)handleSubscribeActionForGridItem:(CCNChannelGridItem *)gridItem;
@end

@interface CCNChannelGridItem : NSCollectionViewItem

@property (nonatomic, weak) id<CCNChannelGridItemDelegate> delegate;
@property (nonatomic, strong) CCNChannel *channel;

@end
