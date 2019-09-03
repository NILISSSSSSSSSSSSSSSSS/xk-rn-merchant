//
//  XKMallOrderDetailViewModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"
@interface XKOrderTransportInfoItem : NSObject
@property (nonatomic , copy) NSString              * location;
@property (nonatomic , copy) NSString              * time;
@end

@interface XKMallOrderDetailAddressItem : BaseModel
@property (nonatomic , copy) NSString              * userAddress;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * userPhone;
@end

@interface XKMallOrderDetailAmountInfoItem : BaseModel
@property (nonatomic , assign) float              discountMoney;
@property (nonatomic , assign) float              goodsMoney;
@property (nonatomic , assign) float              payMoney;
@property (nonatomic , assign) float              postFee;

@end

@interface XKMallOrderDetailGoodsItem : BaseModel
@property (nonatomic , copy) NSString              * goodsAttr;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , assign) NSInteger              goodsNum;
@property (nonatomic , copy) NSString              * goodsPic;
@property (nonatomic , assign) NSInteger              goodsPrice;
@property (nonatomic , copy) NSString              * goodsSkuCode;
@property (nonatomic, copy) NSString               *itemStatus;

/**
 记录索引位置
 */
@property (nonatomic, strong) NSIndexPath  *index;

/**
 记录是否选中
 */
@property (nonatomic, assign) BOOL                    isChose;
@end

@interface XKMallRefundLogListItem :NSObject
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , copy) NSString              * refundInfo;

@end

@interface XKMallRefundEvidenceItem :NSObject
@property (nonatomic , copy) NSString              * refundPic;
@property (nonatomic , copy) NSString              * refundVideo;

@end

@interface XKMallInvoiceInfo : NSObject
@property (nonatomic , copy) NSString              * head;
@property (nonatomic , copy) NSString              * invoiceContent;
@property (nonatomic , copy) NSString              * invoiceType;
@property (nonatomic , copy) NSString              * electInvoice;
@end

@interface XKMallOrderDetailViewModel : BaseModel
@property (nonatomic , assign) NSInteger              createDate;

/**
 订单状态 active 正常 del 已关闭
 */
@property (nonatomic , copy) NSString              * status;

@property (nonatomic , copy) NSString              * discountId;
@property (nonatomic , strong) XKMallOrderDetailAddressItem              * addressInfo;
@property (nonatomic , strong) XKMallOrderDetailAmountInfoItem              * amountInfo;
@property (nonatomic , strong) XKMallInvoiceInfo              * invoiceInfo;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , strong) NSArray <XKMallOrderDetailGoodsItem *>              * goodsInfo;
@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , copy) NSString              * orderStatus;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , assign) NSInteger              ifDiscount;

@property (nonatomic , copy) NSString              * logisticsNo;
@property (nonatomic , copy) NSString              * logisticsName;
@property (nonatomic , copy) NSString              * shippingTime;
@property (nonatomic , copy) NSString              * payChannel;
@property (nonatomic , assign) NSInteger              payTime;
@property (nonatomic , assign) NSInteger              receivceDate;
@property (nonatomic , copy) NSString              * sellerId;
@property (nonatomic , copy) NSString              * sellerName;
@property (nonatomic , assign) NSInteger              shippingDate;
//退款详情
@property (nonatomic , assign) NSInteger              refundAmount;
@property (nonatomic , assign) NSInteger              refundAutoAcceptTime;
@property (nonatomic , assign) NSInteger              refundId;
@property (nonatomic , strong) NSArray <XKMallRefundLogListItem *>              * refundLogList;
@property (nonatomic , copy) NSString              * refundReason;
@property (nonatomic , copy) NSString              * refundStatus;
@property (nonatomic , assign) NSInteger              refundTime;
@property (nonatomic , copy) NSString              * refundType;
@property (nonatomic , copy) NSString              *refundMessage;
@property (nonatomic , copy) NSString              *refundAddress;
@property (nonatomic , copy) NSString              *refundPhone;
@property (nonatomic , copy) NSString              *refundReceiver;
@property (nonatomic , strong) NSArray <XKMallRefundEvidenceItem *>              * refundEvidence;
@property (nonatomic , strong) NSArray <XKOrderTransportInfoItem *>              * logisticsInfos;


+ (void)requestMallOrderDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKMallOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;

+ (void)requestMallAfterSaleOrderDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKMallOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
@end
