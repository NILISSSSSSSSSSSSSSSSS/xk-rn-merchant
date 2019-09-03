//
//  XKVideoCommentModel.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoCommentModel.h"

@implementation XKVideoCommentUserModel

@end

@implementation XKVideoReplyModel

@end

@implementation XKVideoCommentModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"previousReply": [XKVideoReplyModel class]};
}

- (NSMutableArray<XKVideoReplyModel *> *)allReplys {
    if (!_allReplys) {
        _allReplys = [NSMutableArray array];
    }
    return _allReplys;
}

@end
