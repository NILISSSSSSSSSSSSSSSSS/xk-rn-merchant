//
//  XKShareItemCollectionViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKShareItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKShareItemCollectionViewCell : UICollectionViewCell

- (void)configCellWithModel:(XKShareItemModel *) model ;

@end

NS_ASSUME_NONNULL_END
