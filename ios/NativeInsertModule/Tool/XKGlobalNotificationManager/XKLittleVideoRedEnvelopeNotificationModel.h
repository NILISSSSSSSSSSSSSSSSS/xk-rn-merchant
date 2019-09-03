//
//  XKLittleVideoRedEnvelopeNotificationModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLittleVideoRedEnvelopeNotificationModel : NSObject

// 红包赠送记录的ID
@property (nonatomic, copy) NSString *idStr;
// 红包的ID
@property (nonatomic, copy) NSString *redEnvelopeId;
// 红包对应的小视频ID
@property (nonatomic, copy) NSString *videoId;
// 红包发送者ID
@property (nonatomic, copy) NSString *senderId;
// 红包发送者名字
@property (nonatomic, copy) NSString *senderName;
// 红包发送者头像
@property (nonatomic, copy) NSString *senderAvatar;

@end

NS_ASSUME_NONNULL_END
