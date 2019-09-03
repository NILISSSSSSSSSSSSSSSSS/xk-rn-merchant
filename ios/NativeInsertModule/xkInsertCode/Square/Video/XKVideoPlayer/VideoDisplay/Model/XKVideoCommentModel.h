//
//  XKVideoCommentModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoCommentUserModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *avatar;

@end


@interface XKVideoReplyModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSUInteger createdAt;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) XKVideoCommentUserModel *creator;

@property (nonatomic, strong) XKVideoCommentUserModel *refCreator;

@end

@interface XKVideoCommentModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *videoId;

@property (nonatomic, strong) XKVideoCommentUserModel *commenter;

@property (nonatomic, assign) BOOL liked;

@property (nonatomic, assign) NSUInteger createdAt;

@property (nonatomic, assign) NSUInteger updatedAt;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) NSUInteger praiseCount;

@property (nonatomic, assign) NSUInteger replyCount;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSMutableArray <XKVideoReplyModel *>*previousReply;

#pragma mark - 以下为根据业务需求自己添加的字段

// 视频作者
@property (nonatomic, copy) NSString *videlAuthorId;
// 评论的回复
@property (nonatomic, strong) NSMutableArray <XKVideoReplyModel *>*allReplys;

@end

NS_ASSUME_NONNULL_END
