//
//  XKTradingShopListModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKTradingShopListModel.h"

@implementation XKTradingShopListIndustryItem
@end


@implementation XKTradingShopListLocation
@end


@implementation XKTradingShopListDataItem
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"shopId" : @"id",
             @"des" : @"description"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"industry":[XKTradingShopListIndustryItem class]};
}
@end


@implementation XKTradingShopListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[XKTradingShopListDataItem class]};
}

@end
