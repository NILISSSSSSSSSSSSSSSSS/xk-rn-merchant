//
//  XKWelfareOrderDetailViewModel
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"
@interface XKWelfareGoodsTransportInfoItem : NSObject
@property (nonatomic , copy) NSString              * location;
@property (nonatomic , copy) NSString              * time;
@end

@interface XKWelfareOrderDetailItem : BaseModel
@property (nonatomic , assign) NSInteger              maxRate;
@property (nonatomic , assign) NSInteger              participateStake;
@property (nonatomic , assign) NSInteger              totalStake;
@end

@interface XKWelfareOrderNumberItem : BaseModel
@property (nonatomic , copy) NSString              * lotteryNumber;
@property (nonatomic , copy) NSString              * lotteryStatus;
@end
//中奖详情
@interface XKWelfareFinishDetailDataItem : NSObject
@property (nonatomic , strong) NSArray <XKWelfareOrderNumberItem *>              * lotteryNumbers;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , assign) NSInteger              factDrawDate;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , assign) NSInteger              orderNumber;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userType;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * commentId;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * pictures;
@property (nonatomic , copy) NSString              * redEnvelopeAmount;
@property (nonatomic , copy) NSString              * lotteryNumber;


@end

@interface XKWelfareOrderDetailViewModel : BaseModel
/**
 报损当前进度
 UNAUDITED,//未审核
 UNAPPROVED,未通过
 VERIFIED,通过
 OTHER;//未创建
 */
@property (nonatomic , copy) NSString              * refundRecordAudit;

/**
 被拒次数  2次不能再退款
 */
@property (nonatomic, assign) NSInteger  refundCount;
@property (nonatomic , assign) NSInteger              createDate;
@property (nonatomic , copy) NSString              * expectDrawTime;
@property (nonatomic , assign) NSInteger              drawDate;
@property (nonatomic , strong) NSArray <NSString *>              * drawNumber;
@property (nonatomic, strong) NSArray <XKWelfareGoodsTransportInfoItem *>  *logisticsInfos;
@property (nonatomic , strong) XKWelfareOrderDetailItem              * drawRate;
@property (nonatomic , strong) NSArray <XKWelfareOrderNumberItem *>              * lotteryNumbers;
@property (nonatomic , copy) NSString              * drawType;
@property (nonatomic , assign) NSInteger              endDate;
@property (nonatomic , copy) NSString              * goodsAttr;
@property (nonatomic , copy) NSString              * logisticsNo;
@property (nonatomic , copy) NSString              * logisticsName;
@property (nonatomic,  copy) NSString             * showSkuName;
@property (nonatomic,  copy) NSString             * price;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * goodsPic;
@property (nonatomic , copy) NSString              * mainUrl;
@property (nonatomic , copy) NSString              * invoiceDetail;
@property (nonatomic , copy) NSString              * invoiceHead;
@property (nonatomic , copy) NSString              * invoiceId;
@property (nonatomic , copy) NSString              * invoiceType;
@property (nonatomic , copy) NSString              * lottery;
@property (nonatomic , assign) NSInteger              factDrawDate;
@property (nonatomic , assign) long              lotteryTime;
@property (nonatomic , assign) NSInteger              myStake;
@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , copy) NSString              * recevicingType;
@property (nonatomic , copy) NSString              * sellerId;
@property (nonatomic , copy) NSString              * sellerName;
@property (nonatomic , assign) NSInteger              sequenceId;
@property (nonatomic , copy) NSString              * shippingName;
@property (nonatomic , copy) NSString              * shippingNum;
@property (nonatomic , assign) NSInteger              surplusStake;
@property (nonatomic , assign) NSInteger              univalence;
@property (nonatomic , copy) NSString              * userAddress;
@property (nonatomic , copy) NSString              * userAddressId;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * userPhone;
@property (nonatomic , assign) NSInteger              maxStake;
@property (nonatomic , assign) NSInteger              joinCount;

@property (nonatomic , strong) NSArray <XKWelfareFinishDetailDataItem *>              * data;
@property (nonatomic , assign) BOOL              empty;
@property (nonatomic , assign) NSInteger              total;

+ (void)requestWelfareOrderDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

//已完成订单详情
+ (void)requestWelfareOrderFinishDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

//确认收货
+ (void)requestWelfareOrderSureAcceptWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

//确认分享
+ (void)requestWelfareOrderSureShareWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

//报损详情分享
+ (void)requestWelfareOrderChangeDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
@end
