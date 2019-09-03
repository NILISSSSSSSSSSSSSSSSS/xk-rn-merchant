//
//  XKMallGoodsDetailViewModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallGoodsDetailViewModel.h"
@implementation XKMallGoodsDetailSkuAttrValuesItem
@end

@implementation XKMallGoodsDetailAttrValuesItem
@end

@implementation XKMallGoodsDetailAttrListItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attrValues" : [XKMallGoodsDetailAttrValuesItem class],
             };
}
@end
@implementation XKMallGoodsDetailSkuAttr
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attrList" : [XKMallGoodsDetailAttrListItem class],
             };
}
@end
@implementation XKMallGoodsDetailViewModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"skuAttrValue" : [XKMallGoodsDetailSkuAttrValuesItem class],
             };
}

+ (void)requestCollectionGoodsWithParmDic:(NSDictionary *)parmDic  success:(void(^)(id data))success failed:(void(^)(NSString *failedReason))failed {
    
    [HTTPClient postEncryptRequestWithURLString:GetGoodsDetailCollectionUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestCancelCollectionGoodsWithParmDic:(NSDictionary *)parmDic  success:(void(^)(id data))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient postEncryptRequestWithURLString:GetGoodsDetailCancelCollectionUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success(responseObject);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}

+ (void)requestGoodsSKUinfoWithParmDic:(NSDictionary *)parmDic  success:(void(^)(XKMallGoodsDetailViewModel *model))success failed:(void(^)(NSString *failedReason))failed {
    [HTTPClient postEncryptRequestWithURLString:GetMallGoodsDetailSKUinfoUrl timeoutInterval:20.f parameters:parmDic success:^(id responseObject) {
        [XKHudView hideAllHud];
        success([XKMallGoodsDetailViewModel yy_modelWithJSON:responseObject]);
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideAllHud];
        failed(error.message);
    }];
}
@end
