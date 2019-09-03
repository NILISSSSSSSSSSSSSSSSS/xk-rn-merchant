//
//  XKOrderTransportInfoModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKOrderTransportInfoModel.h"
@implementation XKOrderTransportInfoObj

@end

@implementation XKOrderTransportInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [XKOrderTransportInfoObj class],
             };
}

+ (void)requestTransportInfoWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed {
    [HTTPClient postEncryptRequestWithURLString:GetOrderTransportUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message,error.code);
    }];
}
@end
