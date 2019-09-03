//
//  XKGlobalNotificationManager.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XKLittleVideoRedEnvelopeNotificationModel;
@class XKLittleVideoGiftNotificationModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKGlobalNotificationManager : NSObject

+ (instancetype)sharedManager;

/**
 添加小视频红包全局弹窗

 @param littleVideoRedEnvelope 小视频红包
 @param checkBlock 点击查看回调
 */
- (void)addLittleVideoRedEnvelopeNotificationView:(nullable XKLittleVideoRedEnvelopeNotificationModel *)littleVideoRedEnvelope checkBlock:(nullable void(^)(void)) checkBlock;

/**
 添加小视频礼物全局弹窗

 @param littleVideoGift 小视频礼物
 @param checkBlock 点击查看回调
 */
- (void)addLittleVideoGiftNotificationView:(nullable XKLittleVideoGiftNotificationModel *)littleVideoGift checkBlock:(nullable void(^)(void)) checkBlock;

@end

NS_ASSUME_NONNULL_END
