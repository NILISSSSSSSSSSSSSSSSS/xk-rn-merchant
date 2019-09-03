//
//  XKIMMessageNomalAudioContentView.m
//  XKSquare
//
//  Created by william on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMMessageNomalAudioContentView.h"
#import <UIView+NIM.h>
#import <NIMMessageModel.h>
#import <UIImage+NIMKit.h>
#import <NIMKitAudioCenter.h>
#import <NIMKit.h>
#import "XKIMMessageAudioAttachment.h"
#import "STKAudioPlayer.h"
#import "XKAudioMessageManager.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"

#import "XKP2PChatViewController.h"
#import "XKSecretChatViewController.h"

@interface XKIMMessageNomalAudioContentView()<NIMMediaManagerDelegate>

@property (nonatomic,strong) UIImageView *voiceImageView;

@property (nonatomic,strong) UILabel *durationLabel;

@property (nonatomic,strong) UIView *backCornerView;

@property (nonatomic,strong) UIView *backWhiteView;

@property (nonatomic,strong) UIView *isReadedView;

@end

@implementation XKIMMessageNomalAudioContentView


- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.bubbleImageView.hidden = YES;
        self.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self addVoiceView];
        // 添加音频结束播放监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xkAudioStopPlay) name:XKIMStopPlayAudioNotification object:nil];
        // 添加红外感应状态改变监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[XKAudioMessageManager sharedHttpClient] stop];
}

#pragma mark - Events

// 处理监听触发事件
- (void)sensorStateChange:(NSNotification *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES) {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)setPlaying:(BOOL)isPlaying {
    if (isPlaying) {
        [self.voiceImageView startAnimating];
    }else{
        [self.voiceImageView stopAnimating];
    }
}

- (void)addVoiceView {
    _backWhiteView = [[UIView alloc]init];
    _backWhiteView.backgroundColor = [UIColor whiteColor];
    _backWhiteView.userInteractionEnabled = NO;
    [self addSubview:_backWhiteView];
    
    UIImage * image = [UIImage nim_imageInKit:@"icon_receiver_voice_playing.png"];
    _voiceImageView = [[UIImageView alloc] initWithImage:image];
    
    [self addSubview:_voiceImageView];
    
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _durationLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_durationLabel];
    
    _isReadedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    _isReadedView.backgroundColor = UIColorFromRGB(0xee6161);
    _isReadedView.xk_openClip = YES;
    _isReadedView.xk_radius = 5;
    _isReadedView.xk_clipType = XKCornerClipTypeAllCorners;
    [self addSubview:_isReadedView];
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageAudioAttachment *attachment = object.attachment;
    self.durationLabel.text = [NSString stringWithFormat:@"%tu\"",(attachment.voiceTime + 500) / 1000 < 1 ? 1 : (attachment.voiceTime + 500) / 1000];//四舍五入
        
    self.durationLabel.font      = XKRegularFont(12);
    self.durationLabel.textColor = UIColorFromRGB(0x999999);
    
    [self.durationLabel sizeToFit];
    
    if (!self.model.message.isOutgoingMsg) {
        self.isReadedView.hidden = data.message.isPlayed;
        NSArray * animateNames = @[@"icon_receiver_voice_playing_001.png",@"icon_receiver_voice_playing_002.png",@"icon_receiver_voice_playing_003.png"];
        NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
        for (NSString * animateName in animateNames) {
            UIImage * animateImage = [UIImage nim_imageInKit:animateName];
            [animationImages addObject:animateImage];
        }
        _voiceImageView.animationImages = animationImages;
        _voiceImageView.animationDuration = 1.0;
        _voiceImageView.image = [UIImage nim_imageInKit:@"icon_receiver_voice_playing.png"];

    }else{
        NSArray * animateNames = @[@"icon_sender_voice_playing_001.png",@"icon_sender_voice_playing_002.png",@"icon_sender_voice_playing_003.png"];
        NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
        for (NSString * animateName in animateNames) {
            UIImage * animateImage = [UIImage imageNamed:animateName];
            [animationImages addObject:animateImage];
        }
        _voiceImageView.animationImages = animationImages;
        _voiceImageView.animationDuration = 1.0;
        _voiceImageView.image = [UIImage imageNamed:@"icon_sender_voice_playing.png"];
        self.isReadedView.hidden = YES;
    }
  
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    
    if (self.model.message.isOutgoingMsg) {
        self.voiceImageView.nim_right = self.nim_width - contentInsets.right;
        _durationLabel.nim_left = contentInsets.left;
        _backWhiteView.frame = CGRectMake(20, 0, self.nim_width -20, self.nim_height);
        _voiceImageView.nim_right = _backWhiteView.nim_right - 10;
        _backWhiteView.xk_openClip = YES;
        _backWhiteView.xk_radius = 8;
        _backWhiteView.xk_clipType = XKCornerClipTypeAllCorners;
    } else
    {
        self.voiceImageView.nim_left = contentInsets.left;
        _durationLabel.nim_right = self.nim_width - contentInsets.right;
        _backWhiteView.frame = CGRectMake(0, 0, self.nim_width - 20, self.nim_height);
        _voiceImageView.nim_left = _backWhiteView.nim_left + 10;
        _isReadedView.nim_left = _backWhiteView.nim_right + 5;
        _backWhiteView.xk_openClip = YES;
        _backWhiteView.xk_radius = 8;
        _backWhiteView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    _voiceImageView.nim_centerY = self.nim_height * .5f;
    _durationLabel.nim_bottom = _backWhiteView.nim_bottom - 2;

    [self handleFireView];
}

- (void)onTouchUpInside:(id)sender {
  NIMCustomObject *object = self.model.message.messageObject;
  XKIMMessageAudioAttachment *attachment = object.attachment;
  if ([[XKAudioMessageManager sharedHttpClient].currentUrl isEqualToString:attachment.voiceUrl]) {
    [[XKAudioMessageManager sharedHttpClient] stop];
  } else {
    [[XKAudioMessageManager sharedHttpClient] stop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self XKAudioBeginPlay];
      // 扬声器播放时，开启红外感应功能
      // 建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
      [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
      [[XKAudioMessageManager sharedHttpClient] playWithUrlString:attachment.voiceUrl];
      // 刷新controller标题上的耳朵图片状态
      if ([[self getCurrentUIVC] isKindOfClass:[XKP2PChatViewController class]]) {
        XKP2PChatViewController *vc = (XKP2PChatViewController *)[self getCurrentUIVC];
        [vc refreshEarImgViewStatus];
      } else if ([[self getCurrentUIVC] isKindOfClass:[XKSecretChatViewController class]]) {
        XKSecretChatViewController *vc = (XKSecretChatViewController *)[self getCurrentUIVC];
        [vc refreshEarImgViewStatus];
      }
    });
  }
}

- (void)delayMethod {
    [self XKAudioBeginPlay];
}

- (void)XKAudioBeginPlay {
    [_voiceImageView startAnimating];
    if (!self.model.message.isOutgoingMsg) {
        self.model.message.isPlayed = YES;
        self.isReadedView.hidden = self.model.message.isPlayed;
    }
    
}

- (void)xkAudioStopPlay {
    // 关闭红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    // 将音频播放模式修改回扬声器模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_voiceImageView stopAnimating];
}

@end
