//
//  XKVideoDisplayTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoDisplayTableViewCell.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "XKVideoDisplayModel.h"
#import "XKMusicAnimationPlayView.h"
#import "UIButton+WebCache.h"
#import "VDFlashLabel.h"
#import "UIButton+WebCache.h"

@interface XKVideoDisplayTableViewCell () <PLPlayerDelegate, CAAnimationDelegate>

@property (nonatomic, strong) XKVideoDisplayVideoListItemModel *model; /** 数据源 */
//@property (nonatomic, strong) NSURL *videoUrl; /** 视频地址 */
@property (nonatomic, assign) BOOL isVideoNeedsToPlay; /** 是否需要播放视频（视图已经完全出现） */
@property (nonatomic, assign) BOOL isEnableToPlay; /** 视频播放器是否可以播放 */

@property (nonatomic, strong) PLPlayer *player; /** 播放器 */
@property (nonatomic, strong) UIImageView *playingView; /** 播放按钮视图 */
@property (nonatomic, strong) UIImageView *heartImageView; /** 点赞动画视图 */
@property (nonatomic, strong) UIImageView *heartBrokenLeftImageView; /** 取消点赞动画左视图 */
@property (nonatomic, strong) UIImageView *heartBrokenRightImageView; /** 取消点赞动画右视图 */
@property (nonatomic, strong) UIView *videoInfoContainerView; /** 视频信息容器视图 */
@property (nonatomic, strong) CALayer *loadingLineLayer; /** 视频加载动画线 */
@property (nonatomic, strong) VDFlashLabel *flashLabel; /** 跑马灯 */
@property (nonatomic, strong) UILabel *videoDescribeLabel; /** 视频描述 */
@property (nonatomic, strong) UIButton *topicButton; /** 话题按钮 */
@property (nonatomic, strong) UILabel *nameLabel; /** 作者名字 */
@property (nonatomic, strong) UIButton *locationButton; /** 位置按钮 */
@property (nonatomic, strong) UILabel *locationLabel; /** 位置标签 */
@property (nonatomic, strong) UIButton *advertisementButton; /** 广告按钮 */
@property (nonatomic, strong) UILabel *advertisementLabel; /** 广告标签 */
@property (nonatomic, strong) XKMusicAnimationPlayView *musicAnimationView; /** 音符动画视图 */
@property (nonatomic, strong) UILabel *shareCountLabel; /** 分享数量 */
@property (nonatomic, strong) UIButton *shareButton; /** 分享按钮 */
@property (nonatomic, strong) UILabel *commentCountLabel; /** 评论数量 */
@property (nonatomic, strong) UIButton *commentButton;; /** 评论按钮 */
@property (nonatomic, strong) UILabel *likeCountLabel; /** 点赞数量 */
@property (nonatomic, strong) UIButton *likeButton; /** 点赞按钮 */
@property (nonatomic, strong) UIButton *headerButton; /** 作者头像按钮 */
@property (nonatomic, strong) UIButton *attentionButton; /** 关注按钮 */
@property (nonatomic, strong) UILabel *attentionLabel; /** 关注标签 */
@property (nonatomic, strong) UIButton *liveButton; /** 直播按钮 */
@property (nonatomic, strong) UIButton *musicRecordButton; /** 唱片按钮 */

@end

@implementation XKVideoDisplayTableViewCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initializePlayer];
        [self initializeVideoInfoViews];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - public method

/**
 * 配置cell
 */
- (void)configTableViewCellWithModel:(XKVideoDisplayVideoListItemModel *)model {
    
    // 配置首帧图
    NSString *firstCoverUrlString = model.video.first_cover;
    if (firstCoverUrlString && ![firstCoverUrlString isEqualToString:@""]) {
        [self.player.launchView sd_setImageWithURL:[NSURL URLWithString:firstCoverUrlString]];
    }
    
    // 配置视频URL
    NSString *videoUrlSting = model.video.video;
    if (videoUrlSting && ![videoUrlSting isEqualToString:@""]) {
        NSURL *videoUrl = [NSURL URLWithString:videoUrlSting];
        [self.player openPlayerWithURL:videoUrl];
    }
    
    // 刷新视频信息相关视图
    [self updateUserInfoViews:model];
}

/**
 * 刷新用户相关控件
 */
