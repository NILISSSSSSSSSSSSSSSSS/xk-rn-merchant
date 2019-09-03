//
//  XKMineCouponPackageCouponModel.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineCouponPackageCouponModel.h"

@implementation XKMineCouponPackageCouponItem

@end

@implementation XKMineCouponPackageCouponModelDataItem
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"coupons": [XKMineCouponPackageCouponItem class]};
}
@end

@implementation XKMineCouponPackageCouponModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data": [XKMineCouponPackageCouponModelDataItem class]};
}
@end
