//
//  XKIMMessageRedEnvelopeAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageRedEnvelopeAttachment : XKIMMessageBaseAttachment

// 红包ID
@property (nonatomic, copy) NSString *redEnvelopeId;
// 红包类型 1 晓可币 2 礼物 3 卡券
@property (nonatomic, assign) NSUInteger redEnvelopeType;
// 红包数量（单聊情况下，红包数量为1）
@property (nonatomic, assign) NSUInteger redEnvelopeNumber;
// 红包名称
@property (nonatomic, copy) NSString *redEnvelopeName;
// 红包开始时间
@property (nonatomic, assign) NSUInteger redEnvelopeStartTime;
// 红包结束时间
@property (nonatomic, assign) NSUInteger redEnvelopeEndTime;
// 红包发送者
@property (nonatomic, copy) NSString *redEnvelopeSenderId;

@end

NS_ASSUME_NONNULL_END