- (void)updateUserInfoViews:(XKVideoDisplayVideoListItemModel *)model {
    
    // 数据源
    self.model = model;
    
    // 是否直播中
    BOOL isLiving = model.user.is_live;
    
    if (isLiving) {
        self.liveButton.hidden = NO;
    } else {
        self.liveButton.hidden = YES;
        [self.liveButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
    
    // 广告
    NSArray *recomGoods = model.recom_goods;
    NSString *goodsName;
    if (model.recom_goods.count != 0) {
        XKVideoDisplayRecomGoodsItemModel *model = recomGoods[0];
        if (model.goods_name && ![model.goods_name isEqualToString:@""]) {
            goodsName = model.goods_name;
        }
    }
    //    goodsName = @"秋冬ugg新品上市";
    if (goodsName && ![goodsName isEqualToString:@""]) {
        self.advertisementButton.hidden = NO;
        self.advertisementLabel.text = goodsName;
    } else {
        self.advertisementButton.hidden = YES;
        [self.advertisementButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
    
    // 地址
    //    model.adds = [XKVideoDisplayAddsModel new];
    //    model.adds.add = @"成都高新区";
    if (model.adds && model.adds.add && ![model.adds.add isEqualToString:@""]) {
        self.locationButton.hidden = NO;
        self.locationLabel.text = model.adds.add;
    } else {
        self.locationButton.hidden = YES;
        [self.locationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
    
    // 作者名字
    NSString *nameString = model.user.user_name;
    //    nameString = @"阿信";
    if (nameString && ![nameString isEqualToString:@""]) {
        self.nameLabel.hidden = NO;
        self.nameLabel.text = [NSString stringWithFormat:@"@%@", nameString];
    } else {
        self.nameLabel.hidden = YES;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
    
    // 话题
    NSString *topicName = model.topic.topic_name;
    //    topicName = @"2018高校校草选拔";
    if (topicName && ![topicName isEqualToString:@""]) {
        self.topicButton.hidden = NO;
        [self.topicButton setTitle:[NSString stringWithFormat:@"#%@", topicName] forState:UIControlStateNormal];
    } else {
        self.topicButton.hidden = YES;
        [self.topicButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
    
    // 视频描述
    NSString *describeString = model.video.describe;
    //    describeString = @"仪式感是把本来单调普通的事情，变得不一样，对此怀有敬畏心里。@叉叉又是叉";
    if (describeString && ![describeString isEqualToString:@""]) {
        self.videoDescribeLabel.hidden = NO;
        self.videoDescribeLabel.text = describeString;
    } else {
        self.videoDescribeLabel.hidden = YES;
        [self.videoDescribeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
    }
    
    // 音乐名字
    //    model.music.music_name = @"可爱的人 - 大脸C哩C哩";
    NSString *musicName = model.music.music_name;
    if (musicName && ![musicName isEqualToString:@""]) {
        NSArray *attStrArr = @[[[NSAttributedString alloc] initWithString:musicName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        self.flashLabel.stringArray = attStrArr;
    } else {
        self.flashLabel.stringArray = nil;
    }
    [self.flashLabel reloadData];
    
    // 作者头像
    NSString *userImage = model.user.user_img;
    if (userImage && ![userImage isEqualToString:@""]) {
        [self.headerButton sd_setImageWithURL:[NSURL URLWithString:userImage] forState:UIControlStateNormal];
    } else {
        [self.headerButton setImage:[UIImage imageNamed:@"xk_ic_defult_head"] forState:UIControlStateNormal];
    }
    
    // 是否关注
    if (model.user.is_follow == 0) {
        self.attentionButton.hidden = NO;
        self.attentionLabel.hidden = YES;
    } else {
        self.attentionButton.hidden = YES;
        self.attentionLabel.hidden = NO;
    }
    
    // 点赞图片
    self.likeButton.enabled = YES;
    if (model.video.is_praise) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_video_display_like_highlight"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_video_display_like_normal"] forState:UIControlStateNormal];
    }
    
    // 点赞数
    NSInteger likeCount = model.video.praise_num;
    NSString *likeCountString;
    if (likeCount < 10000) {
        likeCountString = [NSString stringWithFormat:@"%@", @(likeCount)];
    } else if (likeCount >= 10000) {
        CGFloat tempLikeCount = likeCount / 10000.0;
        likeCountString = [NSString stringWithFormat:@"%.1fW", tempLikeCount];
    }
    self.likeCountLabel.text = likeCountString;
    
    // 评论数
    NSInteger commentCount = model.video.com_num;
    NSString *commentCountString;
    if (commentCount < 10000) {
        commentCountString = [NSString stringWithFormat:@"%@", @(commentCount)];
    } else if (commentCount >= 10000) {
        CGFloat tempCommentCount = commentCount / 10000.0;
        commentCountString = [NSString stringWithFormat:@"%.1fW", tempCommentCount];
    }
    self.commentCountLabel.text = commentCountString;
    
    // 分享数
    NSInteger shareCount = model.video.share_num;
    NSString *shareCountString;
    //    shareCount = 341;
    if (shareCount < 10000) {
        shareCountString = [NSString stringWithFormat:@"%@", @(shareCount)];
    } else if (shareCount >= 10000) {
        CGFloat tempShareCount = shareCount / 10000.0;
        shareCountString = [NSString stringWithFormat:@"%.1fW", tempShareCount];
    }
    self.shareCountLabel.text = shareCountString;
    
    // 原创音乐头像
    NSString *musicRecordImageUrlString = model.music.music_img;
    if (musicRecordImageUrlString && ![musicRecordImageUrlString isEqualToString:@""]) {
        [self.musicRecordButton sd_setImageWithURL:[NSURL URLWithString:musicRecordImageUrlString] forState:UIControlStateNormal];
    } else {
        [self.musicRecordButton setImage:[UIImage imageNamed:@"xk_ic_video_display_record"] forState:UIControlStateNormal];
    }
    
    // 隐藏播放中视图
    [self hiddenPlayingView];
}

/**
 * 移除播放控件
 */
- (void)removePlayVideo {
    
    [self.player stop];
    [self.player.playerView removeFromSuperview];
    self.player.delegate = nil;
    self.player = nil;
    [self.musicAnimationView stopAnimation];
    [self.musicRecordButton.layer removeAllAnimations];
    [self.playingView.layer removeAllAnimations];
    [self stopMusicRecordButtonAnimation];
    [self.flashLabel kill];
}

#pragma mark private method

/**
 * 初始化播放器
 */
- (void)initializePlayer {
    
// =================================== 初始化 PLPlayerOption ===================================
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    
    // 接收/发送数据包超时时间间隔所对应的键值，单位为 s ，默认配置为 10s
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    
    // 一级缓存大小，单位为 ms，默认为 2000ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    
    // 默认二级缓存大小，单位为 ms，默认为 300ms，增大该值可以减小播放过程中的卡顿率，但会增大弱网环境的最大累积延迟
    [option setOptionValue:@300 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    
    // 是否使用 video toolbox 硬解码
    [option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
    
    // 配置 log 级别
    [option setOptionValue:@(kPLLogError) forKey:PLPlayerOptionKeyLogLevel];

    // 视频预设值播放 URL 格式类型
    PLPlayFormat videoPreferFormat = kPLPLAY_FORMAT_MP4;
    [option setOptionValue:@(videoPreferFormat) forKey:PLPlayerOptionKeyVideoPreferFormat];
    
// =================================== 初始化 PLPlayer ===================================
    
    self.player = [[PLPlayer alloc] initWithURL:nil option:option];
    
    // 设置代理 (optional)
    self.player.delegate = self;
    
    // 设置视频填充模式
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 设置首帧图填充模式
    self.player.launchView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 设置循环播放
    self.player.loopPlay = YES;
    
    // 设置允许缓存
    self.player.bufferingEnabled = YES;
    
    // 是否开启重连，默认为 NO
    self.player.autoReconnectEnable = YES;
    
    // 获取视频输出视图并添加为到当前 UIView 对象的 Subview
    [self.contentView addSubview:self.player.playerView];
}

/**
 * 初始化用户相关视图
 */
- (void)initializeVideoInfoViews {

// =================================== 视频信息容器视图 ===================================

    UIView *videoInfoContainerView = [UIView new];
    videoInfoContainerView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapContainerView:)];
    [videoInfoContainerView addGestureRecognizer:singleTap];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapContainerView:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [videoInfoContainerView addGestureRecognizer:singleTap];
    [videoInfoContainerView addGestureRecognizer:doubleTap];
    
    [self.contentView addSubview:videoInfoContainerView];
    [videoInfoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.offset(0);
    }];
    self.videoInfoContainerView = videoInfoContainerView;
    
// =================================== 视频信息左侧视图 ===================================

    // 底部音乐图标
    UIImageView *musicImageView = [[UIImageView alloc] init];
    musicImageView.image = [UIImage imageNamed:@"xk_ic_video_display_music_one"];
    musicImageView.contentMode = UIViewContentModeScaleAspectFit;
    [videoInfoContainerView addSubview:musicImageView];
    [musicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.bottom.offset(-(20 + kBottomSafeHeight) * ScreenScale);
        make.width.height.equalTo(@(15));
    }];
    
    // 滚动label
    VDFlashLabel *flashLabel = [VDFlashLabel new];
    flashLabel.scrollDirection = VDFlashLabelScrollDirectionLeft;
    flashLabel.backColor = [UIColor clearColor];
    flashLabel.lineHeight = 18 * ScreenScale;
    flashLabel.userScroolEnabled = NO;
    flashLabel.hspace = 0;
    [videoInfoContainerView addSubview:flashLabel];
    [flashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(musicImageView.mas_right).offset(5);
        make.centerY.equalTo(musicImageView.mas_centerY);
        make.width.equalTo(@(127 * ScreenScale));
        make.height.equalTo(@(18 * ScreenScale));
    }];
    [flashLabel showAndStartTextContentScroll];
    [flashLabel stopAutoScroll];
    self.flashLabel = flashLabel;
    
    // 视频描述Label
    UILabel *videoDescribeLabel = [UILabel new];
    videoDescribeLabel.textColor = HEX_RGBA(0xFFFFFF, 1);
    videoDescribeLabel.font = XKRegularFont(13);
    videoDescribeLabel.numberOfLines = 2;
    [videoInfoContainerView addSubview:videoDescribeLabel];
    [videoDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.bottom.mas_equalTo(musicImageView.mas_top).offset(-9 * ScreenScale);
        make.width.offset(275 * ScreenScale);
    }];
    self.videoDescribeLabel = videoDescribeLabel;

    // 话题button
    UIButton *topicButton = [[UIButton alloc] init];
    [topicButton.titleLabel setFont:XKRegularFont(13)];
    [topicButton setTitleColor:HEX_RGBA(0xFCE76C, 1) forState:UIControlStateNormal];
    [videoInfoContainerView addSubview:topicButton];
    [topicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(videoDescribeLabel.mas_top).offset(-5 * ScreenScale);
        make.left.offset(8);
        make.height.offset(18 * ScreenScale);
    }];
    self.topicButton = topicButton;
    
    // 作者名Label
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = HEX_RGBA(0xffffff, 1);
    nameLabel.font = XKMediumFont(15);
    [videoInfoContainerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.bottom.equalTo(topicButton.mas_top).offset(-10);
        make.width.offset(275 * ScreenScale);
        make.height.offset(21 * ScreenScale);
    }];
    self.nameLabel = nameLabel;
    
    // 位置按钮
    UIButton *locationButton = [UIButton new];
    locationButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    locationButton.xk_openClip = YES;
    locationButton.xk_radius = 6;
    locationButton.xk_clipType = XKCornerClipTypeAllCorners;
    [videoInfoContainerView addSubview:locationButton];
    
    UIImageView *locationImageView = [UIImageView new];
    locationImageView.image = [UIImage imageNamed:@"xk_ic_video_display_location"];
    [locationButton addSubview:locationImageView];

    UILabel *locationLabel = [UILabel new];
    locationLabel.textAlignment = NSTextAlignmentLeft;
    locationLabel.font = XKRegularFont(12);
    locationLabel.textColor = [UIColor whiteColor];
    [locationButton addSubview:locationLabel];
    
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(nameLabel.mas_top).offset(-5 * ScreenScale);
        make.left.offset(8 * ScreenScale);
        make.height.offset(24 * ScreenScale);
        make.right.equalTo(locationLabel.mas_right).offset(6);
    }];
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationButton.mas_left).offset(6);
        make.centerY.equalTo(locationButton.mas_centerY);
        make.width.and.height.equalTo(@(15));
    }];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.mas_right).offset(5);
        make.centerY.equalTo(locationButton.mas_centerY);
    }];
    self.locationButton = locationButton;
    self.locationLabel = locationLabel;
    
    // 广告按钮
    UIButton *advertisementButton = [UIButton new];
    advertisementButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    advertisementButton.xk_openClip = YES;
    advertisementButton.xk_radius = 6;
    advertisementButton.xk_clipType = XKCornerClipTypeAllCorners;
    [advertisementButton addTarget:self action:@selector(clickAdvertisementButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:advertisementButton];
    
    UIImageView *advertisementImageView = [UIImageView new];
    advertisementImageView.image = [UIImage imageNamed:@"xk_ic_video_display_shopping"];
    [advertisementButton addSubview:advertisementImageView];
    
    UILabel *advertisementLabel = [UILabel new];
    advertisementLabel.textAlignment = NSTextAlignmentLeft;
    advertisementLabel.font = XKRegularFont(12);
    advertisementLabel.textColor = [UIColor whiteColor];
    [advertisementButton addSubview:advertisementLabel];
    
    [advertisementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(locationButton.mas_top).offset(-5 * ScreenScale);
        make.left.offset(8);
        make.height.offset(24 * ScreenScale);
        make.right.equalTo(advertisementLabel.mas_right).offset(6);
    }];
    [advertisementImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(advertisementButton.mas_left).offset(6);
        make.centerY.equalTo(advertisementButton.mas_centerY);
        make.width.and.height.equalTo(@(15));
    }];
    [advertisementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(advertisementImageView.mas_right).offset(5);
        make.centerY.equalTo(advertisementButton.mas_centerY);
        make.width.mas_lessThanOrEqualTo(150).priority(1000);
    }];
    self.advertisementButton = advertisementButton;
    self.advertisementLabel = advertisementLabel;
    
