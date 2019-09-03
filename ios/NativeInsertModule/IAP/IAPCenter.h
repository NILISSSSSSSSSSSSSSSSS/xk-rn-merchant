//
//  ApplePurchaseCenter.h
//  HFTPayCenter
//
//  Created by Jamesholy on 2018/4/19.
//  Copyright © 2018年 xk. All rights reserved.
//
// 苹果内购工具类

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AppleProductSuccessCacheModel.h"


static NSString *IAPValidationResultNoti = @"IAPValidationResultNoti";


typedef void(^ValidationResult)(NSString *err, AppleProductSuccessCacheModel *info);

@interface IAPCenter : NSObject

+ (instancetype)shareCenter;

/**重新上传apple内购支付成功却服务器上传失败的的信息*/
- (void)applePayRetryUploadResultToMyServer;

/**
 内购支付 默认一个数量（网络加载框由内部控制）
 @param productId 内购商品id
 @param orderId 。。
 @param tradeId 。。
 @param success 成功回调 注意：此处只是将苹果支付结果给自己服务器成功的回调，如果支付结果验证成功需要等待服务器推送，这个回调后还需做等待结果验证界面。IAPCenter+XK 中封装了此逻辑
 @param failWithoutPurchase 用户没有向苹果支付前提下的失败回调
 @param failWithPurchase 用户支付了后请求我们服务器失败的回调 这种情况要重试。
 */

- (void)payWithProductId:(NSString *)productId orderId:(NSString *)orderId tradeId:(NSString *)tradeId success:(void(^)(AppleProductSuccessCacheModel *info))success failWithoutPurchase:(void(^)(NSString *err))failWithoutPurchase failWithPurchase:(void(^)(NSString *err))failWithPurchase ;

/**接收服务器的验证的推送结果 在相应的回调里必须调用 否则无法回调下方的验证结果*/
- (void)handleRemoteNotification:(id)notification;

/**等待服务器的支付验证结果 回调由于推送失败可能不会执行*/
- (void)observeValidationResult:(ValidationResult)result;

@end
