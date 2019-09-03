//
//  XKMallOrderWaitPayViewModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//
typedef NS_ENUM(NSInteger ,MallOrderType) {
    MOT_PRE_PAY = 0, //待支付
    MOT_PRE_SHIP,//待配送
    MOT_PRE_RECEVICE,//待收货
    MOT_PRE_EVALUATE,//待评价
    MOT_COMPLETELY,//已完成
    MOT_TERMINATE,//已关闭
    MOT_SALED_SERVICE//售后中
};
#import "BaseModel.h"
@interface XKOrderListTransportInfoItem : NSObject
@property (nonatomic , copy) NSString              * location;
@property (nonatomic , copy) NSString              * time;
@end

@interface MallOrderListObj : NSObject
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * goodsShowAttr;
@property (nonatomic , copy) NSString              * goodsSkuId;
@property (nonatomic , copy) NSString              * goodsPic;
@property (nonatomic , assign) NSInteger              num;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic, assign) BOOL                    isChose;
@property (nonatomic , copy) NSString              * goodsSkuCode;
@property (nonatomic, strong) NSIndexPath          *index;
@property (nonatomic , copy) NSString              * refundStatus;
@property (nonatomic , copy) NSString              * refundId;
@property (nonatomic , copy) NSString              * auditStatus;

@end

@interface MallOrderListDataItem : NSObject
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , strong) NSArray <MallOrderListObj *>              * goods;
@property (nonatomic, strong) NSArray <XKOrderListTransportInfoItem *>  *logisticsInfos;
@property (nonatomic , copy) NSString              *orderId;
@property (nonatomic , copy) NSString              * sellerId;
@property (nonatomic , copy) NSString              * sellerName;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              totalPrice;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , assign) BOOL                   isChose;
@property (nonatomic , strong) NSIndexPath         *  index;

@property (nonatomic , copy) NSString              * auditStatus;
@property (nonatomic , copy) NSString              * refundId;
@property (nonatomic , copy) NSString              * refundStatus;
@property (nonatomic , copy) NSString              * refundType;
@end

@interface XKMallOrderListWaitPayModel : BaseModel
@property (nonatomic , strong) NSArray <MallOrderListDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;


+ (void)requestMallOrderListWithType:(MallOrderType)orderType ParamDic:(NSDictionary *)dic Success:(void(^)(XKMallOrderListWaitPayModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
@end

@interface XKMallOrderViewModel : BaseModel
@property (nonatomic , assign) NSInteger   page;
@property (nonatomic , assign) NSInteger   limit;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSTimeInterval  timestamp;
//退款理由
@property (nonatomic , copy) NSString              * refundReasonId;
@property (nonatomic , copy) NSString              * refundReason;

+ (void)cancelMallOrderWithOrderId:(NSString *)orderId  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

+ (void)sureAcceptMallOrderWithOrderId:(NSString *)orderId  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

+ (void)cancelGoodsReturnWithRefundId:(NSString *)refundId  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

+ (void)requestMallRefundReasonSuccess:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

+ (void)requestMallRefundWithParm:(NSDictionary *)dic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

+ (void)payForMallOrderWithParmDic:(NSDictionary *)dic  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

+ (void)uploadTransInfoWithParm:(NSDictionary *)dic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
@end
