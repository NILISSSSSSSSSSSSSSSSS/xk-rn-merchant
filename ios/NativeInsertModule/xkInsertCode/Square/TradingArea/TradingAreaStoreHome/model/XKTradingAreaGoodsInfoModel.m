
//
//  XKTradingAreaGoodsInfoModel.m
//  XKSquare
//
//  Created by hupan on 2018/11/2.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaGoodsInfoModel.h"

@implementation XKTradingAreaGoodsInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsSkuVOList":[GoodsSkuVOListItem class]};
}

@end


@implementation GoodsAttrValuesItem
@end


@implementation GoodsAttrListItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attrValues":[GoodsAttrValuesItem class]};
}


@end


@implementation GoodsSkuAttrsVO

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attrList":[GoodsAttrListItem class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id"};
}

@end


@implementation GoodsSkuVOListItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id"};
}

@end

@implementation GoodsModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id"};
}

@end



@implementation GoodsCategory


@end