// =================================== 视频信息右侧视图 ===================================
    
    // 右侧背景
    UIImageView *rightBgImageView = [UIImageView new];
    rightBgImageView.image = [UIImage imageNamed:@"xk_bg_video_display_right_bottom"];
    rightBgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [videoInfoContainerView addSubview:rightBgImageView];
    [rightBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(116 * ScreenScale);
    }];
    
    // 底部唱片按钮
    UIButton *musicRecordButton = [UIButton new];
    musicRecordButton.layer.cornerRadius = 22 * ScreenScale;
    musicRecordButton.layer.masksToBounds = YES;
    [videoInfoContainerView addSubview:musicRecordButton];
    [musicRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.offset(44 * ScreenScale);
        make.right.offset(-15 * ScreenScale);
        make.bottom.offset(-(20 + kBottomSafeHeight) * ScreenScale);
    }];
    self.musicRecordButton = musicRecordButton;
    
    // 音符动画视图
    XKMusicAnimationPlayView *musicAnimationView = [XKMusicAnimationPlayView new];
    [videoInfoContainerView addSubview:musicAnimationView];
    [musicAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(musicRecordButton.mas_bottom);
        make.right.equalTo(musicRecordButton.mas_right);
        make.width.height.offset(100 * ScreenScale);
    }];
    self.musicAnimationView = musicAnimationView;
    
    // 礼物按钮
    UIButton *giftButton = [UIButton new];
    [giftButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_video_display_gift"] forState:UIControlStateNormal];
    [giftButton addTarget:self action:@selector(clickGiftButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:giftButton];
    [giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(53 * ScreenScale);
        make.height.offset(35 * ScreenScale);
        make.right.offset(-5);
        make.bottom.mas_equalTo(musicRecordButton.mas_top).offset(-22 * ScreenScale);
    }];
    
    // 分享数量
    UILabel *shareCountLabel = [[UILabel alloc] init];
    shareCountLabel.font = XKMediumFont(12);
    shareCountLabel.textColor = HEX_RGBA(0xffffff, 1);
    shareCountLabel.textAlignment = NSTextAlignmentCenter;
    [videoInfoContainerView addSubview:shareCountLabel];
    [shareCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.bottom.mas_equalTo(giftButton.mas_top).offset(-15 * ScreenScale);
        make.height.offset(12 * ScreenScale);
    }];
    self.shareCountLabel = shareCountLabel;
    
    // 分享按钮
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_video_display_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(53 * ScreenScale);
        make.height.offset(37 * ScreenScale);
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.bottom.mas_equalTo(shareCountLabel.mas_top).offset(0);
    }];
    self.shareButton = shareButton;
    
    // 评论数量
    UILabel *commentCountLabel = [UILabel new];
    commentCountLabel.font = XKMediumFont(12);
    commentCountLabel.textColor = HEX_RGBA(0xFFFFFF, 1);
    commentCountLabel.textAlignment = NSTextAlignmentCenter;
    [videoInfoContainerView addSubview:commentCountLabel];
    [commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.bottom.mas_equalTo(shareButton.mas_top).offset(-13.7 * ScreenScale);
        make.height.offset(12 * ScreenScale);
    }];
    self.commentCountLabel = commentCountLabel;
    
    // 评论按钮
    UIButton *commentButton = [[UIButton alloc] init];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_video_display_comment"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(53 * ScreenScale);
        make.height.offset(37 * ScreenScale);
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.bottom.mas_equalTo(commentCountLabel.mas_top).offset(0);
    }];
    self.commentButton = commentButton;
    
    // 点赞数量
    UILabel *likeCountLabel = [UILabel new];
    likeCountLabel.font = XKMediumFont(12);
    likeCountLabel.textColor = HEX_RGBA(0xFFFFFF, 1);
    likeCountLabel.textAlignment = NSTextAlignmentCenter;
    [videoInfoContainerView addSubview:likeCountLabel];
    [likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.bottom.mas_equalTo(commentButton.mas_top).offset(-14.6 * ScreenScale);
        make.height.offset(12 * ScreenScale);
    }];
    self.likeCountLabel = likeCountLabel;
    
    // 点赞按钮
    UIButton *likeButton = [UIButton new];
    [likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_video_display_like"] forState:UIControlStateDisabled];
    [videoInfoContainerView addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(53 * ScreenScale);
        make.height.offset(34 * ScreenScale);
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.bottom.mas_equalTo(likeCountLabel.mas_top).offset(0);
    }];
    likeButton.enabled = NO;
    self.likeButton = likeButton;
    
    // 直播按钮
    UIButton *liveButton = [UIButton new];
    [liveButton setImage:[UIImage imageNamed:@"xk_ic_video_display_living"] forState:UIControlStateNormal];
    [liveButton addTarget:self action:@selector(clickLiveButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:liveButton];
    [liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(likeButton.mas_top).offset(-8 * ScreenScale);
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.height.offset(50 * ScreenScale);
    }];
    self.liveButton = liveButton;
    
    // 旧版【正在直播】
