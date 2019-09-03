//
//  XKMallBuyCarViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallBuyCarViewModel.h"
#import "XKMallOrderViewModel.h"

@implementation XKMallBuyCarItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}
@end
@implementation XKMallBuyCarViewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [XKMallBuyCarItem class]
             };
}

+ (void)requestMallBuyCarListWithParam:(NSDictionary *)dic success:(void(^)(XKMallBuyCarViewModel *model))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallBuyCarListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success([XKMallBuyCarViewModel yy_modelWithJSON:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

#pragma mark - 批量删除

+ (void)deleteMallBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed {
    NSMutableArray *idsArr = [NSMutableArray array];
    for(XKMallBuyCarItem *model in arr) {
        [idsArr addObject:model.ID];
    };
    NSDictionary *dic = @{
                          @"ids":idsArr
                          };
    [HTTPClient postEncryptRequestWithURLString:GetMallBuyCarDeleteUrl timeoutInterval:20 parameters:dic success:^(id responseObject) {
        // 成功了就本地移移除数据 请求会导致本地数据被覆盖
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        failed(error.message);
    }];
}
//收藏
+ (void)collectMallBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed {
    NSMutableArray *idsArr = [NSMutableArray array];
    for(XKMallBuyCarItem *model in arr) {
        [idsArr addObject:model.ID];
    };
    NSDictionary *dic = @{
                          @"ids":idsArr
                          };
    [HTTPClient postEncryptRequestWithURLString:GetMallBuyCarCollectUrl timeoutInterval:20 parameters:dic success:^(id responseObject) {
        
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        failed(error.message);
    }];
}

//数目修改
+ (void)changeMallBuyCarListNumberWithAllArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed {
    NSMutableArray *idsArr = [NSMutableArray array];
    for(XKMallBuyCarItem *model in arr) {
        NSDictionary *dic = @{
                              @"quantity" : @(model.quantity),
                              @"id"  : model.ID
                              };
        [idsArr addObject:dic];
    };
    NSDictionary *dic = @{
                          @"cart":idsArr
                          };
    [HTTPClient postEncryptRequestWithURLString:GetWelfareBuyCarChangeNumbernUrl timeoutInterval:20 parameters:dic success:^(id responseObject) {
        
        //success(responseObject);
    } failure:^(XKHttpErrror *error) {
        //  failed(error.message);
    }];
}

+ (void)requestMallBuyCarTicketWithParam:(NSDictionary *)dic success:(void(^)(NSArray *arr))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallBuyCarTicketListUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success([XKMallBuyCarViewModel yy_modelWithJSON:responseObject].data);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)drawMallBuyCarTicketWithParam:(NSDictionary *)dic success:(void(^)(id respons))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallBuyCarDrawTicketUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)countMallBuyCarFeeWithParam:(NSDictionary *)dic success:(void(^)(XKMallBuyCarViewModel *model))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallBuyCarFeeUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
         success([XKMallBuyCarViewModel yy_modelWithJSON:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestMallBuyCarOrderTicketWithParam:(NSDictionary *)dic success:(void(^)(NSArray *arr))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallBuyCarOrderTicketUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
       success([NSArray yy_modelArrayWithClass:[XKMallBuyCarItem class] json:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)orderMallBuyWithParam:(NSDictionary *)dic success:(void(^)(XKTradingAreaPrePayModel *model))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetOrderMallBuyCarUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success([XKTradingAreaPrePayModel yy_modelWithJSON:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}
@end
