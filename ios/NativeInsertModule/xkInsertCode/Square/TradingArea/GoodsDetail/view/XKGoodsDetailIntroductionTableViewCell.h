//
//  XKGoodsDetailIntroductionTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKAutoScrollView;
@class XKAutoScrollImageItem;
@class GoodsModel;

typedef void(^GoodsCoverItemBlock)(XKAutoScrollView *autoScrollView, XKAutoScrollImageItem *item, NSInteger index);

@interface XKGoodsDetailIntroductionTableViewCell : UITableViewCell

@property (nonatomic, copy  ) GoodsCoverItemBlock    coverItemBlock;

- (void)setValuesWithModel:(GoodsModel *)model;

@end
