//
//  XKTradingAreaGoodsInfoTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;

@protocol GoodsImageDelegate <NSObject>

- (void)goodsInfoImgCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XKTradingAreaGoodsInfoTableViewCell : UITableViewCell

@property (nonatomic, weak  ) id<GoodsImageDelegate> delegate;

- (void)setValuesWithModel:(GoodsModel *)model;

@end
