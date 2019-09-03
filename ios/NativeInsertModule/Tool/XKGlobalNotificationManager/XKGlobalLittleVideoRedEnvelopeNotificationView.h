//
//  XKGlobalLittleVideoRedEnvelopeNotificationView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGlobalNotificationView.h"

@class XKLittleVideoRedEnvelopeNotificationModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKGlobalLittleVideoRedEnvelopeNotificationView : XKGlobalNotificationView

@property (nonatomic, copy) void(^checkBtnBlock)(void);

- (void)configViewWithLittleVideoRedEnvelope:(XKLittleVideoRedEnvelopeNotificationModel *)littleVideoRedEnvelope;

@end

NS_ASSUME_NONNULL_END
