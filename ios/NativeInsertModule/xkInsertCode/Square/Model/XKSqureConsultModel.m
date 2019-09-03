//
//  XKSqureConsultModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureConsultModel.h"

@implementation XKSqureConsultModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[ConsultItemModel class]};
}

@end


@implementation ConsultItemModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id"};
}

@end
