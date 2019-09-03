//
//  XKGoodsShareModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGoodsShareModel.h"
@implementation XKGoodsShareValuesItem

@end
@implementation XKGoodsShareAttrListItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"values" : [XKGoodsShareValuesItem class],
             };
}
@end
@implementation XKGoodsShareGoodsAttrs
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attrList" : [XKGoodsShareAttrListItem class],
             };
}
@end
@implementation XKGoodsShareCategories

@end
@implementation XKGoodsShareDefaultSku

@end
@implementation XKGoodsShareBase
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"showPicUrl" : [NSString class],
             };
}
@end
@implementation XKGoodsShareParam

@end
@implementation XKGoodsShareModel

@end
