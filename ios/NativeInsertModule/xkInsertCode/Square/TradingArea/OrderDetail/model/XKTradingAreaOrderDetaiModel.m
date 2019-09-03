//
//  XKTradingAreaOrderDetaiModel.m
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderDetaiModel.h"

@implementation XKTradingAreaOrderDetaiModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items":[OrderItems class]};
}

@end


@implementation OrderItems

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"purchases":[PurchasesItem class]};
}

@end



@implementation PurchasesItem


@end


