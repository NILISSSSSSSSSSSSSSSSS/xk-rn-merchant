//
//  XKVideoDisplayModel.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoDisplayModel.h"

@implementation XKVideoDisplayTopicModel
@end

@implementation XKVideoDisplayRecomGoodsItemModel
@end

@implementation XKVideoDisplayMusicModel
@end

@implementation XKVideoDisplayLocationModel
@end

@implementation XKVideoDisplayAddsModel
@end

@implementation XKVideoDisplayVideoModel
@end

@implementation XKVideoDisplayUserModel
@end

@implementation XKVideoDisplayVideoListItemModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"recom_goods": [XKVideoDisplayRecomGoodsItemModel class]};
}
@end

@implementation XKVideoDisplayBodyModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"video_list": [XKVideoDisplayVideoListItemModel class]};
}
@end

@implementation XKVideoDisplayModel
@end

