//
//  XKSysDetailMessageModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSysDetailMessageModel.h"
@implementation XKSysDetailMessageExtras

@end

@implementation XKSysDetailMessageModelDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end


@implementation XKSysDetailMessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKSysDetailMessageModelDataItem class]};
}
@end
