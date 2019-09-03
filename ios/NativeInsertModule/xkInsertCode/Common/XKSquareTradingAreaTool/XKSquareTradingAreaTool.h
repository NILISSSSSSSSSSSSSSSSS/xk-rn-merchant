//
//  XKSquareTradingAreaTool.h
//  XKSquare
//
//  Created by hupan on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentListItem;
@class XKTradingAreaCommentLabelsModel;
@class XKTradingAreaShopInfoModel;
@class XKTradingAreaGoodsInfoModel;
@class XKTradingAreaIndustyAllCategaryModel;
@class ShopListItem;
@class XKTradingAreaCommentGradeModel;
@class XKGoodsCoustomCategaryListModel;
@class CategaryGoodsItem;
@class CouponItemModel;
@class ShopCardModel;
@class XKTradingAreaCreatOderModel;
@class XKSetItem;
@class XKTradingAreaSeatListModel;
@class AreaOrderListModel;
@class XKTradingAreaOrderDetaiModel;
@class XKTradingAreaAddGoodSuccessModel;
@class XKTradingAreaGetPriceModel;
@class XKTradingAreaOrderCouponModel;
@class XKTradingAreaPrePayModel;
@class XKTradingAreaSeatVerifyModel;

typedef NS_ENUM(NSInteger ,BusinessAreaOrderType) {
    MOT_PICK = 0, //待接单
    MOT_PAY, //待支付
    MOT_USE, //待消费
    MOT_PREPARE,//备货中
    MOT_USEING,//进行中
    MOT_EVALUATE,//待评价
    MOT_FINISH,//已完成
    MOT_REFUND,//售后中
    MOT_CLOSED//已关闭
};

@interface XKSquareTradingAreaTool : NSObject

//商圈行业分类
+ (void)tradingAreaIndustryAllCategaryList:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaIndustyAllCategaryModel *model))success faile:(void(^)(XKHttpErrror *error))faile;

//获取商店详情
+ (void)tradingAreaShopInfo:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaShopInfoModel *model))success faile:(void(^)(XKHttpErrror *error))faile;

//获取商店收藏状态
+ (void)tradingAreaShopFavoriteStatus:(NSDictionary *)parameters success:(void (^__strong)(NSInteger code))success faile:(void(^)(XKHttpErrror *error))faile;

//收藏
+ (void)tradingAreaShopFavorite:(NSDictionary *)parameters success:(void (^__strong)(NSInteger code))success faile:(void(^)(XKHttpErrror *error))faile;

//取消收藏
+ (void)tradingAreaShopCancelFavorite:(NSDictionary *)parameters success:(void (^__strong)(NSInteger code))success faile:(void(^)(XKHttpErrror *error))faile;


//获取商店列表
+ (void)tradingAreaShopList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<ShopListItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile;


//获取商店评论标签
+ (void)tradingAreaShopCommentLabels:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<XKTradingAreaCommentLabelsModel *> *result))success;

//获取商品或者商店评论列表
+ (void)tradingAreaGoodsOrShopCommentList:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<CommentListItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile;

//获取商品评论标签
+ (void)tradingAreaGoodsCommentLabels:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<XKTradingAreaCommentLabelsModel *> *result))success;

//获取商品详情
+ (void)tradingAreaGoodsDetail:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaGoodsInfoModel *model))success;


//获取商店评论数及评分
+ (void)tradingAreaShopCommentGrade:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaCommentGradeModel *model))success;


//获取商品评论数及评分
+ (void)tradingAreaGoodsCommentGrade:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(XKTradingAreaCommentGradeModel *model))success;



//获取商品商家自定义二级分类
+ (void)tradingAreaGoodsCoustomCategaryList:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<XKGoodsCoustomCategaryListModel *> *listArr))success;


//根据商家自定义二级分类获取商品
+ (void)tradingAreaCategaryGoodsList:(NSDictionary *)parameters group:(dispatch_group_t)group success:(void (^__strong)(NSArray<CategaryGoodsItem *> *listArr))success;



//获取商家优惠券列表
+ (void)tradingAreaShopCouponList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<CouponItemModel *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile;

//获取商家会员卡列表
+ (void)tradingAreaShopMemberList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<ShopCardModel *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile;

//获取商家抽奖卡列表
+ (void)tradingAreaShopRewardList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<CategaryGoodsItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile;


