//
//  XKTradingAreaOrderDetailBaseAdapter.h
//  XKSquare
//
//  Created by hupan on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XKTradingAreaGoodsInfoModel;
@class XKTradingAreaOrderDetaiModel;
@class OrderItems;
@class PurchasesItem;

typedef enum : NSUInteger {
    OrderDetailType_service,//服务
    OrderDetailType_hotel,//酒店
    OrderDetailType_offline,//现场购物
    OrderDetailType_online,//外卖
} OrderDetailType;

typedef NS_ENUM(NSInteger ,OrderStatus) {
    OrderStatus_pick = 0, //待接单
    OrderStatus_pay, //待支付
    OrderStatus_use, //待消费
    OrderStatus_prepare,//备货中
    OrderStatus_useing,//进行中
    OrderStatus_evaluate,//待评价
    OrderStatus_finsh,//已完成
    OrderStatus_afterSale,//售后 OrderStatus_refunding, OrderStatus_canceling,合成一个
    /*OrderStatus_refunding,//退款中
    OrderStatus_canceling,//取消中*/
    OrderStatus_close//已关闭
};


@protocol XKTradingAreaOrderDetailAdapterDelegate <NSObject>

@optional

- (void)refreshTradingAreaOrderDetail;
- (void)gotoPayAddGoodsItem:(NSArray<OrderItems *> *)arr;
- (void)refundSeviceOrHotelItem:(NSArray<OrderItems *> *)arr;
- (void)deletePurchaseOrder;
- (void)cancelPurchaseOrderWithPurchaseItems:(NSArray<PurchasesItem *> *)arr;
- (void)refundPurchaseOrderWithPurchaseItems:(NSArray<PurchasesItem *> *)arr;

- (void)addGoodsWithShopId:(NSString *)shopId orderId:(NSString *)orderId itemId:(NSString *)itemId;
- (void)addressButtonSelected:(NSString *)addressName lat:(double)lat lng:(double)lng;
- (void)phoneButtonSelected:(UIButton *)sender phoneArray:(NSArray *)phoneArr;
- (void)shareStoreButtonSelected;

@end


@interface XKTradingAreaOrderDetailBaseAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView                                 *tableView;
@property (nonatomic, weak  ) id<XKTradingAreaOrderDetailAdapterDelegate> delegate;
@property (nonatomic, strong) XKTradingAreaOrderDetaiModel                *orderModel;

//提供给子类使用的参数
@property (nonatomic, assign) OrderStatus                                 orderStatus;
@property (nonatomic, assign) OrderDetailType                             orderType;
@property (nonatomic, assign) NSInteger                                   takeoutWay;//0 配送上门   1自提
@property (nonatomic, strong) NSMutableArray                              *purchaseMuarr;//加购数组
@property (nonatomic, assign) BOOL                                        showPurchaseBtn;//显示加购按钮

@property (nonatomic, assign) NSInteger                                   addGoodsNum;
@property (nonatomic, assign) CGFloat                                     addGoodsPrice;//加购价格总和
@property (nonatomic, assign) CGFloat                                     goodsPrice;//服务价格总和

- (OrderDetailType)getOrderIndustryType;

@end
