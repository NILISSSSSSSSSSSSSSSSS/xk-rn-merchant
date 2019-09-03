//
//  XKVideoSearchResultModel.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchResultModel.h"

@implementation XKVideoSearchResultModel

- (NSMutableArray<XKVideoSearchUserModel *> *)users {
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

- (NSMutableArray<XKVideoSearchTopicModel *> *)topics {
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (NSMutableArray <XKVideoDisplayVideoListItemModel *> *)videos {
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

@end
