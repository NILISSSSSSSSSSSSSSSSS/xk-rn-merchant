//
//  XKTradingAreaCommentListModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaCommentListModel.h"

@implementation XKTradingAreaCommentListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data":[CommentListItem class]};
}

@end


@implementation CommentListItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"itemId" : @"id",
             @"shopReplier" : @[@"shopReplier" ,@"shop"]
             };
}



@end

@implementation ShopReplier


@end

@implementation Goods

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"goodsId" : @"id"};
}

@end

@implementation Commenter

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"commenterId" : @"id"};
}

@end
