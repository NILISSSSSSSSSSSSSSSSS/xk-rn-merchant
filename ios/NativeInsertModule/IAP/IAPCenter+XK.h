//
//  IAPCenter+XK.h
//  xkMerchant
//
//  Created by Jamesholy on 2019/1/16.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "IAPCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface IAPCenter (XK)

/**
 内购支付 等待服务器推送结果的封装 默认一个数量（网络加载框由内部控制）

 @param productId  内购商品id
 @param orderId 。。
 @param tradeId 。。
 @param success  验证回调, 验证服务器的回调。 0 成功  1 验证失败  2 还没验证就返回了
 @param failWithoutPurchase 用户没有向苹果支付前提下的失败回调
 @param failWithPurchase 用户支付了后请求我们服务器失败的回调 这种情况需要重试机制。
 */
- (void)xk_PayWithProductId:(NSString *)productId orderId:(NSString *)orderId tradeId:(NSString *)tradeId validateResult:(void(^)(NSInteger status, AppleProductSuccessCacheModel *info))success failWithoutPurchase:(void(^)(NSString *err))failWithoutPurchase failWithPurchase:(void(^)(NSString *err))failWithPurchase;

@end

NS_ASSUME_NONNULL_END
