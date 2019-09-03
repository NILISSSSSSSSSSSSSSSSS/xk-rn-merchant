//
//  XKTradingAreaOrderRefundViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
@class OrderItems;
@class PurchasesItem;

typedef enum : NSUInteger {
    OrderRefundType_cancelOrder = 1,//取消主单
    OrderRefundType_refundSeverOrHetol,//取消服务或者酒店
    OrderRefundType_cancelPurchase,//取消加购已接单未支付商品
    OrderRefundType_refundPurchase,//取消加购已接单且已支付未结算商品
} OrderRefundType;

@interface XKTradingAreaOrderRefundViewController : BaseViewController

@property (nonatomic, assign) OrderRefundType            type;
@property (nonatomic, copy  ) NSString                   *orderId;//cancelOrder 时传
@property (nonatomic, copy  ) NSArray<PurchasesItem *>   *purchasesItemArr;//cancelPurchase、refundPurchase 时传
@property (nonatomic, copy  ) NSArray<OrderItems *>      *orderItemsArr;//refundSeverOrHetol 时传
@end
