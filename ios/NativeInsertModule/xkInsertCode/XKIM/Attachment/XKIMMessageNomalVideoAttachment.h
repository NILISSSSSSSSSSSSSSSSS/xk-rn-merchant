//
//  XKIMMessageNomalVideoAttachment.h
//  XKSquare
//
//  Created by william on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageBaseAttachment.h"

@interface XKIMMessageNomalVideoAttachment : XKIMMessageBaseAttachment

// 视频持续时间ms
@property (nonatomic, assign) NSInteger videoTime;
// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
// 首帧图地址
@property (nonatomic, copy) NSString *videoIcon;
// 视频宽
@property (nonatomic, copy) NSString *videoWidth;
// 视频高
@property (nonatomic, copy) NSString *videoHeight;


@end
