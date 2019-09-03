//
//  XKMallBuyCarViewModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"
@class  MallOrderListDataItem;
#import "XKTradingAreaPrePayModel.h"
@interface XKMallBuyCarItem : BaseModel
@property (nonatomic , copy) NSString              * goodsAttr;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , assign) NSInteger              quantity;
@property (nonatomic , copy) NSString              * goodsPic;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              *url;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * itemStatus;
@property (nonatomic , copy) NSString              * goodsSkuCode;
@property (nonatomic, assign) NSInteger             status;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL selected;
//购物车优惠券
@property (nonatomic , copy) NSString              * couponId;
@property (nonatomic , copy) NSString              * couponName;
@property (nonatomic , copy) NSString              * couponType;
@property (nonatomic , copy) NSString              * invalidTime;
@property (nonatomic , copy) NSString              * message;
@property (nonatomic , copy) NSString              *validTime;
@property (nonatomic , assign) NSInteger              whetherDraw;
//订单优惠券
@property (nonatomic , copy) NSString              * cardId;
@property (nonatomic , copy) NSString              * cardMessage;
@property (nonatomic , copy) NSString              * cardName;
@property (nonatomic , copy) NSString              * cardType;
@property (nonatomic , assign) NSInteger              state;

@end
@interface XKMallBuyCarViewModel : BaseModel

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger  limit;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *choseArr;
@property (nonatomic, assign) long totalPoint;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL manager;
@property (nonatomic, assign) BOOL lostCount;

@property (nonatomic , strong) NSArray <XKMallBuyCarItem *>              * data;
@property (nonatomic , assign) NSInteger              total;
//价格
@property (nonatomic , assign) CGFloat               goodsAmount;
@property (nonatomic , assign) CGFloat               postAmount;
@property (nonatomic, copy) NSString  *orderId;
/**请求购物车列表*/
+ (void)requestMallBuyCarListWithParam:(NSDictionary *)dic success:(void(^)(XKMallBuyCarViewModel *model))success failed:(void(^)(NSString *failedReason))failed;

/**批量删除*/
+ (void)deleteMallBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed;

/**收藏*/
+ (void)collectMallBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed;

//修改数目
+ (void)changeMallBuyCarListNumberWithAllArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed;

/**请求购物车优惠券列表*/
+ (void)requestMallBuyCarTicketWithParam:(NSDictionary *)dic success:(void(^)(NSArray *arr))success failed:(void(^)(NSString *failedReason))failed;

/**领取购物车优惠券*/
+ (void)drawMallBuyCarTicketWithParam:(NSDictionary *)dic success:(void(^)(id respons))success failed:(void(^)(NSString *failedReason))failed;

/**计算金额*/
+ (void)countMallBuyCarFeeWithParam:(NSDictionary *)dic success:(void(^)(XKMallBuyCarViewModel *model))success failed:(void(^)(NSString *failedReason))failed;

/**获取订单可以使用的优惠券列表*/
+ (void)requestMallBuyCarOrderTicketWithParam:(NSDictionary *)dic success:(void(^)(NSArray *arr))success failed:(void(^)(NSString *failedReason))failed;

/**下单*/
+ (void)orderMallBuyWithParam:(NSDictionary *)dic success:(void(^)(XKTradingAreaPrePayModel *model))success failed:(void(^)(NSString *failedReason))failed;
@end
