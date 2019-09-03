//
//  XKRNMerchantCustomerConsultationModel.h
//  xkMerchant
//
//  Created by xudehuai on 2019/2/12.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKIMMessageBaseAttachment.h"

@interface XKRNMerchantCustomerConsultationMessageModel : NSObject
// 消息类型
@property (nonatomic, assign) NSUInteger msgType;
// 消息发送时间 毫秒
@property (nonatomic, assign) NSUInteger sendTime;
// 消息发送用户ID
@property (nonatomic, copy) NSString *from;
// 用户头像
@property (nonatomic, copy) NSString *avatar;
// 用户昵称
@property (nonatomic, copy) NSString *nickname;
// 消息对象
@property (nonatomic, strong) XKIMMessageBaseAttachment *messageObject;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XKRNMerchantCustomerConsultationModel : NSObject
// 任务ID
@property (nonatomic, copy) NSString *taskId;
// teamID
@property (nonatomic, copy) NSString *tid;
// 用户ID
@property (nonatomic, copy) NSString *userId;
// 用户头像
@property (nonatomic, copy) NSString *avatar;
// 用户昵称
@property (nonatomic, copy) NSString *nickname;
// 最后一条消息
@property (nonatomic, strong) XKRNMerchantCustomerConsultationMessageModel *msg;

@end

NS_ASSUME_NONNULL_END
