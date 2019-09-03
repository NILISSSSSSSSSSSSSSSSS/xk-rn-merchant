//
//  XKSquareMerchantRecommendModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareMerchantRecommendModel.h"

@implementation XKSquareMerchantRecommendModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[MerchantRecommendItem class]};
}

@end



@implementation MerchantRecommendItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id",
             @"descriptionStr":@"description"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"industry":[IndustryItem class]};
}

@end



@implementation IndustryItem

@end

