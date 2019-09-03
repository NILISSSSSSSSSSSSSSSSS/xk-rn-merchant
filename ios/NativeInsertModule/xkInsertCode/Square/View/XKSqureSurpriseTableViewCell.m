//
//  XKSqureSurpriseTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureSurpriseTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
//#import "XKAutoVerticalScrollBar.h"


@interface XKSqureSurpriseTableViewCell ()


//@property (nonatomic, strong) XKAutoVerticalScrollBar *labelView;


@property (nonatomic, strong) UIView                  *otherSurpriseView;
@property (nonatomic, strong) UIImageView             *otherSurpriseImgView;
@property (nonatomic, strong) UILabel                 *otherSurpriseLable;

@property (nonatomic, strong) UIView                  *mySurpriseView;
@property (nonatomic, strong) UIImageView             *mySurpriseImgView;
@property (nonatomic, strong) UIButton                *mySurpriseBtn;

@property (nonatomic, strong) UIView                  *recommendSurpriseView;
@property (nonatomic, strong) UIImageView             *recommendSurpriseImgView;
@property (nonatomic, strong) UIView                  *recommendSurpriseVideoView;
@property (nonatomic, strong) UILabel                 *recommendSurpriseLable;

@property (nonatomic, strong) UIButton                *personalTailorBtn;

@property (nonatomic, strong) AVPlayer                *avPlayer;
@property (nonatomic, strong) NSTimer                 *timer;



@end

