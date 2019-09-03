//
//  XKSquareSearchSynthesisListModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSquareSearchSynthesisListModel.h"

@implementation XKSquareSearchSynthesisListCategoriesItem
@end


@implementation XKSquareSearchSynthesisListDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end


@implementation XKSquareSearchSynthesisListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[XKSquareSearchSynthesisListDataItem class]};
}
@end
