//
//  Created by Frank Gregor on 06/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

typedef void (^CCNChannelGridFlowLayoutAnimationCompletion)(void);

@interface CCNChannelGridFlowLayout : NSCollectionViewFlowLayout

@property (readonly) NSRect selectedItemFrame;                                  // this property is bind to CCNChannelGridItemDetailView.selectedItemFrame and uses CCNSelectedItemFrameKeyPath constant
@property (nonatomic, readonly) NSIndexPath *selectedIndexPath;
@property (nonatomic, readonly) CGFloat expandedHeight;

- (void)expandDetailViewAtIndexPath:(NSIndexPath *)indexPath completion:(CCNChannelGridFlowLayoutAnimationCompletion)completion;
- (void)collapseDetailViewWithCompletion:(CCNChannelGridFlowLayoutAnimationCompletion)completion;

@end

FOUNDATION_EXPORT const CGFloat kDetailViewExpandedHeight;
FOUNDATION_EXPORT NSCollectionViewSupplementaryElementKind const CCNCollectionElementKindItemDetail;
FOUNDATION_EXPORT NSString *const CCNSelectedItemFrameKeyPath;