//    UIButton *liveButton = [UIButton new];
//    liveButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
//    [liveButton addTarget:self action:@selector(clickLiveButton:) forControlEvents:UIControlEventTouchUpInside];
//    liveButton.xk_openClip = YES;
//    liveButton.xk_radius = 6;
//    liveButton.xk_clipType = XKCornerClipTypeAllCorners;
//    [videoInfoContainerControl addSubview:liveButton];
//
//    UIImageView *liveImageView = [UIImageView new];
//    liveImageView.image = [UIImage imageNamed:@"xk_ic_video_display_live"];
//    [liveButton addSubview:liveImageView];
//
//    UILabel *liveLabelOne = [UILabel new];
//    liveLabelOne.textAlignment = NSTextAlignmentLeft;
//    liveLabelOne.font = XKRegularFont(12);
//    liveLabelOne.textColor = [UIColor whiteColor];
//    liveLabelOne.text = @"正在直播...";
//    [liveButton addSubview:liveLabelOne];
//
//    UILabel *liveLabelTwo = [UILabel new];
//    liveLabelTwo.textAlignment = NSTextAlignmentLeft;
//    liveLabelTwo.font = XKRegularFont(10);
//    liveLabelTwo.textColor = [UIColor whiteColor];
//    liveLabelTwo.text = @"点击观看";
//    [liveButton addSubview:liveLabelTwo];
//
//    [liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(likeButton.mas_top).offset(-5 * ScreenScale);
//        make.centerX.mas_equalTo(giftButton.mas_centerX);
//        make.height.offset(45 * ScreenScale);
//        make.right.equalTo(liveLabelOne.mas_right).offset(6);
//    }];
//
//    [liveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(liveButton.mas_left).offset(6);
//        make.top.equalTo(liveButton.mas_top).offset(3);
//        make.width.equasourlTo(@(18));
//        make.height.equalTo(@(16));
//    }];
//
//    [liveLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(liveImageView.mas_right).offset(5);
//        make.top.equalTo(liveButton.mas_top).offset(3);
//    }];
//
//    [liveLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(liveImageView.mas_right).offset(5);
//        make.top.equalTo(liveLabelOne.mas_bottom).offset(3);
//    }];
    
    // 头像背景
    UIImageView *headerBgImageView = [[UIImageView alloc] init];
    headerBgImageView.image = [UIImage imageNamed:@"xk_bg_video_display_head"];
    [videoInfoContainerView addSubview:headerBgImageView];
    [headerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(liveButton.mas_top).offset(-8 * ScreenScale);
        make.width.height.offset(53 * ScreenScale);
        make.centerX.mas_equalTo(giftButton.mas_centerX);
    }];
    
    // 头像
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.layer.cornerRadius = 43 * ScreenScale * 0.5;
    headerButton.layer.masksToBounds = YES;
    [headerButton setImage:[UIImage imageNamed:@"xk_ic_defult_head"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:headerButton];
    [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(43 * ScreenScale);
        make.centerX.mas_equalTo(headerBgImageView.mas_centerX).offset(-1 * ScreenScale);
        make.centerY.mas_equalTo(headerBgImageView.mas_centerY).offset(-1 * ScreenScale);
    }];
    self.headerButton = headerButton;
    
    // 关注按钮
    UIButton *attentionButton = [UIButton new];
    [attentionButton setBackgroundImage:[UIImage imageNamed:@"xk_ic_video_display_attention"] forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(clickAttentionButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:attentionButton];
    [attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(28 * ScreenScale);
        make.centerX.mas_equalTo(headerButton.mas_centerX).offset(1.5 * ScreenScale);
        make.centerY.mas_equalTo(headerButton.mas_centerY).offset(21.5 * ScreenScale);
    }];
    self.attentionButton = attentionButton;
    
    // 关注标签
    UILabel *attentionLabel = [UILabel new];
    attentionLabel.backgroundColor = RGB(252, 20, 87);
    attentionLabel.text = @"已关注";
    attentionLabel.font = XKFont(XK_PingFangSC_Regular, 10);
    attentionLabel.layer.masksToBounds = YES;
    attentionLabel.layer.cornerRadius = 3;
    attentionLabel.textColor = [UIColor whiteColor];
    attentionLabel.textAlignment = NSTextAlignmentCenter;
    [videoInfoContainerView addSubview:attentionLabel];
    [attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(36);
        make.height.offset(18);
        make.centerX.mas_equalTo(headerButton.mas_centerX);
        make.top.mas_equalTo(headerButton.mas_bottom).offset(-10 * ScreenScale);
    }];
    self.attentionLabel = attentionLabel;
    
    // 红包按钮
    UIButton *redEnvelopeButton = [UIButton new];
    [redEnvelopeButton setImage:[UIImage imageNamed:@"xk_ic_video_display_red_envelope"] forState:UIControlStateNormal];
    [redEnvelopeButton addTarget:self action:@selector(clickRedEnvelopeButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:redEnvelopeButton];
    [redEnvelopeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(headerBgImageView.mas_top).offset(-50 * ScreenScale);
        make.centerX.mas_equalTo(giftButton.mas_centerX);
        make.width.offset(54);
        make.height.offset(47);
    }];
    
