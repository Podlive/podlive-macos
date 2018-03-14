//
//  Created by Frank Gregor on 07/03/2017.
//  Copyright © 2017 cocoa:naut. All rights reserved.
//

@interface NSCollectionView (CCNAppKit)

/**
 Returns the most right `NSCollectionViewItem in the same row of the given `NSCollectionViewItem`.

 @param inItem A `NSCollectionViewItem` instance. The value of this property must not be `nil`.
 @return The most right `NSCollectionViewItem in the same row.
 */
- (__kindof NSCollectionViewItem *_Nonnull)lastItemInRowForItem:(__kindof NSCollectionViewItem *_Nonnull)inItem;

/**
 Center point for a given NSCollectionViewItem.

 @param inItem The NSCollectionViewItem instance in question.
 @return The NSCollectionViewItem center point.
 */
- (NSPoint)centerPointForItem:(__kindof NSCollectionViewItem *_Nonnull)inItem;

@end
