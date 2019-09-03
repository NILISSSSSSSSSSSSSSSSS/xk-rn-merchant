//
//  XKBusinessAreaOrderListModel.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBusinessAreaOrderListModel.h"

@implementation XKBusinessAreaOrderListModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[AreaOrderListModel class]};
}


@end



@implementation AreaOrderListModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goods":[XKOrderDetailGoodsItem class]};
}

@end



@implementation XKOrderDetailGoodsItem


@end