// =================================== 返回按钮 ===================================
    
    UIButton *backButton = [UIButton new];
    [backButton setImage:[UIImage imageNamed:@"xk_navigationBar_global_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [videoInfoContainerView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(kIphoneXNavi(32));
        make.width.equalTo(@(60));
        make.height.equalTo(@(20));
    }];
    
// =================================== 播放按钮 ===================================
    
    UIImageView *playingView = [UIImageView new];
    playingView.hidden = YES;
    [playingView setImage:[UIImage imageNamed:@"xk_ic_video_display_play"]];
    [videoInfoContainerView addSubview:playingView];
    [playingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(60 * ScreenScale);
        make.center.equalTo(self.contentView);
    }];
    self.playingView = playingView;
    
// =================================== 点赞/取消点赞动画视图 ===================================
    
    UIImageView *heartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_ic_video_display_like_highlight"]];
    heartImageView.frame = CGRectMake(0, 0, 53 * ScreenScale, 34 * ScreenScale);
    heartImageView.hidden = YES;
    [videoInfoContainerView addSubview:heartImageView];
    self.heartImageView = heartImageView;
    
    UIImageView *heartBrokenLeftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_ic_video_display_dislike_left"]];
    heartBrokenLeftImageView.frame = CGRectMake(0, 0, 39 * ScreenScale, 51 * ScreenScale);
    heartBrokenLeftImageView.hidden = YES;
    [videoInfoContainerView addSubview:heartBrokenLeftImageView];
    self.heartBrokenLeftImageView = heartBrokenLeftImageView;
    
    UIImageView *heartBrokenRightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_ic_video_display_dislike_right"]];
    heartBrokenRightImageView.frame = CGRectMake(0, 0, 39 * ScreenScale, 51 * ScreenScale);
    heartBrokenRightImageView.hidden = YES;
    [videoInfoContainerView addSubview:heartBrokenRightImageView];
    self.heartBrokenRightImageView = heartBrokenRightImageView;
    
