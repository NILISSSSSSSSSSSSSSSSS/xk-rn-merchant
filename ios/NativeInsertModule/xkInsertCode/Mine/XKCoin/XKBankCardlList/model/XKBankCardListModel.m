//
//  XKBankCardListModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBankCardListModel.h"

@implementation XKBankCardListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[XKBankCardModel class]};
}

@end


@implementation XKBankCardModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"cardId" : @"id"};
}
@end
