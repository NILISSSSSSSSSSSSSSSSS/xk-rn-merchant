//
//  ApplePurchaseViewModel.m
//  HFTPayCenter
//
//  Created by Jamesholy on 2018/4/19.
//  Copyright © 2018年 shenghai. All rights reserved.
//

#import "ApplePurchaseViewModel.h"
#import "AppleProductSuccessCacheModel.h"
#import <MJExtension.h>

NSString *AppleProductSuccessCacheModelKey = @"AppleProductSuccessCacheModelKey";

@implementation ApplePurchaseViewModel

#pragma mark - 请求服务器存放商品id信息
+ (void)refreshProductsComplete:(void (^)(NSString *error, ApplePurchaseProductInfo *productsInfo))complete {
//    NSString *url = [HOUSE_SERVICE_BASE_STR stringByAppendingPathComponent:@""];
//    [[HFTHttpManager managerForAESEncryp] postForJson:url params:nil complete:^(id data, HFTError *error) {
//        if (error) {
//            complete(error.errMsg,nil);
//            return ;
//        }
//        NSDictionary *infoDic = data;
//        if (infoDic.allKeys.count == 0) {
//            NSLog(@"没有配置商品id信息");
//            complete(@"没有配置商品信息",nil);
//        }
//        ApplePurchaseProductInfo *info = [ApplePurchaseProductInfo mj_objectWithKeyValues:infoDic];
//        complete(nil,info);
//    }];
}

#pragma mark - 单个提交单个支付结果给我们服务器 
+ (void)applePayUploadResult:(AppleProductSuccessCacheModel *)cacheModel toMyServerComplete:(void(^)(NSString *err,id data))complete {
    [self saveSuccessProductInfo:cacheModel];
    NSDictionary *params = cacheModel.mj_keyValues;
    [HTTPClient postEncryptRequestWithURLString:@"trade/ua/chargeXkbAppPayClientCallback/1.0"
                                timeoutInterval:20
                                     parameters:params
                                        success:^(id responseObject) {
                                          [self removeSuccessProductInfo:cacheModel];
                                          NSLog(@"上传支付结果成功");
                                          complete(nil,responseObject);
                                        } failure:^(XKHttpErrror *error) {
                                          NSLog(@"上传支付结果失败");
                                          complete(error.message,nil);
                                        }];
}


/**得到所有的没有提交成功的支付信息*/
+ (NSArray<AppleProductSuccessCacheModel *> *)getAllNoCommitProductRecord {
    NSMutableDictionary *cacheDic = [[[NSUserDefaults standardUserDefaults] objectForKey:AppleProductSuccessCacheModelKey] mutableCopy];
    if (!cacheDic) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    [cacheDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [arr addObject:[AppleProductSuccessCacheModel mj_objectWithKeyValues:obj]];
    }];
    return arr.copy;
}

+ (void)saveSuccessProductInfo:(AppleProductSuccessCacheModel *)model {
    @synchronized(self) {
    NSString *json = [model mj_JSONString];
    NSMutableDictionary *cacheDic = [[[NSUserDefaults standardUserDefaults] objectForKey:AppleProductSuccessCacheModelKey] mutableCopy];
    if (!cacheDic) {
        cacheDic = [NSMutableDictionary dictionary];
    }
    [cacheDic setValue:json forKey:model.transactionIdentifier];
    [[NSUserDefaults standardUserDefaults] setObject:cacheDic forKey:AppleProductSuccessCacheModelKey];
    }
}

+ (void)removeSuccessProductInfo:(AppleProductSuccessCacheModel *)productCacheModel {
    @synchronized(self) {
        NSMutableDictionary *cacheDic = [[[NSUserDefaults standardUserDefaults] objectForKey:AppleProductSuccessCacheModelKey] mutableCopy];
        if (!cacheDic) {
            return;
        }
        [cacheDic removeObjectForKey:productCacheModel.transactionIdentifier];
        [[NSUserDefaults standardUserDefaults] setObject:cacheDic forKey:AppleProductSuccessCacheModelKey];
    }
}

@end
