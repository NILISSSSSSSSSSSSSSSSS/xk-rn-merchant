//
//  XKIMMessageCustomerSerQuestionAttachment.h
//  XKSquare
//
//  Created by xudehuai on 2019/1/8.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"
#import <NIMKit.h>
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKIMMessageCustomerSerQuestionAttachment : XKIMMessageBaseAttachment <NIMCustomAttachment>

// 标记该消息是否为系统代发
@property (nonatomic, copy) NSString *question;


@end

NS_ASSUME_NONNULL_END
