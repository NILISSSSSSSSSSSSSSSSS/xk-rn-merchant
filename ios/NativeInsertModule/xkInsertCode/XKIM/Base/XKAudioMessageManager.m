//
//  XKAudioMessageManager.m
//  XKSquare
//
//  Created by william on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAudioMessageManager.h"
#import "STKAudioPlayer.h"

@interface XKAudioMessageManager() <STKAudioPlayerDelegate>

@property (nonatomic,strong) STKAudioPlayer *audioPlayer;

@end

@implementation XKAudioMessageManager

+ (XKAudioMessageManager *)sharedHttpClient {
    
    static XKAudioMessageManager *_sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager initPlayer];
    });
    return _sharedManager;
}

- (void)initPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc]init];
        _audioPlayer.delegate = self;
    }
}


- (void)playWithUrlString:(NSString *)urlString {
  [_audioPlayer stop];
  _currentUrl = urlString;
  
  NSArray *array = [urlString componentsSeparatedByString:@"com/"]; //从字符A中分隔成2个元素的数组
  NSString *audioName = array[1];
  NSString *fileGroupName = @"IMAudio";
  NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileGroupName]; // 路径
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { // 文件夹不存在
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    if (!bo) {
      NSLog(@"%@文件夹创建失败",path);
    }
  }
  NSString *localPath = [path stringByAppendingPathComponent:audioName];
  NSData *Data = [NSData dataWithContentsOfFile:localPath];
  
  if (Data) {
    [self.audioPlayer play:[NSURL fileURLWithPath:localPath].absoluteString];
  }
  else{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
      return [NSURL fileURLWithPath:localPath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
      if (error) {
        [XKHudView showErrorMessage:@"播放异常"];
        return;
      }
      [self.audioPlayer play:[filePath absoluteString]];
    }];
    [downloadTask resume];
  }
}


- (void)stop {
    _currentUrl = nil;
    _isPlaying = NO;
    [_audioPlayer stop];
  
}

#pragma mark - STKAudioPlayerDelegate

- (void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId {
    NSLog(@"开始播放");
    _isPlaying = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:XKIMStartPlayAudioNotification object:nil];
}

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId {
    
}

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    NSLog(@"%ld",(long)state);
}

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    NSLog(@"播放完成");
    _currentUrl = nil;
    _isPlaying = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:XKIMStopPlayAudioNotification object:nil];
}

- (void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    
}

@end
