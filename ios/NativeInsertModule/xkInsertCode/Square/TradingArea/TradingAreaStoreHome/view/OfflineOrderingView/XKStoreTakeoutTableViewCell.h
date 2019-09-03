//
//  XKStoreTakeoutTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATShopGoodsItem;

typedef void(^GoBuyBlock)(UITableViewCell *cell);
typedef void(^GoodsItemBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, NSString *goodsId);

@interface XKStoreTakeoutTableViewCell : UITableViewCell

@property (nonatomic, copy  ) GoBuyBlock       goBuyBlock;
@property (nonatomic, copy  ) GoodsItemBlock   itemBlock;

- (void)setTitleName:(NSString *)titleName;
- (void)setValueWithModelArr:(NSArray<ATShopGoodsItem *> *)arr;

@end
