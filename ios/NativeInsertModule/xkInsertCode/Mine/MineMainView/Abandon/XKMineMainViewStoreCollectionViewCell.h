//
//  XKMineMainViewStoreCollectionViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelfareDataItem;

@interface XKMineMainViewStoreCollectionViewCell : UICollectionViewCell

- (void)configCellWithWelfareGoodsListViewModel:(WelfareDataItem *)model;

@end
