//
//  XKTradingAreaGoodsDetailChooseSpecificationView.h
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKTradingAreaGoodsInfoModel;
@class GoodsSkuVOListItem;

typedef void(^CloseBlock)(void);
typedef void(^SureBlock)(NSArray<GoodsSkuVOListItem *> *itemsArr);

@interface XKTradingAreaGoodsDetailChooseSpecificationView : UIView

@property (nonatomic, copy  ) CloseBlock   closeBlock;
@property (nonatomic, copy  ) SureBlock    sureBlock;


- (void)setValueWithModel:(XKTradingAreaGoodsInfoModel *)model;

@end
