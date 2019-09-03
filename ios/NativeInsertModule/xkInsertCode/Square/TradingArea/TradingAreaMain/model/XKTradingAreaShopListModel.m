//
//  XKTradingAreaShopListModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaShopListModel.h"

@implementation XKTradingAreaShopListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[ShopListItem class]};
}

@end


@implementation ShopListItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id",
             @"descriptionStr":@"description"};
}


@end

@implementation ShopListIndustryItem
@end


@implementation ShopListLocation
@end



