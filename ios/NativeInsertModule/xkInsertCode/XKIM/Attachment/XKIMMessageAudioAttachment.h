//
//  XKIMMessageAudioAttachment.h
//  XKSquare
//
//  Created by william on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

@interface XKIMMessageAudioAttachment : XKIMMessageBaseAttachment

// 语音持续时间
@property (nonatomic, assign) NSInteger voiceTime;
// 语音地址
@property (nonatomic, copy) NSString *voiceUrl;
// 语音文件大小
@property (nonatomic, assign) NSInteger voiceSize;

@end