// =================================== 底部加载视图 ===================================
    
    UIView *loadingLineContainerView = [UIView new];
    loadingLineContainerView.backgroundColor = [UIColor clearColor];
    [videoInfoContainerView addSubview:loadingLineContainerView];
    [loadingLineContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(1);
        make.bottom.offset(-(10 + kBottomSafeHeight) * ScreenScale);
    }];
    
    CALayer *loadingLineLayer = [CALayer new];
    loadingLineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [loadingLineContainerView.layer addSublayer:loadingLineLayer];
    loadingLineLayer.frame = CGRectMake(SCREEN_WIDTH / 2, 0, 1, 1);
    self.loadingLineLayer = loadingLineLayer;
    [self starLoadingLineAnimation];
}

/**
 * 隐藏播放中视图
 */
- (void)hiddenPlayingView {
    self.playingView.hidden = YES;
}

/**
 * 标记视频为需要播放
 */
- (void)videoNeedsToPlay:(BOOL)isNeed {
    self.isVideoNeedsToPlay = isNeed;
}

/**
 * 开始播放
 */
- (void)startPlayVideo {
    
    PLPlayerStatus status = self.player.status;
    if (status == PLPlayerStatusOpen) {
        [self.player play];
        [self.musicAnimationView startAnimation];
        [self.flashLabel continueAutoScroll];
        [self startMusicRecordButtonAnimation];
    }
}

/**
 * 暂停播放
 */
- (void)pausePlayVideo {

    PLPlayerStatus status = self.player.status;
    if (status == PLPlayerStatusPlaying || status == PLPlayerStatusCaching) {
        [self showPlayingView];
        [self.player pause];
        [self.musicAnimationView stopAnimation];
        [self.flashLabel stopAutoScroll];
        [self pauseMusicRecordButtonAnimation];
    }
}

/**
 * 继续播放
 */
- (void)resumePlayVideo {

    PLPlayerStatus status = self.player.status;
    if (status == PLPlayerStatusPaused) {
        [self hiddenPlayingView];
        [self.player resume];
        [self.musicAnimationView startAnimation];
        [self.flashLabel continueAutoScroll];
        [self resumeMusicRecordButtonAnimation];
    }
}

/**
 * 停止播放
 */
- (void)stopPlayVideo {

    PLPlayerStatus status = self.player.status;
    if (status == PLPlayerStatusPlaying) {
        [self.player stop];
        [self.musicAnimationView stopAnimation];
        [self.flashLabel stopAutoScroll];
        self.flashLabel.stringArray = nil;
        [self.flashLabel reloadData];
        [self stopMusicRecordButtonAnimation];
        [self stopLoadingLineAnimation];
    }
}

/**
 * 开始唱片旋转
 */
- (void)startMusicRecordButtonAnimation {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotationAnimation.duration = 6.0;
    rotationAnimation.repeatCount = ULLONG_MAX;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.musicRecordButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimationKey"];
}

/**
 * 暂停唱片旋转
 */
- (void)pauseMusicRecordButtonAnimation {
    
    CABasicAnimation *rotationAnimation = (CABasicAnimation * )[self.musicRecordButton.layer animationForKey:@"rotationAnimationKey"];
    if (rotationAnimation) {
        CALayer *layer = self.musicRecordButton.layer;
        CFTimeInterval time = CACurrentMediaTime() - layer.beginTime;
        layer.timeOffset = time;
        layer.speed = 0.0;
    }
}

/**
 * 继续唱片旋转
 */
- (void)resumeMusicRecordButtonAnimation {
    
    CABasicAnimation *rotationAnimation = (CABasicAnimation *)[self.musicRecordButton.layer animationForKey:@"rotationAnimationKey"];
    if (rotationAnimation) {
        CALayer *layer = self.musicRecordButton.layer;
        if (layer.timeOffset != 0) {
            CFTimeInterval pauseTime = layer.timeOffset;
            layer.beginTime = CACurrentMediaTime() - pauseTime;
            layer.timeOffset = 0;
            layer.speed = 1.0;
        }
    }
}

/**
 * 停止唱片旋转
 */
