//
//  XKStoreActivityListCouponModel.m
//  XKSquare
//
//  Created by hupan on 2018/11/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreActivityListCouponModel.h"

@implementation XKStoreActivityListCouponModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[CouponItemModel class]};
}

@end


@implementation CouponItemModel

@end
