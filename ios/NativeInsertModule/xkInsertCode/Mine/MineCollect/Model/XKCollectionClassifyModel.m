//
//  XKCollectionClassifyModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCollectionClassifyModel.h"
@implementation XKCollectionClassifyDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end
@implementation XKCollectionClassifyModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKCollectionClassifyDataItem class]};
}
@end