- (void)stopMusicRecordButtonAnimation {
    [self.musicRecordButton.layer removeAllAnimations];
}

/**
 * 开始播放loading动画
 */
- (void)starLoadingLineAnimation {
    
    self.loadingLineLayer.hidden = NO;
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH / 2, 0, 1, 1)];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    boundsAnimation.duration = .5;
    boundsAnimation.removedOnCompletion = NO;
    boundsAnimation.repeatCount = ULLONG_MAX;
    
//    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
//    opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
//    opacityAnimation.duration = .5;
//    opacityAnimation.removedOnCompletion = NO;
//    opacityAnimation.repeatCount = ULLONG_MAX;
    
    [self.loadingLineLayer addAnimation:boundsAnimation forKey:@"loadingLineBoundsAnimation"];
//    [self.loadingLineLayer addAnimation:opacityAnimation forKey:@"loadingLineOpacityAnimation"];
}

/**
 * 暂停播放loading动画
 */
- (void)pauseLoadingLineAnimation {
    
    self.loadingLineLayer.hidden = YES;
    CABasicAnimation *boundsAnimation = (CABasicAnimation * )[self.loadingLineLayer animationForKey:@"loadingLineBoundsAnimation"];
//    CABasicAnimation *opacityAnimation = (CABasicAnimation * )[self.loadingLineLayer animationForKey:@"loadingLineOpacityAnimation"];
    
    if (boundsAnimation) {
        CFTimeInterval time = CACurrentMediaTime() - self.loadingLineLayer.beginTime;
        self.loadingLineLayer.timeOffset = time;
        self.loadingLineLayer.speed = 0.0;
    }
}

/**
 * 继续播放loading动画
 */
- (void)resumeLoadingLineAnimation {
    
    self.loadingLineLayer.hidden = NO;
    CABasicAnimation *boundsAnimation = (CABasicAnimation * )[self.loadingLineLayer animationForKey:@"loadingLineBoundsAnimation"];
//    CABasicAnimation *opacityAnimation = (CABasicAnimation * )[self.loadingLineLayer animationForKey:@"loadingLineOpacityAnimation"];
    
    if (boundsAnimation) {
        if (self.loadingLineLayer.timeOffset != 0) {
            CFTimeInterval pauseTime = self.loadingLineLayer.timeOffset;
            self.loadingLineLayer.beginTime = CACurrentMediaTime() - pauseTime;
            self.loadingLineLayer.timeOffset = 0;
            self.loadingLineLayer.speed = 1.0;
        }
    }
}

/**
 * 停止播放loading动画
 */
- (void)stopLoadingLineAnimation {
    
    self.loadingLineLayer.hidden = NO;
    [self.loadingLineLayer removeAllAnimations];
}

/**
 * 动态展示播放视图
 */
- (void)showPlayingView {
    
    if (!self.playingView.hidden) return;
    self.playingView.hidden = NO;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:2.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = .1;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:.3];
    opacityAnimation.toValue = [NSNumber numberWithFloat:.7];
    opacityAnimation.duration = .1;
    
    [self.playingView.layer addAnimation:scaleAnimation forKey:@"scale"];
    [self.playingView.layer addAnimation:opacityAnimation forKey:@"opacity"];
}

/**
 * 点赞/取消点赞
 */
- (void)showLikeAnimation:(UITapGestureRecognizer *)sender {

    // 获取点击位置
    CGPoint clickPoint = [sender locationInView:self.videoInfoContainerView];
    
    // 点赞动画
    if (self.model.video.is_praise == NO) {
        
        self.heartImageView.center = clickPoint;
        
        // 创建缩放帧动画
        CAKeyframeAnimation *scaleKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        NSValue *stepOneValue = [NSNumber numberWithFloat:2.0];
        NSValue *stepTwoValue = [NSNumber numberWithFloat:1.0];
        NSValue *stepThreeValue = [NSNumber numberWithFloat:3.0];
        scaleKeyframeAnimation.values = @[stepOneValue, stepTwoValue, stepThreeValue];
        scaleKeyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        // 创建透明度帧动画
        CAKeyframeAnimation *opacityKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        NSValue *opacityOneValue = [NSNumber numberWithFloat:.5];
        NSValue *opacityTwoValue = [NSNumber numberWithFloat:1.0];
        NSValue *opacityThreeValue = [NSNumber numberWithFloat:0.1];
        opacityKeyframeAnimation.values = @[opacityOneValue, opacityTwoValue, opacityThreeValue];
        opacityKeyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        // 创建动画组
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.delegate = self;
        animationGroup.animations = @[scaleKeyframeAnimation, opacityKeyframeAnimation];
        animationGroup.duration = .3;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        
        [self.heartImageView.layer addAnimation:animationGroup forKey:@"heartImageViewAnimation"];
        
    // 取消点赞动画
    } else {
        
        self.heartBrokenLeftImageView.center = clickPoint;
        self.heartBrokenRightImageView.center = clickPoint;
        
        // 透明度动画
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @1;
        opacityAnimation.toValue = @0;
        
        // 左侧旋转动画
        CABasicAnimation *rotationAnticlockwiseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnticlockwiseAnimation.fromValue = @0;
        rotationAnticlockwiseAnimation.toValue = [NSNumber numberWithFloat:-M_PI / 4];
        
        // 右侧旋转动画
        CABasicAnimation *rotationClockwiseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationClockwiseAnimation.fromValue = @0;
        rotationClockwiseAnimation.toValue = [NSNumber numberWithFloat:M_PI / 4];
        
        // 左侧动画组
        CAAnimationGroup *rotationAnticlockwiseAnimationGroup = [CAAnimationGroup animation];
        rotationAnticlockwiseAnimationGroup.delegate = self;
        rotationAnticlockwiseAnimationGroup.animations = @[opacityAnimation, rotationAnticlockwiseAnimation];
        rotationAnticlockwiseAnimationGroup.duration = .3;
        rotationAnticlockwiseAnimationGroup.repeatCount = 1;
        rotationAnticlockwiseAnimationGroup.fillMode = kCAFillModeForwards;
        rotationAnticlockwiseAnimationGroup.removedOnCompletion = NO;
        self.heartBrokenLeftImageView.layer.anchorPoint = CGPointMake(1, 1);
        [self.heartBrokenLeftImageView.layer addAnimation:rotationAnticlockwiseAnimationGroup forKey:@"heartBrokenLeftImageViewAnimation"];
        
        // 右侧动画组
        CAAnimationGroup *rotationClockwiseAnimationGroup = [CAAnimationGroup animation];
        rotationClockwiseAnimationGroup.delegate = self;
        rotationClockwiseAnimationGroup.animations = @[opacityAnimation, rotationClockwiseAnimation];
        rotationClockwiseAnimationGroup.duration = .3;
        rotationClockwiseAnimationGroup.repeatCount = 1;
        rotationClockwiseAnimationGroup.fillMode = kCAFillModeForwards;
        rotationClockwiseAnimationGroup.removedOnCompletion = NO;
        self.heartBrokenRightImageView.layer.anchorPoint = CGPointMake(0, 1);
        [self.heartBrokenRightImageView.layer addAnimation:rotationClockwiseAnimationGroup forKey:@"heartBrokenRightImageViewAnimation"];
    }
}

