//
//  XKWelfareGoodsDetailViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailViewModel.h"
@implementation XKWelfareGoodsTransportInfoItem
@end
@implementation XKWelfareFinishDetailDataItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"lotteryNumbers" : [XKWelfareOrderNumberItem class],
             };
}
@end
@implementation XKWelfareOrderNumberItem

@end

@implementation XKWelfareOrderDetailItem

@end

@implementation XKWelfareOrderDetailViewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
              @"data" : [XKWelfareFinishDetailDataItem class],
             @"lotteryNumbers" : [XKWelfareOrderNumberItem class],
                @"logisticsInfos" : [XKWelfareGoodsTransportInfoItem class],
             };
}

+ (void)requestWelfareOrderDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetWelfareOrderDetailUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareOrderDetailViewModel *model = [XKWelfareOrderDetailViewModel yy_modelWithJSON:responseObject];
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)requestWelfareOrderFinishDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetWelfareOrderWinDetailUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareOrderDetailViewModel *model = [XKWelfareOrderDetailViewModel yy_modelWithJSON:responseObject];
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)requestWelfareOrderSureAcceptWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetWelfareOrderAcceptUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        XKWelfareOrderDetailViewModel *model = [XKWelfareOrderDetailViewModel yy_modelWithJSON:responseObject];
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)requestWelfareOrderSureShareWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetWelfareOrderShareUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
      
        success(nil);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}

+ (void)requestWelfareOrderChangeDetailWithParamDic:(NSDictionary *)dic Success:(void(^)(XKWelfareOrderDetailViewModel *model))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetWelfareGoodsChangeDetailUrl timeoutInterval:20.f parameters:dic success:^(id responseObject) {
        [XKHudView hideAllHud];
        
        success(nil);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}
@end