@implementation XKSqureSurpriseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
        [self addNotifications];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.otherSurpriseView];
    [self.otherSurpriseView addSubview:self.otherSurpriseImgView];
    [self.otherSurpriseView addSubview:self.otherSurpriseLable];

    [self.contentView addSubview:self.mySurpriseView];
    [self.mySurpriseView addSubview:self.mySurpriseImgView];
    [self.mySurpriseView addSubview:self.mySurpriseBtn];
    
    [self.contentView addSubview:self.recommendSurpriseView];
    [self.recommendSurpriseView addSubview:self.recommendSurpriseImgView];
    [self.recommendSurpriseView addSubview:self.recommendSurpriseVideoView];
    [self.recommendSurpriseView addSubview:self.recommendSurpriseLable];
    
    [self.contentView addSubview:self.personalTailorBtn];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.otherSurpriseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.height.equalTo(@(ScreenScale*175));
        make.width.equalTo(@(ScreenScale*200));
    }];
    
    [self.otherSurpriseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.otherSurpriseView);
        make.height.equalTo(@(ScreenScale*135));
    }];
    
    [self.otherSurpriseLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.otherSurpriseView);
        make.height.equalTo(@(ScreenScale*40));
    }];
    
    
    
    
    [self.mySurpriseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.left.equalTo(self.otherSurpriseView.mas_right).offset(5);
        make.height.equalTo(@(ScreenScale*70));
    }];
    
    [self.mySurpriseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mySurpriseView).offset(1);
        make.bottom.equalTo(self.mySurpriseView).offset(-1);
        make.right.equalTo(self.mySurpriseView);
        make.width.equalTo(@25);
    }];
    
    [self.mySurpriseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.mySurpriseView);
        make.right.equalTo(self.mySurpriseBtn.mas_left).offset(1);
    }];
    
    
    
    
    
    [self.recommendSurpriseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mySurpriseView.mas_bottom).offset(5);
        make.left.equalTo(self.otherSurpriseView.mas_right).offset(5);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(100*ScreenScale));
    }];
    
    [self.recommendSurpriseLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.recommendSurpriseView);
        make.height.equalTo(@25);
    }];
    
    [self.recommendSurpriseImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.recommendSurpriseView);
        make.bottom.equalTo(self.recommendSurpriseLable.mas_top);
    }];
    
    
    [self.recommendSurpriseVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.recommendSurpriseView);
        make.bottom.equalTo(self.recommendSurpriseLable.mas_top);
    }];
    
    [self.personalTailorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherSurpriseView.mas_bottom).offset(10);
        make.right.left.equalTo(self.contentView);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(changeItems) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)changeItems {
    static NSInteger index = 0;
    NSArray *arr = @[@{@"image":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg", @"title":@"  中奖1111111111111111\n  信息111111111111111111"},
                     @{@"image":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg", @"title":@"  中奖2222222222222222\n  信息222222222222222222"},
                     @{@"image":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg", @"title":@"  中奖3333333333333333\n  信息333333333333333333333"},
                     @{@"image":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg", @"title":@"  中奖4444444444444444444\n  信息444444444444444444"}];
    
    
    if (index >= 3) {
        index = 0;
    } else {
        index++;
    }

    [self.otherSurpriseImgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"] placeholderImage:kDefaultPlaceHolderImg];
    self.otherSurpriseLable.text = arr[index][@"title"];
}

#pragma mark - Setter

- (UIView *)otherSurpriseView {
    if (!_otherSurpriseView) {
        _otherSurpriseView = [[UIView alloc] init];
        _otherSurpriseView.layer.masksToBounds = YES;
        _otherSurpriseView.layer.cornerRadius = 5;
    }
    return _otherSurpriseView;
}

- (UIImageView *)otherSurpriseImgView {
    
    if (!_otherSurpriseImgView) {
        _otherSurpriseImgView = [[UIImageView alloc] init];
        _otherSurpriseView.contentMode = UIViewContentModeScaleAspectFill;
        [_otherSurpriseImgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538047861638&di=868dd2f924e8f80a811ef302ad7722fd&imgtype=0&src=http%3A%2F%2Fpic33.photophoto.cn%2F20141028%2F0038038006886895_b.jpg"] placeholderImage:kDefaultPlaceHolderImg];
    }
    return _otherSurpriseImgView;
}

- (UILabel *)otherSurpriseLable {
    
    if (!_otherSurpriseLable) {
        _otherSurpriseLable = [[UILabel alloc] init];
        _otherSurpriseLable.numberOfLines = 2;
        _otherSurpriseLable.text = @"  中奖sssssssss\n  信息sssssssssssss";
        _otherSurpriseLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        _otherSurpriseLable.textColor = HEX_RGB(0xEE4A4A);
        _otherSurpriseLable.backgroundColor = HEX_RGB(0xFBAC86);
        [self startTimer];
    }
    return _otherSurpriseLable;
}





- (UIView *)mySurpriseView {
    if (!_mySurpriseView) {
        _mySurpriseView = [[UIView alloc] init];
        _mySurpriseView.layer.masksToBounds = YES;
        _mySurpriseView.layer.cornerRadius = 5;
    }
    return _mySurpriseView;
}


- (UIImageView *)mySurpriseImgView {
    
    if (!_mySurpriseImgView) {
        _mySurpriseImgView = [[UIImageView alloc] init];
//        _mySurpriseImgView.backgroundColor = [UIColor greenColor];
        _mySurpriseImgView.image = [UIImage imageNamed:@"xk_icon_square_noreward"];
    }
    return _mySurpriseImgView;
}


- (UIButton *)mySurpriseBtn {
    
    if (!_mySurpriseBtn) {
        _mySurpriseBtn = [[UIButton alloc] init];
        [_mySurpriseBtn setTitle:@"去\n抽\n奖" forState:UIControlStateNormal];
        _mySurpriseBtn.titleLabel.numberOfLines = 0;
        [_mySurpriseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mySurpriseBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _mySurpriseBtn.backgroundColor = HEX_RGB(0xEE6161);
    }
    return _mySurpriseBtn;
}




- (UIView *)recommendSurpriseView {
    if (!_recommendSurpriseView) {
        _recommendSurpriseView = [[UIView alloc] init];
        _recommendSurpriseView.layer.masksToBounds = YES;
        _recommendSurpriseView.layer.cornerRadius = 5;
    }
    return _recommendSurpriseView;
}

- (UIImageView *)recommendSurpriseImgView {
    
    if (!_recommendSurpriseImgView) {
        _recommendSurpriseImgView = [[UIImageView alloc] init];
//        _recommendSurpriseImgView.backgroundColor = [UIColor greenColor];
    }
    return _recommendSurpriseImgView;
}

- (UIView *)recommendSurpriseVideoView {
    if (!_recommendSurpriseVideoView) {
        _recommendSurpriseVideoView = [[UIView alloc] init];
        _recommendSurpriseVideoView.backgroundColor = [UIColor redColor];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp4"];
//        NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
//        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
//        _avPlayer = [AVPlayer playerWithPlayerItem:item];
//        _avPlayer.volume = 0.0;//声音
//        _avPlayer.rate = 0.67;//播放速度
//        AVPlayerLayer *showVideoLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
//        showVideoLayer.frame = CGRectMake(0, 0, 150*ScreenScale, 75*ScreenScale);
//        showVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        [_recommendSurpriseVideoView.layer addSublayer:showVideoLayer];
//        //    4.播放视频
//        [_avPlayer play];

        //    获得播放结束的状态 -> 通过发送通知的形式 获得 -> AVPlayerItemDidPlayToEndTimeNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }

    return _recommendSurpriseVideoView;
}

- (void)itemDidPlayToEndTime:(NSNotification *)not{
//    NSLog(@"播放结束");
    
    [_avPlayer seekToTime:kCMTimeZero];
    [self avplyerPlay];
}

- (UILabel *)recommendSurpriseLable {
    
    if (!_recommendSurpriseLable) {
        _recommendSurpriseLable = [[UILabel alloc] init];
        _recommendSurpriseLable.numberOfLines = 2;
        _recommendSurpriseLable.text = @"  中奖sssssssss信息sssssssssssss";
        _recommendSurpriseLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _recommendSurpriseLable.textColor = [UIColor whiteColor];
        _recommendSurpriseLable.backgroundColor = HEX_RGB(0x4A90FA);
        
    }
    return _recommendSurpriseLable;
}


- (UIButton *)personalTailorBtn {
    if (!_personalTailorBtn) {
        _personalTailorBtn = [[UIButton alloc] init];
//        [_personalTailorBtn setTitle:@"私人订制 >" forState:UIControlStateNormal];
//        [_personalTailorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _personalTailorBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        _personalTailorBtn.backgroundColor = [UIColor redColor];
        [_personalTailorBtn setBackgroundImage:[UIImage imageNamed:@"xk_icon_square_personTailor"] forState:UIControlStateNormal];
        [_personalTailorBtn addTarget:self action:@selector(personalTailorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personalTailorBtn;
}


#pragma mark - Evevts


- (void)personalTailorBtnClicked:(UIButton *)sender {
    if (self.personalTailorBlock) {
        self.personalTailorBlock(sender);
    }
}

- (void)avplyerPlay {
    [_avPlayer play];
}

- (void)avplyerStop {
     [_avPlayer pause];
}

#pragma mark - NOticficatons

- (void)addNotifications {
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avplyerPlay) name:XKSquareAvPlayerPlayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avplyerStop) name:XKSquareAvPlayerStopNotification object:nil];
     */
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end