//领取商家优惠券
+ (void)tradingAreaShopCouponUserDraw:(NSDictionary *)parameters success:(void (^__strong)(id result))success faile:(void (^)(XKHttpErrror *error))faile;

//领取商家会员卡
+ (void)tradingAreaShopMemberUserDraw:(NSDictionary *)parameters success:(void (^__strong)(id result))success faile:(void (^)(XKHttpErrror *error))faile;

//领取商家抽奖卡
+ (void)tradingAreaShopRewardUserDraw:(NSDictionary *)parameters success:(void (^__strong)(id result))success faile:(void (^)(XKHttpErrror *error))faile;

//获取席位分类
+ (void)tradingAreaSeatCategaryList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKSetItem *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile;

//获取席位列表
+ (void)tradingAreaSeatList:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKTradingAreaSeatListModel *> *listArr))success faile:(void (^)(XKHttpErrror *error))faile;

//席位验证
+ (void)tradingAreaVerifierOrderSeat:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaSeatVerifyModel *model))success faile:(void (^)(XKHttpErrror *error))faile;

//创建订单
+ (void)tradingAreaCreatOrder:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaCreatOderModel *model))success faile:(void (^)(XKHttpErrror *error))faile;

//取消订单(取消全部)
+ (void)tradingAreaCancelOrder:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaCreatOderModel *model))success faile:(void (^)(XKHttpErrror *error))faile;

//取消订单(取消服务(服务包含的加购后台会对应取消))
+ (void)tradingAreaCancelServiceOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile;

//删除加购订单(针对于未接单前的订单)
+ (void)tradingAreaDeletePurchaseOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile;

//取消加购订单(针对于已接单但是未支付的订单)
+ (void)tradingAreaCancelPurchaseOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile;

//退款加购订单(针对于已支付但是未完成的订单)
+ (void)tradingAreaRefundPurchaseOrder:(NSDictionary *)parameters success:(void (^)(NSInteger status))success faile:(void (^)(XKHttpErrror *error))faile;

//商圈商品预支付
+ (void)tradingAreaOrderPrePay:(NSDictionary *)parameters typeStr:(NSString *)typeStr success:(void (^)(XKTradingAreaPrePayModel *model))success faile:(void (^)(XKHttpErrror *error))faile;

//商圈商品0元支付或者有退款
+ (void)tradingAreaOrderPrePayRefundOrder:(NSDictionary *)parameters success:(void (^)(id reslut))success faile:(void (^)(XKHttpErrror *error))faile;

//获取订单列表
+ (void)tradingAreaOrderList:(NSDictionary *)parameters orderType:(BusinessAreaOrderType)orderType success:(void (^__strong)(NSArray<AreaOrderListModel *> *list))success faile:(void (^)(XKHttpErrror *error))faile;

//获取订单详情
+ (void)tradingAreaOrderDetail:(NSDictionary *)parameters isRefundOrder:(BOOL)isRefundOrder success:(void (^__strong)(XKTradingAreaOrderDetaiModel *model))success faile:(void (^)(XKHttpErrror *error))faile;

//订单加购
+ (void)tradingAreaOrderAddGoods:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKTradingAreaAddGoodSuccessModel *> *list))success faile:(void (^)(XKHttpErrror *error))faile;


//获取订单支付金额
+ (void)tradingAreaOrderGetPayPrice:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaGetPriceModel *model))success faile:(void (^)(XKHttpErrror *error))faile;

//提示商家我要付款
+ (void)tradingAreaTellMerchantOrderWillPay:(NSDictionary *)parameters success:(void (^__strong)(XKTradingAreaCreatOderModel *model))success faile:(void (^)(XKHttpErrror *error))faile;


//获取订单的优惠券
+ (void)tradingAreaGetOrderCoupons:(NSDictionary *)parameters success:(void (^__strong)(NSArray<XKTradingAreaOrderCouponModel *> *list))success faile:(void (^)(XKHttpErrror *error))faile;

//订单列表去支付
+ (void)tradingAreaOrderListGotoPay:(NSString *)orderId targetViewController:(BaseViewController *)viewController faile:(void (^)(XKHttpErrror *error))faile;

//支付（废弃接口）
+ (void)showPayWithPrice:(CGFloat)price orderId:(NSString *)orderId payWay:(NSString *)payWay successBlock:(void(^)(id data))success failedBlock:(void(^)(NSString *reason))failed;


@end
