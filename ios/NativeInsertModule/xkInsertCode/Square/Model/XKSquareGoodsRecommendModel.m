//
//  XKSquareGoodsRecommendModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareGoodsRecommendModel.h"

@implementation XKSquareGoodsRecommendModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[GoodsItem class]};
}

@end



@implementation GoodsItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"goodsId" : @"id"};
}

@end
