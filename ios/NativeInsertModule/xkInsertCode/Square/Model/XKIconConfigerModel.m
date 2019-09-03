//
//  XKIconConfigerModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIconConfigerModel.h"

@implementation XKIconConfigerModel
+ (void)requestNewMallIconListSuccess:(void(^)(NSArray *arr))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetMallIconListUrl timeoutInterval:20.f parameters:nil success:^(id responseObject) {
        [XKHudView hideAllHud];
        NSArray *iconArr = [NSArray yy_modelArrayWithClass:[XKIconConfigerModel class] json:responseObject];
        success(iconArr);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}
@end
