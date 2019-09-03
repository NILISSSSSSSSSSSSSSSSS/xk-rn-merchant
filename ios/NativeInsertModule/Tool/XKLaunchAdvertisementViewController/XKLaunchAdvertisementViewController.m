//
//  XKLaunchAdvertisementViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLaunchAdvertisementViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import <UIImage+GIF.h>
#import <UIView+WebCache.h>
@interface XKLaunchAdvertisementViewController () <PLPlayerDelegate>

@property (nonatomic, strong) PLPlayer *player;

@property (nonatomic, strong) UIButton *jumpBtn;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, copy) void(^tapBlock)(void);

@end

@implementation XKLaunchAdvertisementViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeViews];
    [self updateViews];
    self.jumpBtn.hidden = YES;
    self.player.launchView.image = IMG_NAME(@"LaunchImage");
//    [self postLaunchAdvertisement];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player stop];
    [self.player.playerView removeFromSuperview];
    self.player.delegate = nil;
    self.player = nil;
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)initializeViews {
    self.player.playerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.player.playerView];
    [self.view addSubview:self.jumpBtn];
}

- (void)updateViews {
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight + 20.0);
        make.trailing.mas_equalTo(-20.0);
        make.width.mas_equalTo(60.0);
        make.height.mas_equalTo(25.0);
    }];
}

#pragma mark - POST

- (void)postLaunchAdvertisement {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:1.5 parameters:para success:^(id responseObject) {
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        }
    } failure:^(XKHttpErrror *error) {
        [self jumpBtnAction:self.jumpBtn];
    }];
}

#pragma mark - public method

- (void)startCountDownWithImg:(UIImage *)img tapBlock:(void (^)(void))tapBlock {
//    必须调用该方法，launchView才显示
    [self.player playWithURL:[NSURL URLWithString:@""] sameSource:YES];
    self.player.launchView.image = img;
    _tapBlock = tapBlock;
    [self startCountDown];
}

- (void)startCountDownWithImgUrl:(NSString *)imgUrl tapBlock:(void (^)(void))tapBlock {
    __weak typeof(self) weakSelf = self;
    //    必须调用该方法，launchView才显示
    [self.player playWithURL:[NSURL URLWithString:@""] sameSource:YES];
    [self.player.launchView sd_internalSetImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil options:0 operationKey:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
        if (image && [image isGIF]) {
            [weakSelf.player.launchView setImage:[UIImage sd_animatedGIFWithData:imageData]];
        } else if(image){
            [weakSelf.player.launchView setImage:image];
        }
    } progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    _tapBlock = tapBlock;
    [self startCountDown];
}

- (void)startCountDownWithVideoUrl:(NSString *)videoUrl tapBlock:(void (^)(void))tapBlock {
    [self.player playWithURL:[NSURL URLWithString:videoUrl] sameSource:YES];
    _tapBlock = tapBlock;
    [self startCountDown];
}

#pragma mark - privite method

- (void)startCountDown {
    self.jumpBtn.hidden = NO;
    __block NSUInteger timeout = 5;
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳过 %tu", timeout] forState:UIControlStateNormal];
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeout <= 0) {
            dispatch_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self jumpBtnAction:self.jumpBtn];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳过 %tu", timeout] forState:UIControlStateNormal];
            });
            timeout -= 1;
        }
    });
    dispatch_resume(self.timer);
}

- (void)jumpBtnAction:(UIButton *) sender {
    [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.finishBlock) {
                self.finishBlock();
            }
        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self jumpBtnAction:self.jumpBtn];
    if (self.tapBlock) {
        self.tapBlock();
    }
}

#pragma mark - PLPlayerDelegate

#pragma mark - getter setter

- (PLPlayer *)player {
    if (!_player) {
        // =================================== 初始化 PLPlayerOption ===================================
        PLPlayerOption *option = [PLPlayerOption defaultOption];
        // 接收/发送数据包超时时间间隔所对应的键值，单位为 s ，默认配置为 10s
        [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        // 一级缓存大小，单位为 ms，默认为 2000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
        [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        // 默认二级缓存大小，单位为 ms，默认为 300ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
        [option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        // 是否使用 video toolbox 硬解码
        [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        // 配置 log 级别
        [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
        // 视频预设值播放 URL 格式类型
        PLPlayFormat videoPreferFormat = kPLPLAY_FORMAT_UnKnown;
        [option setOptionValue:@(videoPreferFormat) forKey:PLPlayerOptionKeyVideoPreferFormat];
        
        // =================================== 初始化 PLPlayer ===================================
        _player = [[PLPlayer alloc] initWithURL:nil option:option];
        // 设置代理 (optional)
        _player.delegate = self;
        // 设置视频填充模式
        _player.playerView.contentMode = UIViewContentModeScaleAspectFill;
        // 设置首帧图填充模式
        _player.launchView.contentMode = UIViewContentModeScaleAspectFill;
        // 设置循环播放
        _player.loopPlay = YES;
        // 设置允许缓存
        [_player setBufferingEnabled:YES];
    }
    return _player;
}

- (UIButton *)jumpBtn {
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpBtn.titleLabel.font = XKRegularFont(14.0);
        [_jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _jumpBtn.backgroundColor = HEX_RGBA(0x000000, 0.33);
        _jumpBtn.layer.cornerRadius = 12.0;
        _jumpBtn.layer.masksToBounds = YES;
        _jumpBtn.layer.borderWidth = 1.0;
        _jumpBtn.layer.borderColor = HEX_RGBA(0x000000, 0.33).CGColor;
        [_jumpBtn addTarget:self action:@selector(jumpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpBtn;
}

@end
