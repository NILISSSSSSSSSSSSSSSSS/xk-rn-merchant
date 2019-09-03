//
//  XKMyProductionPreviewModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKMyProductionPreviewModel : NSObject
// 图片地址
@property (nonatomic, copy) NSString *imgUrl;
// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
// 是否播放
@property (nonatomic, assign) BOOL isPlaying;
// 播放器图层
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, copy) void(^playFinishedBlock)(void);

- (instancetype)initWitImgUrl:(NSString *) imgUrl videoUrl:(NSString *) videoUrl;



@end

NS_ASSUME_NONNULL_END
