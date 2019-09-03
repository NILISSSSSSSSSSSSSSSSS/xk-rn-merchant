//
//  XKSquareFriendsCirclelModel.m
//  XKSquare
//
//  Created by hupan on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareFriendsCirclelModel.h"
#import "XKContactModel.h"
#import "XKContactCacheManager.h"
@implementation XKSquareFriendsCirclelModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list":[FriendsCirclelListItem class]};
}


@end

@interface FriendsCirclelListItem()
@property (nonatomic, strong)  XKContactModel *user;
@end


@implementation FriendsCirclelListItem

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"likes":[FriendsCirclelLikesItem class],
             @"comments":[FriendsCirclelCommentsItem class],
             @"pictureContents":[FriendsCirclelPictureContentsItem class],
             @"videoContents":[FriendsCirclelVideoContentsItem class]
             };
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"did":@[@"id",@"did"]};
}

- (NSString *)nickname {
  if (self.user.isStrange == NO) { // 不是陌生用户 用数据库的
    return self.user.displayName;
  } else {
    if (_nickname.length != 0) { // 是陌生用户 用服务器反的
      return _nickname;
    }
    return self.user.displayName;
  }
}

- (NSString *)avatar {
  if (self.user.isStrange == NO) {
    return self.user.avatar;
  } else {
    if (_avatar.length != 0) {
      return _avatar;
    }
    return self.user.avatar;
  }
}

- (NSString *)content {
  if (_content.length == 0) {
    return @" ";
  }
  return _content;
}


- (BOOL)isStrange {
  return self.user.isStrange;
}


- (NSString *)detailType {
//    if (!_detailType) {
        if (self.pictureContents.count != 0) {
            _detailType = @"picture";
        } else if (self.videoContents.count != 0) {
            _detailType = @"video";
        } else {
            _detailType = @"content";
        }
//    }
    return _detailType;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    if (userId.length != 0) {
        XKContactModel *user = [XKContactCacheManager queryContactWithUserId:userId];
        _user = user;
    }
}

- (void)setComments:(NSArray<FriendsCirclelCommentsItem *> *)comments {
    NSMutableArray *tmpArr = @[].mutableCopy;
    for (FriendsCirclelCommentsItem *item in comments) {
        if (item.userId.length > 0 && item.user) {
            if (item.replyUserId.length > 0 && item.replyUser) {
                [tmpArr addObject:item];
            } else {
                [tmpArr addObject:item];
            }
        }
    }
    _comments = tmpArr;
}

- (NSArray <FriendsCirclelLikesItem *> *)likes {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userId.length > 0"];
    return [_likes filteredArrayUsingPredicate:pred];
}

@end


@implementation FriendsCirclelCommentsItem;

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"commentsItemId" : @"id"};
}


- (void)setUserId:(NSString *)userId {
    _userId = userId;
    if (userId.length != 0) {
        XKContactModel *user = [XKContactCacheManager queryContactWithUserId:userId];
        if (user.isStrange) {
        } else {
            _user = user;
        }
    } else {
        _userId = nil;
    }
}

- (void)setReplyUserId:(NSString *)replyUserId {
    _replyUserId = replyUserId;
    if (_replyUserId.length != 0) {
        XKContactModel *user = [XKContactCacheManager queryContactWithUserId:_replyUserId];
        if (user.isStrange) {
        } else {
            _replyUser = user;
        }
    } else {
        _replyUserId = nil;
    }
}


@end



@implementation FriendsCirclelPictureContentsItem

@end

@implementation FriendsCirclelVideoContentsItem

@end



@implementation FriendsCirclelLikesItem

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"likesItemId" : @"id"};
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    if (userId.length != 0) {
        XKContactModel *user = [XKContactCacheManager queryContactWithUserId:userId];
        if (user.isStrange) {
            _userId = nil;
        } else {
            _user = user;
        }
    } else {
        _userId = nil;
    }
}

@end


