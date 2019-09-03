//
//  XKMyProductionModel.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMyProductionModel.h"

@implementation XKMyProductionTopicModel
@end

@implementation XKMyProductionMusicModel
@end

@implementation XKMyProductionLocationModel
@end

@implementation XKMyProductionAddsModel
@end

@implementation XKMyProductionVideoModel
@end

@implementation XKMyProductionUserModel
@end

@implementation XKMyProductionVideoListItemModel
@end

@implementation XKMyProductionBodyModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"video_list": [XKMyProductionVideoListItemModel class]};
}

@end

@implementation XKMyProductionModel
@end
