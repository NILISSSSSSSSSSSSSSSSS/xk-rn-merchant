//
//  XKSquareBannerModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareBannerModel.h"

@implementation XKSquareBannerModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"bannerId" : @"id"};
}

+ (void)requestBannerListWithBannerType:(BannerType )type TypeSuccess:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed {
    NSString *bannerModule;
    switch (type) {
        case BannerType_Square:{
            bannerModule = @"XKSQUARE";
        }
            break;
        case BannerType_Welfare:{
            bannerModule = @"WELFARE";
        }
            break;
        case BannerType_Mall:{
            bannerModule = @"SELF_SHOP";
        }
            break;
        case BannerType_Area:{
            bannerModule = @"BUSINESS_AREA";
        }
            break;
            
        default:
            break;
    }
    NSDictionary *parameters = @{@"regionCode"   : @"510100",
                                 @"bannerModule" : bannerModule ?:@""
                                 
                                 };
    [HTTPClient postEncryptRequestWithURLString:@"sys/ua/bannerList/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        if (responseObject) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[XKSquareBannerModel class] json:responseObject];
            success(array);
        }
        NSLog(@"%@", responseObject);
    } failure:^(XKHttpErrror *error) {
        failed(error.message);
    }];
}
@end


@implementation BannerTemplateContentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"arr":[ItemModel class]};
}

@end


@implementation ItemModel

@end


