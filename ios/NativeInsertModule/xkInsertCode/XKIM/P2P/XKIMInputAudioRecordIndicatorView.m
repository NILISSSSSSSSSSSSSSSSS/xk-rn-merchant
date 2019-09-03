//
//  XKIMInputAudioRecordIndicatorView.m
//  XKSquare
//
//  Created by william on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMInputAudioRecordIndicatorView.h"
#import <UIImage+NIMKit.h>
#import "XKIMRecordingDBView.h"
#define NIMKit_ViewWidth 120
#define NIMKit_ViewHeight 135

#define NIMKit_TimeFontSize 30
#define NIMKit_TipFontSize 15
@interface XKIMInputAudioRecordIndicatorView()<NIMMediaManagerDelegate>
{
    UIImageView *_backgrounView;
    UIImageView *_tipBackgroundView;
}

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *macphoenImageView;

@property (nonatomic, strong) UIView *recordingView;

@property (nonatomic, strong) UIView *cancelRecordingView;

@property (nonatomic, strong) XKIMRecordingDBView *DBView;

@end

@implementation XKIMInputAudioRecordIndicatorView

- (instancetype)init {
    self = [super init];
    if(self) {
        self.frame = CGRectMake(0, 0, NIMKit_ViewWidth, NIMKit_ViewHeight);
        self.backgroundColor = HEX_RGBA(0x000000, 0.5);
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        [self addSubview:self.recordingView];
        [self addSubview:self.cancelRecordingView];
        
        [_recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.and.top.mas_equalTo(self);
        }];
        
        [_cancelRecordingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.and.top.mas_equalTo(self);
        }];
        
        _timeLabel.hidden = YES;
    
        self.phase = AudioRecordPhaseEnd;
        
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
    }
    return self;
}

-(void)dealloc{
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

- (void)setRecordTime:(NSTimeInterval)recordTime {
    NSInteger minutes = (NSInteger)recordTime / 60;
    NSInteger seconds = (NSInteger)recordTime % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02zd", (60 - seconds)];
    if ((60 - seconds) <= 10) {
        _macphoenImageView.hidden = YES;
        _DBView.hidden = YES;
        _timeLabel.hidden = NO;
    }
    else{
        _macphoenImageView.hidden = NO;
        _DBView.hidden = NO;
        _timeLabel.hidden = YES;
    }
}

- (void)setPhase:(NIMAudioRecordPhase)phase {
    if(phase == AudioRecordPhaseStart) {
        [self setRecordTime:0];
        _recordingView.hidden = NO;
        _cancelRecordingView.hidden = YES;
    } else if(phase == AudioRecordPhaseCancelling) {
        _recordingView.hidden = YES;
        _cancelRecordingView.hidden = NO;
    } else if(phase == AudioRecordPhaseRecording){
        _recordingView.hidden = NO;
        _cancelRecordingView.hidden = YES;
    }
    else{
//        _recordingView.hidden = YES;
//        _cancelRecordingView.hidden = YES;
    }
}

- (void)layoutSubviews {
//    CGSize size = [_timeLabel sizeThatFits:CGSizeMake(NIMKit_ViewWidth, MAXFLOAT)];
//    _timeLabel.frame = CGRectMake(0, 36, NIMKit_ViewWidth, size.height);
//    size = [_tipLabel sizeThatFits:CGSizeMake(NIMKit_ViewWidth, MAXFLOAT)];
//    _tipLabel.frame = CGRectMake(0, NIMKit_ViewHeight - 10 - size.height, NIMKit_ViewWidth, size.height);
}


-(UIView *)recordingView{
    if (!_recordingView) {
        XKWeakSelf(weakSelf);
        _recordingView = [[UIView alloc]init];
        _recordingView.layer.masksToBounds = YES;
        UILabel *Label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"手指上滑 取消发送" font:XKMediumFont(12) textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
        Label.adjustsFontSizeToFitWidth = YES;
        [_recordingView addSubview:Label];
        [Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.recordingView.mas_centerX);
            make.bottom.mas_equalTo(weakSelf.recordingView.mas_bottom).offset(-20 * ScreenScale);
            make.height.mas_equalTo(15 * ScreenScale);
        }];
        
        _macphoenImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_sender_voice_macphone"]];
        [_recordingView addSubview:_macphoenImageView];
        [_macphoenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.recordingView.mas_centerX).offset(-2 * ScreenScale);
            make.bottom.mas_equalTo(Label.mas_top).offset(-15 * ScreenScale);
            make.size.mas_equalTo(CGSizeMake(40 * ScreenScale, 58 * ScreenScale));
        }];
        
        _timeLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKMediumFont(48) textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
        [_recordingView addSubview:_timeLabel];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(Label.mas_top).offset(-20 * ScreenScale);
            make.height.mas_equalTo(50 * ScreenScale);
            make.left.and.right.mas_equalTo(weakSelf.recordingView);
        }];
        
        _DBView = [[XKIMRecordingDBView alloc]initWithFrame:CGRectMake(0, 0, 30 * ScreenScale, 50 * ScreenScale)];
        [_recordingView addSubview:_DBView];
        [_DBView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.recordingView.mas_centerX).offset(2 * ScreenScale);
            make.bottom.mas_equalTo(weakSelf.macphoenImageView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(30 * ScreenScale, 50 * ScreenScale));
        }];
    }
    return _recordingView;
}

-(UIView *)cancelRecordingView{
    if (!_cancelRecordingView) {
        XKWeakSelf(weakSelf);
        _cancelRecordingView = [[UIView alloc]init];
        _cancelRecordingView.layer.masksToBounds = YES;
        UILabel *Label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"松开手指 取消发送" font:XKMediumFont(12) textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
        Label.adjustsFontSizeToFitWidth = YES;
        [_cancelRecordingView addSubview:Label];
        [Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.cancelRecordingView.mas_centerX);
            make.bottom.mas_equalTo(weakSelf.cancelRecordingView.mas_bottom).offset(-20 * ScreenScale);
            make.height.mas_equalTo(15 * ScreenScale);
        }];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_sender_voice_cancelSend"]];
        [_cancelRecordingView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.cancelRecordingView.mas_centerX);
            make.bottom.mas_equalTo(Label.mas_top).offset(-15 * ScreenScale);
            make.size.mas_equalTo(CGSizeMake(40 * ScreenScale, 47 * ScreenScale));
        }];
    }
    return _cancelRecordingView;
}

-(void)recordAudioProgress:(NSTimeInterval)currentTime{
    [self audioPowerChange];
}

-(void)audioPowerChange{
    float power = [NIMSDK sharedSDK].mediaManager.recordAveragePower;// 均值
    float powerMax = [NIMSDK sharedSDK].mediaManager.recordPeakPower;// 峰值
    
    // 关键代码
    power = power + 160  - 50;
    
    int dB = 0;
    if (power < 0.f) {
        dB = 0;
    } else if (power < 40.f) {
        dB = (int)(power * 0.875);
    } else if (power < 100.f) {
        dB = (int)(power - 15);
    } else if (power < 110.f) {
        dB = (int)(power * 2.5 - 165);
    } else {
        dB = 110;
    }
    if (_DBView) {
        _DBView.DBValue = dB;
    }
}


@end
