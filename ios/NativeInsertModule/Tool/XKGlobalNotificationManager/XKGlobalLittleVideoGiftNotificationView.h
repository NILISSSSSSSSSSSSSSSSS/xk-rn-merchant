//
//  XKGlobalLittleVideoGiftNotificationView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGlobalNotificationView.h"

@class XKLittleVideoGiftNotificationModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKGlobalLittleVideoGiftNotificationView : XKGlobalNotificationView

@property (nonatomic, copy) void(^checkBtnBlock)(void);

- (void)configViewWithLittleVideoGift:(XKLittleVideoGiftNotificationModel *)littleVideoGift;

@end

NS_ASSUME_NONNULL_END
