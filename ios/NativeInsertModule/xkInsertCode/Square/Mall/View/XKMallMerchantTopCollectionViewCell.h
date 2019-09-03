//
//  XKMallMerchantTopCollectionViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKAutoScrollView;
@class XKAutoScrollImageItem;
@class GoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface XKMallMerchantTopCollectionViewCell : UICollectionViewCell

typedef void(^GoodsCoverItemBlock)(XKAutoScrollView *autoScrollView, XKAutoScrollImageItem *item, NSInteger index);

@property (nonatomic, copy  ) GoodsCoverItemBlock    coverItemBlock;

- (void)setValuesWithModel:(GoodsModel *)model;
@end

NS_ASSUME_NONNULL_END
