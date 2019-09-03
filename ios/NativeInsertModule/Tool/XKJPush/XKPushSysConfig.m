//
//  XKPushSysConfig.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKPushSysConfig.h"
#import <AudioToolbox/AudioToolbox.h>
@interface XKPushSysConfig ()

@end

@implementation XKPushSysConfig

/**
 只震动不发声
 */
+ (void)makeShakeNotVoice {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动
}

/**
 只发声不震动（必须得是自定义的声音，经过测试系统的声音好像都带振动）
 */
+ (void)makeVoiceNotShake {
    //获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tim.caf" ofType:@""];
    //定义一个带振动的SystemSoundID
    SystemSoundID soundID = 1000;
    //判断路径是否存在
    if (path) {
        //创建一个音频文件的播放系统声音服务器
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundID);
        //判断是否有错误
        if (error != kAudioServicesNoError) {
            NSLog(@"%d",(int)error);
        }
    }
    //只播放声音，没振动
    AudioServicesPlaySystemSound(soundID);
}



/**
 既发声也震动
 */
+ (void)makeVoiceAndShake {
    [XKPushSysConfig makeVoiceNotShake];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动
}


+ (void)pushSysConfig {
    //只震动，不发声
    if ([[XKUserInfo currentUser].isShake isEqualToString:@"YES"] && [[XKUserInfo currentUser].isVoice isEqualToString:@"NO"]) {
        [XKPushSysConfig makeShakeNotVoice];
    }//只发声，不振动
    else if ([[XKUserInfo currentUser].isShake isEqualToString:@"NO"] && [[XKUserInfo currentUser].isVoice isEqualToString:@"YES"]){
        [XKPushSysConfig makeVoiceNotShake];
    }//即发声，也振动
    else if ([[XKUserInfo currentUser].isShake isEqualToString:@"YES"] && [[XKUserInfo currentUser].isVoice isEqualToString:@"YES"]){
        [XKPushSysConfig makeVoiceAndShake];
    }//即不发声，也不振动
    else if ([[XKUserInfo currentUser].isShake isEqualToString:@"NO"] && [[XKUserInfo currentUser].isVoice isEqualToString:@"NO"]){
    }
}
@end
