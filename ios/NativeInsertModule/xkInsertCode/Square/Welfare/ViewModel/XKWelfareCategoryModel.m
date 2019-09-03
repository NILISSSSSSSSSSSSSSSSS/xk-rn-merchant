//
//  XKWelfareCategoryModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareCategoryModel.h"
@implementation WelfareIconItem

@end
@implementation XKWelfareCategoryModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"notFixed" : [WelfareIconItem class],
             @"fixed" : [WelfareIconItem class]
             };
}
+ (void)requestWelfareCategotyListSuccess:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetWelfareCategoryListUrl timeoutInterval:20.f parameters:nil success:^(id responseObject) {
        [XKHudView hideAllHud];
        success([NSArray yy_modelArrayWithClass:[XKWelfareCategoryModel class] json:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestNewWelfareIconListSuccess:(void(^)(XKWelfareCategoryModel *model))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient getEncryptRequestWithURLString:GetWelfareIconListUrl timeoutInterval:20.f parameters:nil success:^(id responseObject) {
        [XKHudView hideAllHud];
        NSArray *iconArr = [NSArray yy_modelArrayWithClass:[WelfareIconItem class] json:responseObject];
        NSMutableArray *fixedArr =  [NSMutableArray array];
        NSMutableArray *notFixedArr =  [NSMutableArray array];
//        for (WelfareIconItem *item in iconArr) {
//            if (item.moveEnable) {
//                [notFixedArr addObject:item];
//            } else {
//                [fixedArr addObject:item];
//            }
//        }
        if (iconArr.count > 3) {
            for (NSInteger i = 0; i < 3; i ++) {
                [fixedArr addObject:iconArr[i]];
            };
        } else {
            [fixedArr addObjectsFromArray:iconArr];
        }
        XKWelfareCategoryModel *model =  [XKWelfareCategoryModel new];
        model.fixed = fixedArr.copy;
        model.notFixed = notFixedArr.copy;
        success(model);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}
@end
