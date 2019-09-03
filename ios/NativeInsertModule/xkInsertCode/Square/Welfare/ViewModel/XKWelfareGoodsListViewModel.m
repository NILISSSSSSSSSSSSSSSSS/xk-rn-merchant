//
//  XKWelfareGoodsListViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsListViewModel.h"
@implementation WelfareDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end

@implementation XKWelfareGoodsListViewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [WelfareDataItem class],
             };
}

+ (void)requestWelfareGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {

    [HTTPClient getEncryptRequestWithURLString:GetWelfareGoodsListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareGoodsListViewModel *model =  [XKWelfareGoodsListViewModel yy_modelWithJSON:responseObject];
        success(model.data);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestWelfareRecommendGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetWelfareRecommendGoodsListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareGoodsListViewModel *model =  [XKWelfareGoodsListViewModel yy_modelWithJSON:responseObject];
        success(model.data);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestWelfarePlatformGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetWelfarePlatformGoodsListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareGoodsListViewModel *model =  [XKWelfareGoodsListViewModel yy_modelWithJSON:responseObject];
        success(model.data);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestWelfareStoremGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetWelfareRecommendGoodsListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareGoodsListViewModel *model =  [XKWelfareGoodsListViewModel yy_modelWithJSON:responseObject];
        success(model.data);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}
@end
