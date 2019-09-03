//
//  XKIMMessageRedEnvelopeTipAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageRedEnvelopeTipAttachment : XKIMMessageBaseAttachment

// 红包ID
@property (nonatomic, copy) NSString *redEnvelopeId;
// 红包发送者
@property (nonatomic, copy) NSString *redEnvelopeSenderId;
// 红包拆开者
@property (nonatomic, copy) NSString *redEnvelopeReceiverId;
// 红包是否领取完
@property (nonatomic, assign) BOOL isLastReceived;

- (NSAttributedString *)tipStr;

@end

NS_ASSUME_NONNULL_END
