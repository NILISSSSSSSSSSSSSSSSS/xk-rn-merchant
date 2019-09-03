//
//  XKCityListNetworkMethod.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityListNetworkMethod.h"

@implementation XKCityListNetworkMethod

+ (void)getCityAndDistrictListParameters:(NSDictionary *)parameters Block:(void (^)(id, BOOL isSuccess))block {
    [XKCityListNetworkMethod commonMethodWithParameters:parameters URLString:GetCityAndDistrictListUrl Block:block];
}

+ (void)getDistrictListParameters:(NSDictionary *)parameters Block:(void (^)(id,BOOL isSuccess))block {
    [XKCityListNetworkMethod commonMethodWithParameters:parameters URLString:GetDistrictListUrl Block:block];
}

+ (void)getHotListParameters:(NSDictionary *)parameters Block:(void (^)(id, BOOL))block {
    [XKCityListNetworkMethod commonMethodWithParameters:parameters URLString:GetHotListUrl Block:block];
}

+ (void)getCityCacheListParameters:(NSDictionary *)parameters Block:(void (^)(id, BOOL))block {
    [XKCityListNetworkMethod commonMethodWithParameters:parameters URLString:GetCityCacheListUrl Block:block];
}

+ (void)getProvinceCacheListParameters:(NSDictionary *)parameters Block:(void (^)(id, BOOL))block {
    [XKCityListNetworkMethod commonMethodWithParameters:parameters URLString:GetProvinceCacheListUrl Block:block];
}

+ (void)getDistrictCacheListParameters:(NSDictionary *)parameters Block:(void (^)(id, BOOL))block {
    [XKCityListNetworkMethod commonMethodWithParameters:parameters URLString:GetDistrictCacheListUrl Block:block];
}
+ (void)commonMethodWithParameters:(NSDictionary *)parameters URLString:(NSString*)urlString Block:(void (^)(id, BOOL))block {
    [HTTPClient postEncryptRequestWithURLString:urlString timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
//        NSLog(@"urlString:%@%@, \n 参数：%@",BaseUrl,urlString,parameters);
        if (block) {
//            NSLog(@"%@",responseObject);
            block(responseObject,YES);
        }
    } failure:^(XKHttpErrror *error) {
        if (block) {
            block(error.message,NO);
//            NSLog(@"%@",error.message);
        }
    }];
}
@end
