//
//  ApplePurchaseViewModel.h
//  HFTPayCenter
//
//  Created by Jamesholy on 2018/4/19.
//  Copyright © 2018年 shenghai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class AppleProductSuccessCacheModel,ApplePurchaseProductInfo;

@interface ApplePurchaseViewModel : NSObject

#pragma mark - 请求服务器存放商品id信息
+ (void)refreshProductsComplete:(void (^)(NSString *error, ApplePurchaseProductInfo *productsInfo))complete;

#pragma mark - 提交单个支付结果给我们服务器 目前是通知服务器支付成功，服务器验证后推送结果回来
+ (void)applePayUploadResult:(AppleProductSuccessCacheModel *)cacheModel toMyServerComplete:(void(^)(NSString *err,id data))complete;

/**得到所有的没有提交成功的支付信息*/
+ (NSArray <AppleProductSuccessCacheModel *>*)getAllNoCommitProductRecord;

/**缓存苹果内购支付成功的产品*/
+ (void)saveSuccessProductInfo:(AppleProductSuccessCacheModel *)productCacheModel;
/**通知我们的服务器后，去除该产品付款记录的缓存*/
+ (void)removeSuccessProductInfo:(AppleProductSuccessCacheModel *)productCacheModel;

@end
