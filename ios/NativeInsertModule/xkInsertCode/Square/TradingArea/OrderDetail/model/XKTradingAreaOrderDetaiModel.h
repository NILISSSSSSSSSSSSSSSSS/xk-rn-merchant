//
//  XKTradingAreaOrderDetaiModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderItems;
@class PurchasesItem;

@interface XKTradingAreaOrderDetaiModel : NSObject

@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , copy) NSString              * orderStatus;
@property (nonatomic , copy) NSString              * orderType;//主单类型，定金类DEPOSIT(1)，免费类FREE(2)，O元服务类ZERO_ORDER(3)，其他OTHER(4)
@property (nonatomic , copy) NSString              * payStatus;
@property (nonatomic , copy) NSString              * payChannel;
@property (nonatomic , copy) NSString              * payTime;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * sceneStatus;//业务场景
@property (nonatomic , copy) NSString              * shopId;
@property (nonatomic , copy) NSString              * shopName;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * subPhone;
@property (nonatomic , copy) NSString              * refundReason;
@property (nonatomic , copy) NSString              * refunds;//退款方式 服务类 住宿类，CONSUME_BEFORE消费前可退款，RESERVATION_BEFORE预约时间前可退，NOT_REFUNDS不允许退款，RESERVATION_BEFORE_BYTIME预约时间前 n 可退款
@property (nonatomic , copy) NSString              * refundsTime;
@property (nonatomic , copy) NSString              * accountTime;//结算时间
@property (nonatomic , copy) NSString              * bcleGoodsType;//商品种类，1001服务类，1002商品类，1003住宿类，1004外卖类
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * lng;
@property (nonatomic , copy) NSString              * appointRange;//预约时间
@property (nonatomic , copy) NSString              * consumer;//预定人
@property (nonatomic , copy) NSString              * consumerNum;//预定人数
@property (nonatomic , copy) NSString              * consumeCode;//消费码
@property (nonatomic , copy) NSString              * createdAt;//创建时间
@property (nonatomic , copy) NSString              * updatedAt;//更新时间
@property (nonatomic , copy) NSString              * agreeEndDate;//接单截止时间
@property (nonatomic , copy) NSString              * payEndDate;//payEndDate
@property (nonatomic , copy) NSString              * evaluateEndDate;//evaluateEndDate
@property (nonatomic , copy) NSString              * orderCipher;//订单密码
@property (nonatomic , assign) NSInteger            isAgree;//主单是否已接单， 0申请中，1同意，2拒绝
@property (nonatomic , assign) BOOL                 isPurchased;//是否可加购，0否，1是
@property (nonatomic , assign) BOOL                 isSelfLifting;//是否自提，0代表否，1代表是 （外卖类）
@property (nonatomic , strong) NSArray <OrderItems *>  * items;
@property (nonatomic , strong) NSArray <NSString *>    * contactPhones;

//所有服务+所有加购 信息
@property (nonatomic , copy) NSString              * totalOriginalPrice;//总原价
@property (nonatomic , copy) NSString              * totalPlatPrice;//总销售价
@property (nonatomic , copy) NSString              * totalShopPrice;//总商家修改后的价格
@property (nonatomic , copy) NSString              * totalShopVoucherPrice;//商家卷总额
@property (nonatomic , copy) NSString              * totalVoucherPrice;//消费卷总额
@property (nonatomic , copy) NSString              * totalRmbPrice;//实际现金支付总额（支付价)
@property (nonatomic , copy) NSString              * totalDiscountPrice;//总优惠额(使用优惠卷的优惠额)
//所有服务 信息
@property (nonatomic , copy) NSString              *  itemOriginalPrice;//总原价
@property (nonatomic , copy) NSString              *  itemPlatPrice;//总销售价
@property (nonatomic , copy) NSString              *  itemShopPrice;//总商家修改后的价格
@property (nonatomic , copy) NSString              *  itemShopVoucherPrice;//商家卷总额
@property (nonatomic , copy) NSString              *  itemVoucherPrice;//消费卷总额
@property (nonatomic , copy) NSString              *  itemRmbPrice;//实际现金支付总额（支付价）
@property (nonatomic , copy) NSString              *  itemDiscountPrice;//总优惠额(使用优惠卷的优惠额)

@end




@interface OrderItems :NSObject

@property (nonatomic , copy) NSString              * applyRefundTime;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * itemId;
@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , copy) NSString              * refundId;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * seatId;
@property (nonatomic , copy) NSString              * seatName;
@property (nonatomic , copy) NSString              * seatPic;
@property (nonatomic , copy) NSString              * shopId;
@property (nonatomic , copy) NSString              * skuCode;
@property (nonatomic , copy) NSString              * skuName;
@property (nonatomic , copy) NSString              * skuUrl;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * payStatus;
@property (nonatomic , copy) NSString              * originalPrice;//原价
@property (nonatomic , copy) NSString              * platformPrice;//销售价格
@property (nonatomic , copy) NSString              * platformShopPrice;//商家修改后价格
@property (nonatomic , assign) NSInteger             weight;
@property (nonatomic , assign) NSInteger             isAgree;
@property (nonatomic , assign) BOOL                  isSelected;//退款选择时用
@property (nonatomic , strong) NSArray <PurchasesItem *>  * purchases;

//对应服务下所有加购 信息
@property (nonatomic , copy) NSString              * purOriginalPrice;//席位总原价(仅名下加购)
@property (nonatomic , copy) NSString              * purPlatPrice;//席位总销售价(仅名下加购)
@property (nonatomic , copy) NSString              * purShopPrice;//席位总商家价（商家修改后的价格）(仅名下加购)
@property (nonatomic , copy) NSString              * purRmbPayPrice;//席位实际现金支付总额(仅名下加购)
@property (nonatomic , copy) NSString              * purDiscountPrice;//席位总优惠额度(仅名下加购)（已完成前为0）

@end





@interface PurchasesItem :NSObject

@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * goodsSkuCode;
@property (nonatomic , copy) NSString              * goodsSkuName;
@property (nonatomic , copy) NSString              * goodsSkuUrl;
@property (nonatomic , copy) NSString              * itemId;
@property (nonatomic , copy) NSString              * mainStatus;
@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , copy) NSString              * payStatus;
@property (nonatomic , copy) NSString              * purchaseOrderId;
@property (nonatomic , copy) NSString              * refundId;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * originalPrice;//原价
@property (nonatomic , copy) NSString              * platformPrice;//销售价
@property (nonatomic , copy) NSString              * paymentPrice;//支付价
@property (nonatomic , copy) NSString              * platformShopPrice;//商家价
@property (nonatomic , assign) NSInteger             isAgree;
@property (nonatomic , assign) BOOL                  isFree;//是否免费下单
@property (nonatomic , assign) BOOL                  isSelected;//退款选择时用

@end

