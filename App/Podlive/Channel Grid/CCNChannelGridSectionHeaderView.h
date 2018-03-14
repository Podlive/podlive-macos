//
//  Created by Frank Gregor on 03/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef CCNChannelListSection CCNHeaderType;

@interface CCNChannelGridSectionHeaderView : NSView <NSCollectionViewElement>

@property (nonatomic) CCNHeaderType headerSection;
@property (nonatomic) NSInteger numberOfStreams;

@end
