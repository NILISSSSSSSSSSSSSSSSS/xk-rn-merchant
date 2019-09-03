//
//  XKStoreOrderDishesTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATShopGoodsItem;

typedef void(^ItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath);

@interface XKStoreOrderDishesTableViewCell : UITableViewCell

@property (nonatomic, copy  ) ItemBlock itemBlock;

- (void)setValueWithModelArr:(NSArray<ATShopGoodsItem *> *)arr;

@end
