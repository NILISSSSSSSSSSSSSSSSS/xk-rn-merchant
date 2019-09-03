//
//  XKTradingAreaShopInfoModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaShopInfoModel.h"

@implementation XKTradingAreaShopInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coupons":[ATCouponsItem class],
             @"goods":[ATGoodsItem class],
             @"shops":[ATShopsItem class]
             };
}

@end



@implementation ATCouponsItem
@end


@implementation ATShopGoodsItem
@end


@implementation ATGoodsItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopGoods":[ATShopGoodsItem class]
             };
}

@end



@implementation ATMon
@end

@implementation ATTue
@end

@implementation ATWed
@end

@implementation ATThu
@end

@implementation ATFri
@end

@implementation ATSat
@end

@implementation ATSun
@end


@implementation ATBusinessTime
@end


@implementation ATIndustryItem
@end


@implementation ATMShop

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"descriptionStr" : @"description",
             @"mShopId":@"id"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"industry":[ATIndustryItem class]
             };
}

@end


@implementation ATShopsItem
@end