#pragma mark - PLPlayerDelegate

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
    // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
    // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
    // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
    // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    
    // loading视图状态
    if (state == PLPlayerStatusPlaying ||
        state == PLPlayerStatusPaused ||
        state == PLPlayerStatusStopped ||
        state == PLPlayerStatusError) {
        [self pauseLoadingLineAnimation];
    } else {
        [self resumeLoadingLineAnimation];
    }
    
    // 播放准备是否完成
    if (state == PLPlayerStatusOpen || state == PLPlayerStatusPaused) {
        self.isEnableToPlay = YES;
    } else {
        self.isEnableToPlay = NO;
    }
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    // 当发生错误，停止播放时，会回调这个方法
}

- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
    // 当解码器发生错误时，会回调这个方法
    // 当 videotoolbox 硬解初始化或解码出错时
    // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
    // 播发器也将自动切换成软解，继续播放
}

/**
 * 即将开始进入后台播放任务
 */
- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
    [self pausePlayVideo];
}

/**
 * 即将结束后台播放状态任务
 */
- (void)playerWillEndBackgroundTask:(nonnull PLPlayer *)player {
    [self resumePlayVideo];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
    CAAnimation *heartImageViewAnimation = [self.heartImageView.layer animationForKey:@"heartImageViewAnimation"];
    if (anim == heartImageViewAnimation) {
        self.heartImageView.hidden = NO;
    } else {
        self.heartBrokenLeftImageView.hidden = NO;
        self.heartBrokenRightImageView.hidden = NO;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        CAAnimation *heartImageViewAnimation = [self.heartImageView.layer animationForKey:@"heartImageViewAnimation"];
        if (anim == heartImageViewAnimation) {
            self.heartImageView.hidden = YES;
        } else {
            self.heartBrokenLeftImageView.hidden = YES;
            self.heartBrokenRightImageView.hidden = YES;
        }
    }
}

#pragma mark - events

/**
 * 点击返回按钮
 */
- (void)clickBackButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickBackButtonWithModel:self.model];
}

/**
 * 点击屏幕，继续或暂停播放
 */
- (void)singleTapContainerView:(UITapGestureRecognizer *)sender {
    
    PLPlayerStatus status = self.player.status;
    if (status == PLPlayerStatusPlaying || status == PLPlayerStatusCaching) {
        [self pausePlayVideo];
    } else if (status == PLPlayerStatusPaused) {
        [self resumePlayVideo];
    }
}

/**
 * 双击屏幕点赞
 */
- (void)doubleTapContainerView:(UITapGestureRecognizer *)sender {
    [self showLikeAnimation:sender];
    [self.delegate tableViewCell:self clickLikeButtonWithModel:self.model];
}

/**
 * 点击直播按钮
 */
- (void)clickLiveButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickLiveButtonWithModel:self.model];
}

/**
 * 点击广告按钮
 */
- (void)clickAdvertisementButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickAdvertisementButtonWithModel:self.model];
}

/**
 * 点击红包按钮
 */
- (void)clickRedEnvelopeButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickRedEnvelopeButtonWithModel:self.model];
}

/**
 * 点击用户头像按钮
 */
- (void)clickHeaderButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickHeaderButtonWithModel:self.model];
}

/**
 * 点击关注按钮
 */
- (void)clickAttentionButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickAttentionButtonWithModel:self.model];
}

/**
 * 点击点赞按钮
 */
- (void)clickLikeButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickLikeButtonWithModel:self.model];
}

/**
 * 点击评论按钮
 */
- (void)clickCommentButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickCommentButtonWithModel:self.model];
}

/**
 * 点击分享按钮
 */
- (void)clickShareButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickShareButtonWithModel:self.model];
}

/**
 * 点击礼物按钮
 */
- (void)clickGiftButton:(UIButton *)button {
    [self.delegate tableViewCell:self clickGiftButtonWithModel:self.model];
}

#pragma mark - setter & getter

- (void)setIsVideoNeedsToPlay:(BOOL)isVideoNeedsToPlay {
    
    _isVideoNeedsToPlay = isVideoNeedsToPlay;
    if (_isVideoNeedsToPlay && _isEnableToPlay) {
        [self startPlayVideo];
    }
}

- (void)setIsEnableToPlay:(BOOL)isEnableToPlay {
    
    _isEnableToPlay = isEnableToPlay;
    if (_isVideoNeedsToPlay && _isEnableToPlay) {
        [self startPlayVideo];
    }
}

@end
