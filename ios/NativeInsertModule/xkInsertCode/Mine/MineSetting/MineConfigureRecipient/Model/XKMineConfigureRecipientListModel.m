//
//  XKMineConfigureRecipientListModel.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientListModel.h"

@implementation XKMineConfigureRecipientItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID": @"id"};
}

@end

@implementation XKMineConfigureRecipientListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKMineConfigureRecipientItem class]};
}

@end
