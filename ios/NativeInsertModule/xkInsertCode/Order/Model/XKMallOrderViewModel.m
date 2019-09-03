//
//  XKMallOrderWaitPayViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderViewModel.h"
#import "XKTimeSeparateHelper.h"
@implementation XKOrderListTransportInfoItem

@end
@implementation MallOrderListObj

@end
@implementation MallOrderListDataItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods"          : [MallOrderListObj class],
             @"logisticsInfos" : [XKOrderListTransportInfoItem class]
             };
}
@end
@implementation XKMallOrderListWaitPayModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [MallOrderListDataItem class],
             };
}

+ (void)requestMallOrderListWithType:(MallOrderType)orderType ParamDic:(NSDictionary *)dic Success:(void(^)(XKMallOrderListWaitPayModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [parmDic setObject:[XKUserInfo getCurrentUserId] forKey:@"userId"]; //[XKUserInfo getCurrentUserId] ?: @"111",
    [parmDic setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"lastUpdateAt"];
//    NSString *path = [self cacheBasePath];
//    path = [path stringByAppendingPathComponent:GetMallOrderListUrl];
    NSString *urlPath;
    
    urlPath = GetMallOrderListUrl;
    switch (orderType) {
        case MOT_PRE_PAY:
            {
            [parmDic setObject:@"PRE_PAY" forKey:@"orderStatus"];
            }
            break;
        case MOT_PRE_SHIP:
            {
            [parmDic setObject:@"PRE_SHIP" forKey:@"orderStatus"];
            }
            break;
        case MOT_PRE_RECEVICE:
            {
            [parmDic setObject:@"PRE_RECEVICE" forKey:@"orderStatus"];
            }
            break;
        case MOT_PRE_EVALUATE:
            {
            [parmDic setObject:@"PRE_EVALUATE" forKey:@"orderStatus"];
            }
            break;
        case MOT_COMPLETELY:
            {
            [parmDic setObject:@"COMPLETELY" forKey:@"orderStatus"];
            }
            break;
        case MOT_TERMINATE:
            {
            [parmDic setObject:@"TERMINATE" forKey:@"orderStatus"];
            }
            break;
        case MOT_SALED_SERVICE:
            {
                urlPath = GetMallOrderAfterSaleListUrl;
            }
            break;
            
        default:
            break;
    }
    

    [HTTPClient postEncryptRequestWithURLString:urlPath timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKMallOrderListWaitPayModel *model = [XKMallOrderListWaitPayModel yy_modelWithJSON:responseObject];
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

//创建用户保存所有YTKNetwork缓存的文件夹
+ (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];
    
    return path;
}
@end

@implementation XKMallOrderViewModel
+ (void)cancelMallOrderWithOrderId:(NSString *)orderId  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderCancelUrl timeoutInterval:20.f parameters:@{@"orderId" : orderId ?: @""} success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)sureAcceptMallOrderWithOrderId:(NSString *)orderId  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderAcceptlUrl timeoutInterval:20.f parameters:@{@"orderId" : orderId ?: @""} success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)cancelGoodsReturnWithRefundId:(NSString *)refundId  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderCaccelRefundlUrl timeoutInterval:20.f parameters:@{@"refundId" : refundId ?: @""} success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)requestMallRefundReasonSuccess:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderRefundReasonlUrl timeoutInterval:20.f parameters:@{@"xkModule" : @"mall"} success:^(id responseObject) {
        [XKHudView hideAllHud];
        
        success([NSArray yy_modelArrayWithClass:[XKMallOrderViewModel class] json:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)requestMallRefundWithParm:(NSDictionary *)dic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderRefundlUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)payForMallOrderWithParmDic:(NSDictionary *)dic  Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderPaylUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)uploadTransInfoWithParm:(NSDictionary *)dic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderUploadTransInfolUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}
@end
