//
//  XKTradingAreaIndustyAllCategaryModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaIndustyAllCategaryModel.h"

@implementation XKTradingAreaIndustyAllCategaryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"oneLevel":[IndustyOneLevelItem class],
             @"twoLevel":[IndustyTwoLevelItem class]
             };
}

@end



@implementation IndustyOneLevelItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id"};
}

@end


@implementation IndustyTwoLevelItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id"};
}

@end

