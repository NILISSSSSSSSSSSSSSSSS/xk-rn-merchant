//
//  XKLiveBannerModel.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKLiveBannerModel.h"

@implementation XKLiveBannerModelListItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}
@end


@implementation XKLiveBannerModelBody
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [XKLiveBannerModelListItem class]};
}
@end


@implementation XKLiveBannerModel
@end
