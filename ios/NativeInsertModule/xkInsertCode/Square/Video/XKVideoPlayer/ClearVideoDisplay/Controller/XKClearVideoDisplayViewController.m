//
//  XKClearVideoDisplayViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKClearVideoDisplayViewController.h"
#import "XKVideoDisplayTransiton.h"
#import "XKPercentDrivenInteractiveTransition.h"

@interface XKClearVideoDisplayViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) XKPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) XKVideoDisplayTransiton *transiton;

@end

@implementation XKClearVideoDisplayViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 不熄屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public method

- (void)Action_displayVideoWithParams:(NSDictionary *)params {
    
    UIViewController *callerViewController = params[@"viewController"];
    NSString *urlString = params[@"urlString"];
    NSString *localFilePath = params[@"localFilePath"];
    UIView *view = params[@"view"];
    
    if (!callerViewController) {
        return;
    }
    
    if (view) {
        self.fromView = view;
        callerViewController.navigationController.delegate = self;
        
        // 初始化手势过渡的代理
        if (!self.interactiveTransition) {
            XKPercentDrivenInteractiveTransition *interactiveTransition = [XKPercentDrivenInteractiveTransition interactiveTransitionWithTransitionType:XKPercentDrivenInteractiveTransitionTypePop GestureDirection:XKPercentDrivenInteractiveTransitionGestureDirectionRight];
            
            [interactiveTransition addPanGestureForViewController:self];
            self.interactiveTransition = interactiveTransition;
        }
    }
    
    NSString *tempUrlString;
    if (urlString && ![urlString isEqualToString:@""]) {
        tempUrlString = urlString;
    }
    if (localFilePath && ![localFilePath isEqualToString:@""]) {
        tempUrlString = localFilePath;
    }
    
    if (tempUrlString && ![tempUrlString isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:tempUrlString];
        [self configPlayerData:url];
    }
    
    self.fromViewController = callerViewController;
    [callerViewController.navigationController pushViewController:self animated:YES];
}

- (UIView *)getTransitonFromView {
    return self.fromView;
}

- (UIView *)getTransitonToView {
    return self.view;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ((fromVC == self.fromViewController && toVC == self) ||
        (toVC == self.fromViewController && fromVC == self)) {
        XKVideoDisplayTransitonType type = operation == UINavigationControllerOperationPush ? XKVideoDisplayTransitonTypePush : XKVideoDisplayTransitonTypePop;
        if (!self.transiton) {
            self.transiton = [XKVideoDisplayTransiton new];
        }
        self.transiton.type = type;
        return self.transiton;
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}

#pragma mark - events

- (void)tapContainerView:(UITapGestureRecognizer *)theTap {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 播放状态监听 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                // 播放失败
                break;
            case AVPlayerItemStatusReadyToPlay:
                // 准备播放
                break;
            case AVPlayerItemStatusUnknown:
                // 未知错误
                break;
            default:
                break;
        }
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //        AVPlayerItem *playerItem = object;
        //        NSArray *array = playerItem.loadedTimeRanges;
        //        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        //        float startSeconds = CMTimeGetSeconds(timeRange.start);
        //        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        //        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

/** 播放完成回调 */
- (void)playVideoFinished:(NSNotification *)notification {
    
    // 循环播放
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

#pragma makr - private method

- (void)configPlayerData:(NSURL *)url {
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // 创建数据源
    AVURLAsset *videoAsset= [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:videoAsset];
    
    // 监控状态属性，获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监控播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    // 创建播放器
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    // 创建播放图层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = [UIScreen mainScreen].bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    
    //开始播放
    [player play];
    
    self.playerItem = playerItem;
    self.player = player;
}

@end
