//
//  IAPCenter+XK.m
//  xkMerchant
//
//  Created by Jamesholy on 2019/1/16.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "IAPCenter+XK.h"
#import "IAPResultVerificationController.h"

@implementation IAPCenter (XK)

- (void)xk_PayWithProductId:(NSString *)productId orderId:(NSString *)orderId tradeId:(NSString *)tradeId validateResult:(void(^)(NSInteger status, AppleProductSuccessCacheModel *info))success failWithoutPurchase:(void(^)(NSString *err))failWithoutPurchase failWithPurchase:(void(^)(NSString *err))failWithPurchase {
  [self payWithProductId:productId orderId:orderId tradeId:tradeId success:^(AppleProductSuccessCacheModel *info) {
    IAPResultVerificationController *vc = [[IAPResultVerificationController alloc] init];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    vc.payInfo = info;
    [vc setResult:^(NSInteger status, AppleProductSuccessCacheModel *info) {
      if (success) {
        success(status,info);
      }
    }];
  } failWithoutPurchase:^(NSString *err) {
    if (failWithoutPurchase) {
      failWithoutPurchase(err);
    }
  } failWithPurchase:^(NSString *err) {
    if (failWithPurchase) {
      failWithPurchase(err);
    }
  }];
}

@end
