//
//  XKOderSureGoodsInfoCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsSkuVOListItem;
@class OrderItems;
@class PurchasesItem;

typedef void(^GotoPayBlock)(void);

@interface XKOderSureGoodsInfoCell : UITableViewCell

@property (nonatomic, copy  ) GotoPayBlock  gotoPayBlock;


//下单使用
- (void)setValueWithModel:(GoodsSkuVOListItem *)model num:(NSInteger)num;
//订单详情使用
- (void)setValueWithModel:(OrderItems *)model;
//订单加购使用
- (void)setValueWithPurchasesModel:(PurchasesItem *)model orderTpye:(NSString *)orderType;

- (void)showSelectedBtn:(BOOL)show;
- (void)hiddenLineView:(BOOL)hidden;
- (void)hiddenStatusBtn:(BOOL)hidden;

@end
