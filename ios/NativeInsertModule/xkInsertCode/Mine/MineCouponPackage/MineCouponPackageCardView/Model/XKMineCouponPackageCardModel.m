//
//  XKMineCouponPackageCardModel.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMineCouponPackageCardModel.h"

@implementation XKMineCouponPackageCardItem

@end

@implementation XKMineCouponPackageCardModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data": [XKMineCouponPackageCardItem class]};
}

@end
