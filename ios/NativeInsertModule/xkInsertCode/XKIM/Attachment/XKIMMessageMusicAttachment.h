//
//  XKIMMessageMusicAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2019/2/21.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageMusicAttachment : XKIMMessageBaseAttachment
// 图片地址
@property (nonatomic, copy) NSString *voiceIcon;
// 标题
@property (nonatomic, copy) NSString *voiceTitle;
// 音乐地址
@property (nonatomic, copy) NSString *voiceUrl;
// 用户ID
@property (nonatomic, copy) NSString *sendUserId;
// 用户昵称
@property (nonatomic, copy) NSString *sendNickName;

@end

NS_ASSUME_NONNULL_END
