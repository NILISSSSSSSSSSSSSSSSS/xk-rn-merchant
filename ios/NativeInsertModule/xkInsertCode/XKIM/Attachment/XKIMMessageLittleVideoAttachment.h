//
//  XKIMMessageLittleVideoAttachment.h
//  XKSquare
//
//  Created by william on 2018/11/8.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

@interface XKIMMessageLittleVideoAttachment : XKIMMessageBaseAttachment

// 视频作者名字
@property (nonatomic, copy) NSString *videoAuthorName;
// 首帧图
@property (nonatomic, copy) NSString *videoIconUrl;
// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
// 作者头像
@property (nonatomic, copy) NSString *videoAuthorAvatarUrl;
// 作者用户ID
@property (nonatomic, copy) NSString *videoAuthorId;
// 视频ID
@property (nonatomic, copy) NSString *videoId;

@end

