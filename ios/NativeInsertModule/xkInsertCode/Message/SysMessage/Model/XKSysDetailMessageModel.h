//
//  XKSysDetailMessageModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSysDetailMessageExtras :NSObject

/**
 订单id
 */
@property (nonatomic , copy) NSString              *orderId;

/**
 商品名字
 */
@property (nonatomic , copy) NSString              * goodsName;

/**
 商品id
 */
@property (nonatomic , copy) NSString              * goodsId;

/**
 商品图片
 */
@property (nonatomic , copy) NSString              * goodsPic;

/**
 商品规格
 */
@property (nonatomic , copy) NSString              * goodsSkuCode;

/**
 物流名称
 */
@property (nonatomic , copy) NSString              * logisticsName;

/**
 商品sku值
 */
@property (nonatomic , copy) NSString              * goodsSkuValue;

/**
 物流单号
 */
@property (nonatomic , copy) NSString              * logisticsNo;

/**
 订单状态
 */
@property (nonatomic , copy) NSString              * orderStatus;

/**
 退款订单状态
 */
@property (nonatomic , copy) NSString              * refundStatus;

/**
 退款订单id
 */
@property (nonatomic , copy) NSString              * refundId;

@end

@interface XKSysDetailMessageModelDataItem :NSObject
@property (nonatomic , strong) XKSysDetailMessageExtras     * extras;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , assign) NSInteger              isRead;
@property (nonatomic , copy) NSString              * msgBody;
@property (nonatomic , copy) NSString              * msgCategory;
@property (nonatomic , copy) NSString              * msgCode;
@property (nonatomic , copy) NSString              * msgContent;
@property (nonatomic , copy) NSString              * msgTitle;
@property (nonatomic , assign) NSInteger              msgType;
@property (nonatomic , assign) NSInteger              needImSend;
@property (nonatomic , assign) NSInteger              needJPush;
@property (nonatomic , assign) NSInteger              needSave;
@property (nonatomic , copy) NSString              * platform;
@property (nonatomic , copy) NSString              * pushOS;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) NSArray <NSString *>              * targetUserIds;
@property (nonatomic , copy) NSString              * targetUserType;
@property (nonatomic , copy) NSString              *createdAt;
@property (nonatomic , copy) NSString              *updatedAt;
@end


@interface XKSysDetailMessageModel :NSObject
@property (nonatomic , strong) NSArray <XKSysDetailMessageModelDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;
@end

NS_ASSUME_NONNULL_END
