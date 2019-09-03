//
//  XKIMMessageShareLittleVideoAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageShareLittleVideoAttachment : XKIMMessageBaseAttachment

// 视频Id
@property (nonatomic, copy) NSString *videoId;
// 视频封面
@property (nonatomic, copy) NSString *videoIconUrl;
// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
// 作者头像
@property (nonatomic, copy) NSString *videoAuthorAvatarUrl;
// 作者名字
@property (nonatomic, copy) NSString *videoAuthorName;
// 视频描述
@property (nonatomic, copy) NSString *videoDescription;
// 来源
@property (nonatomic, copy) NSString *messageSourceName;
@end

NS_ASSUME_NONNULL_END
