//
//  XKIMMessageFirendCardAttachment.h
//  XKSquare
//
//  Created by william on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

@interface XKIMMessageFirendCardAttachment : XKIMMessageBaseAttachment

// 头像地址
@property (nonatomic,copy) NSString *businessUserAvatarUrl;
// 昵称
@property (nonatomic,copy) NSString *businessUserNickname;
// 用户ID
@property (nonatomic,copy) NSString *businessUserId;
// 名片中用户的 UID
@property (nonatomic,copy) NSString *businessUserUid;

@end
