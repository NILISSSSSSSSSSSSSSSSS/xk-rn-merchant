//
//  XKMallOrderBaseViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/6.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"
#import "XKMallApplyAfterSaleListViewController.h"
#import "XKMallOrderViewModel.h"
#import "XKMallOrderDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKMallOrderBaseViewController : BaseViewController
@property (nonatomic, strong) UIAlertController *cancelAlert;
@property (nonatomic, assign) NSInteger  cancelIndex;
@property (nonatomic, copy) NSString  *orderId;
//取消订单成功回调
@property (nonatomic, strong) void(^cancelOrderBlock)(void);
//确认退款成功回调
@property (nonatomic, strong) void(^cancelRefundBlock)(void);
//确认收货成功回调
@property (nonatomic, strong) void(^sureOrderBlock)(XKMallOrderDetailViewModel *item);
//支付成功回调
@property (nonatomic, strong) void(^payOrderBlock)(void);
//购物车下单支付
- (void)requestPayWithGoodsArr:(NSArray *)goodsArr andOrderId:(NSString *)orderId payChannel:(NSString *)payChannel successBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed;
//付款
- (void)showPayWithItem:(MallOrderListDataItem *)item successBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed;
//批量付款
- (void)showPayWithItems:(NSArray *)itemArr successBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed;
//联系客服
- (void)chatWithCustomerServiceWithGoodsItem:(XKMallOrderDetailViewModel *)item;
//列表退货
- (void)goodsReturnWithListOrderWithGoodsItem:(MallOrderListDataItem *)item withStatus:(OrderStatus)status;
//详情退货
- (void)goodsReturnWithDetailOrderWithGoodsItem:(XKMallOrderDetailViewModel *)item withStatus:(OrderStatus)status ;
//取消订单
- (void)cancelOrderWithGoodsItem:(MallOrderListDataItem *)item suucessBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed;

//取消退货
- (void)cancelGoodsReturnWithGoodsItem:(MallOrderListDataItem *)item suucessBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed;
//确认收货
- (void)sureAcceptGoodsWithOrderId:(NSString *)orderId;
//列表点击更多
- (void)moreBtnClickForList:(UIButton *)sender withGoodsItem:(MallOrderListDataItem *)item functionName:(NSArray *)functionName;
//详情点击更多
- (void)moreBtnClickForDetail:(UIButton *)sender withGoodsItem:(XKMallOrderDetailViewModel *)item functionName:(NSArray *)functionName;
@end

NS_ASSUME_NONNULL_END
