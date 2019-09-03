//
//  XKTradingAreaOrderFooterView.h
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKTradingAreaOrderDetaiModel;

@interface XKTradingAreaOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView       *backView;

- (void)setTitleWithNum:(NSInteger)num totalPrice:(CGFloat)price payPrice:(CGFloat)payPrice;
- (void)setTitleWithTotalPrice:(CGFloat)price tip:(NSString *)tip;
- (void)setTitleWithLogisticFee:(CGFloat)logisticFee goodsPrice:(CGFloat)price;

//售后显示 外卖
- (void)setAfterSaleValue:(XKTradingAreaOrderDetaiModel *)orderModel logisticFee:(CGFloat)logisticFee;
//售后显示 服务或者加购 (goodsNum=0服务   goodsNum!=0加购)
- (void)setAfterSaleValue:(XKTradingAreaOrderDetaiModel *)orderModel goodsNum:(CGFloat)goodsNum;

@end
