//
//  XKPushSysConfig.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKPushSysConfig : NSObject
/**
 只发声不震动（必须得是自定义的声音，经过测试系统的声音好像都带振动）
 */
+ (void)makeVoiceNotShake;
/**
 只震动不发声
 */
+ (void)makeShakeNotVoice;
/**
 既发声也震动
 */
+ (void)makeVoiceAndShake;

/**
 设置铃声振动的逻辑处理
 */
+ (void)pushSysConfig;
@end

NS_ASSUME_NONNULL_END
