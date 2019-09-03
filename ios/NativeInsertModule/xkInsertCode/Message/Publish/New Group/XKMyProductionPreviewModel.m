//
//  XKMyProductionPreviewModel.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyProductionPreviewModel.h"

@interface XKMyProductionPreviewModel ()

@end

@implementation XKMyProductionPreviewModel

- (instancetype)initWitImgUrl:(NSString *)imgUrl videoUrl:(NSString *)videoUrl {
    self = [super init];
    if (self) {
        _imgUrl = imgUrl;
        _videoUrl = videoUrl;
        
        // 创建数据源
        AVURLAsset *videoAsset= [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.videoUrl && self.videoUrl.length ? self.videoUrl : @""] options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:videoAsset];
        // 监控播放完毕
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        // 创建播放器
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        // 创建播放图层
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 播放完成回调 */
- (void)playVideoFinished:(NSNotification *)notification {
    // 循环播放
    [self.playerLayer.player seekToTime:CMTimeMake(0, 1)];
    self.isPlaying = NO;
    if (self.playFinishedBlock) {
        self.playFinishedBlock();
    }
}

@end
