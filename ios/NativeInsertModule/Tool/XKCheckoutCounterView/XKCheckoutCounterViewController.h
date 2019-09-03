//
//  XKCheckoutCounterViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

@class ChannelConfigsItem;
@class XKCheckoutCounterViewController;

typedef NS_ENUM(NSUInteger, XKCheckoutCounterPaymentMethodType) {
    XKCheckoutCounterPaymentMethodTypeAccountBalance,       // 账号
    XKCheckoutCounterPaymentMethodTypeXKCoin,               // 晓可币
    XKCheckoutCounterPaymentMethodTypePhysicalCoupon,       // 实物券
    XKCheckoutCounterPaymentMethodTypeConsumptionCoupon,    // 消费券
    XKCheckoutCounterPaymentMethodTypeShopConsumptionCoupon,// 店铺消费券
    XKCheckoutCounterPaymentMethodTypeAlipay,               // 支付宝支付
    XKCheckoutCounterPaymentMethodTypeWechat,               // 微信支付
    XKCheckoutCounterPaymentMethodTypeTianFuAlipay,         // 天府银行支付宝
    XKCheckoutCounterPaymentMethodTypeTianFuWechat,         // 天府银行微信支付
};

@protocol XKCheckoutCounterViewControllerDelegate <NSObject>

@optional

- (void)handleCheckoutCounterVCResult:(XKCheckoutCounterViewController *)checkoutCounterVC isSucceed:(BOOL)isSucceed paymentMethod:(XKCheckoutCounterPaymentMethodType)paymentMethod;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XKCheckoutCounterViewController : BaseViewController
// 代理
@property (nonatomic, weak) id<XKCheckoutCounterViewControllerDelegate> delegate;
// 下单后返回的body字符串
@property (nonatomic, copy) NSString *orderBody;
// 下单后返回的订单金额 单位为分
@property (nonatomic, assign) CGFloat orderAmount;
// 支付方式数组
@property (nonatomic, copy) NSArray <ChannelConfigsItem *>*paymentMethods;

@end

NS_ASSUME_NONNULL_END
