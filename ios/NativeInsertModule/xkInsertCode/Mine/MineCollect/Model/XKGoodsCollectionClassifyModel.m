//
//  XKGoodsCollectionClassifyModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGoodsCollectionClassifyModel.h"
@implementation goodsChildrenItem
@end


@implementation XKGoodsCollectionClassifyChildrenItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [goodsChildrenItem class]};
}
@end


@implementation XKGoodsCollectionClassifyModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [XKGoodsCollectionClassifyChildrenItem class]};
}
@end

