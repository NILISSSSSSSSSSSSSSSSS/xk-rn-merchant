//
//  XKMineMainViewSocialContactTableHeaderView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewSocialContactTableHeaderView.h"
#import "CYLConstants.h"
#import "XKPersonalDataModel.h"

#define kMineMainViewSocialContactTableHeaderViewiPhoneXHeightDifference (iPhoneX ? 24: 0)
static const CGFloat kMineMainViewSocialContactTableHeaderHeight = 362;
static const CGFloat kMineMainViewSocialContactTableHeaderSocialContactViewHeight = 245;
static const CGFloat kMineMainViewSocialContactTableHeaderConsumablesViewHeight = 168;

NSString *const kMineMainViewSocialContactFans = @"fans";                           /** 粉丝 */
NSString *const kMineMainViewSocialContactLike = @"like";                           /** 获赞 */
NSString *const kMineMainViewSocialContactFollow = @"follow";                       /** 关注 */
NSString *const kMineMainViewSocialContactFavorite = @"favorite";                   /** 收藏 */
NSString *const kMineMainViewSocialContactComment = @"comment";                     /** 点评 */

NSString *const kMineMainViewSocialContactCardVoucher = @"cardVoucher";             /** 卡券 */
NSString *const kMineMainViewSocialContactXkCoin = @"xkCoin";                       /** 晓可币 */
NSString *const kMineMainViewSocialContactConsumerCoupon = @"consumerCoupon";       /** 消费券 */
NSString *const kMineMainViewSocialContactGift = @"gift";                           /** 我的礼物 */
NSString *const kMineMainViewSocialContactAward = @"award";                         /** 我的获奖 */
NSString *const kMineMainViewSocialContactPacket = @"packet";                       /** 红包 */

@interface XKMineMainViewSocialContactTableHeaderView ()

/** 社交模块视图 */
@property (nonatomic, strong) UIView *socialContactView;
@property (nonatomic, strong) UIImageView *socialContactBackgroundImageView;
@property (nonatomic, strong) UIImageView *socialContactPortrayalImageView;
@property (nonatomic, strong) UILabel *socialContactNameLabel;
@property (nonatomic, strong) UILabel *socialContactIdLabel;
@property (nonatomic, strong) UILabel *socialContactSignatureLabel;
@property (nonatomic, strong) NSMutableArray<UIControl *> *socialContactControlArr;
@property (nonatomic, strong) NSMutableArray<UILabel *> *socialContactCountLabelArr;

/** 消耗品视图 */
@property (nonatomic, strong) UIView *consumablesView;
@property (nonatomic, strong) NSMutableArray<UIControl *> *consumablesControlLineOneArr;
@property (nonatomic, strong) NSMutableArray<UIControl *> *consumablesControlLineTwoArr;
@property (nonatomic, strong) NSMutableArray<UILabel *> *consumablesCountLabelArr;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *consumablesCountImageViewArr;

@end

@implementation XKMineMainViewSocialContactTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.contentView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self initializeSocialContactView];
    [self initializeConsumablesViewWith];
    return self;
}

#pragma mark public method

- (void)configHeaderViewWithPersonalDataModel:(XKPersonalDataModel *)personalDataModel {
    
    NSString *nickname = personalDataModel.nickname;
    NSString *signature = personalDataModel.signature;
    NSString *avatarUrl = personalDataModel.avatar;
    NSString *uid = personalDataModel.uid;
    if (nickname && ![nickname isEqualToString:@""]) {
        self.socialContactNameLabel.text = nickname;
    }
    if (uid && ![uid isEqualToString:@""]) {
        self.socialContactIdLabel.text = [NSString stringWithFormat:@"ID：%@", uid];
    }
    if (signature && ![signature isEqualToString:@""]) {
        self.socialContactSignatureLabel.text = signature;
    }
    if (avatarUrl && ![avatarUrl isEqualToString:@""]) {
        [self.socialContactPortrayalImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"xk_ic_home_default_header"]];
    }
}

- (void)configHeaderViewWithSocialContactCountDict:(NSDictionary *)dict {
    
    if (!dict || dict.count == 0) {
        return;
    }
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *countString;
        if (obj) {
            countString = [NSString stringWithFormat:@"%@", obj];
        } else {
            countString = @"0";
        }
        UIControl *control;
        UILabel *countLabel;
        UIImageView *bgImageView;
        if ([key isEqualToString:kMineMainViewSocialContactFans]) {
            countLabel = self.socialContactCountLabelArr[0];
        } else if ([key isEqualToString:kMineMainViewSocialContactLike]) {
            countLabel = self.socialContactCountLabelArr[1];
        } else if ([key isEqualToString:kMineMainViewSocialContactFollow]) {
            countLabel = self.socialContactCountLabelArr[2];
        } else if ([key isEqualToString:kMineMainViewSocialContactFavorite]) {
            countLabel = self.socialContactCountLabelArr[3];
        } else if ([key isEqualToString:kMineMainViewSocialContactComment]) {
            countLabel = self.socialContactCountLabelArr[4];
            
        } else if ([key isEqualToString:kMineMainViewSocialContactCardVoucher]) {
            control = self.consumablesControlLineOneArr[0];
            countLabel = self.consumablesCountLabelArr[0];
            bgImageView = self.consumablesCountImageViewArr[0];
        } else if ([key isEqualToString:kMineMainViewSocialContactXkCoin]) {
            control = self.consumablesControlLineOneArr[1];
            countLabel = self.consumablesCountLabelArr[1];
            bgImageView = self.consumablesCountImageViewArr[1];
        } else if ([key isEqualToString:kMineMainViewSocialContactConsumerCoupon]) {
            control = self.consumablesControlLineOneArr[2];
            countLabel = self.consumablesCountLabelArr[2];
            bgImageView = self.consumablesCountImageViewArr[2];
        } else if ([key isEqualToString:kMineMainViewSocialContactGift]) {
            control = self.consumablesControlLineTwoArr[0];
            countLabel = self.consumablesCountLabelArr[3];
            bgImageView = self.consumablesCountImageViewArr[3];
        } else if ([key isEqualToString:kMineMainViewSocialContactAward]) {
            control = self.consumablesControlLineTwoArr[1];
            countLabel = self.consumablesCountLabelArr[4];
            bgImageView = self.consumablesCountImageViewArr[4];
        } else if ([key isEqualToString:kMineMainViewSocialContactPacket]) {
            control = self.consumablesControlLineTwoArr[2];
            countLabel = self.consumablesCountLabelArr[5];
            bgImageView = self.consumablesCountImageViewArr[5];
        }

        countLabel.text = countString;
//        [bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(countLabel.mas_right).offset(2).priorityHigh();
//        }];
//        [bgImageView setNeedsUpdateConstraints];
//        [bgImageView updateConstraintsIfNeeded];
//        [control layoutIfNeeded];
    }];
}

- (void)configHeaderViewBackgroundImageWithY:(CGFloat)y {
    self.socialContactBackgroundImageView.y = y;
    self.socialContactBackgroundImageView.height = kMineMainViewSocialContactTableHeaderSocialContactViewHeight - y;
}

#pragma mark private method

/** 初始化社交模块视图 */
- (void)initializeSocialContactView {
    
    // 社交模块根视图
    UIView *socialContactView = [UIView new];
    [self addSubview:socialContactView];
    [socialContactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(kMineMainViewSocialContactTableHeaderSocialContactViewHeight + 2 * kMineMainViewSocialContactTableHeaderViewiPhoneXHeightDifference));
    }];
    
    // 背景图片
    self.socialContactBackgroundImageView = [UIImageView new];
    self.socialContactBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.socialContactBackgroundImageView.clipsToBounds = YES;
    self.socialContactBackgroundImageView.image = [UIImage imageNamed:@"xk_ic_home_background"];
    [socialContactView addSubview:self.socialContactBackgroundImageView];
    self.socialContactBackgroundImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kMineMainViewSocialContactTableHeaderSocialContactViewHeight);
    
    // 遮罩图片
//    UIView *mockView = [UIView new];
//    [socialContactView addSubview:mockView];
//    mockView.backgroundColor = HEX_RGBA(0x4A90FA, 0.8);
//    [mockView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.top.equalTo(socialContactView);
//    }];
    
    // 设置按钮
    UIButton *socialContactSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [socialContactSettingButton setImage:[UIImage imageNamed:@"xk_ic_home_setting"] forState:UIControlStateNormal];
    [socialContactSettingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [socialContactView addSubview:socialContactSettingButton];
    [socialContactSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(socialContactView.mas_top).offset(35 + kMineMainViewSocialContactTableHeaderViewiPhoneXHeightDifference);
        make.right.equalTo(socialContactView.mas_right).offset(-24);
        make.height.width.equalTo(@(25));
    }];
    
    // 足迹按钮
    UIButton *socialContactHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [socialContactHistoryButton setImage:[UIImage imageNamed:@"xk_ic_home_history"] forState:UIControlStateNormal];
    [socialContactHistoryButton addTarget:self action:@selector(clickHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [socialContactView addSubview:socialContactHistoryButton];
    [socialContactHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(socialContactSettingButton.mas_top);
        make.right.equalTo(socialContactSettingButton.mas_left).offset(-14);
        make.height.width.equalTo(@(25));
    }];
    
    // 头像
    self.socialContactPortrayalImageView = [UIImageView new];
    self.socialContactPortrayalImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.socialContactPortrayalImageView.image = [UIImage imageNamed:@"xk_ic_home_default_header"];
    self.socialContactPortrayalImageView.xk_openClip = YES;
    self.socialContactPortrayalImageView.xk_radius = 3;
    self.socialContactPortrayalImageView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    [socialContactView addSubview:self.socialContactPortrayalImageView];
    [self.socialContactPortrayalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(socialContactSettingButton.mas_top).offset(25);
        make.left.equalTo(socialContactView.mas_left).offset(25);
        make.height.width.equalTo(@(46));
    }];
    
    // 用户名
    self.socialContactNameLabel = [UILabel new];
    self.socialContactNameLabel.textColor = [UIColor whiteColor];
    self.socialContactNameLabel.textAlignment = NSTextAlignmentLeft;
    self.socialContactNameLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:15.0];
    [socialContactView addSubview:self.socialContactNameLabel];
    [self.socialContactNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.socialContactPortrayalImageView.mas_top).offset(-5);
        make.left.equalTo(self.socialContactPortrayalImageView.mas_right).offset(15);
        make.right.equalTo(socialContactHistoryButton.mas_left).offset(-15);
    }];
    
    // ID
    self.socialContactIdLabel = [UILabel new];
    self.socialContactIdLabel.textColor = [UIColor whiteColor];
    self.socialContactIdLabel.textAlignment = NSTextAlignmentLeft;
    self.socialContactIdLabel.numberOfLines = 1;
    self.socialContactIdLabel.font = [UIFont fontWithName:XK_PingFangSC_Semibold size:10.0];
    [socialContactView addSubview:self.socialContactIdLabel];
    [self.socialContactIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.socialContactNameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.socialContactNameLabel.mas_left);
        make.right.equalTo(socialContactHistoryButton.mas_left).offset(-15);
    }];
    
    // 签名
    self.socialContactSignatureLabel = [UILabel new];
    self.socialContactSignatureLabel.textColor = [UIColor whiteColor];
    self.socialContactSignatureLabel.textAlignment = NSTextAlignmentLeft;
    self.socialContactSignatureLabel.numberOfLines = 2;
    self.socialContactSignatureLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
    [socialContactView addSubview:self.socialContactSignatureLabel];
    [self.socialContactSignatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.socialContactIdLabel.mas_bottom).offset(3);
        make.left.equalTo(self.socialContactIdLabel.mas_left);
        make.right.equalTo(socialContactHistoryButton.mas_left).offset(-15);
    }];
    self.socialContactSignatureLabel.text = @"本宝宝暂时还没想到有趣的签名";
    
    // 社交状态
    for (NSInteger index = 0; index < 5; index++) {
        UIControl *control = [UIControl new];
        control.tag = 1000 + index;
        [control addTarget:self action:@selector(clickSocialContactControls:) forControlEvents:UIControlEventTouchUpInside];
        [socialContactView addSubview:control];
        UILabel *countLabel = [UILabel new];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:16.0];
        countLabel.text = @"";
        [control addSubview:countLabel];
        [self.socialContactCountLabelArr addObject:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(control.mas_centerX);
            make.top.equalTo(control.mas_top);
        }];
        UILabel *titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        switch (index) {
            case 0:
                titleLabel.text = @"粉丝";
                break;
            case 1:
                titleLabel.text = @"获赞";
                break;
            case 2:
                titleLabel.text = @"关注";
                break;
            case 3:
                titleLabel.text = @"收藏";
                break;
            case 4:
                titleLabel.text = @"点评";
                break;
            default:
                break;
        }
        [control addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(control.mas_centerX);
            make.top.equalTo(countLabel.mas_bottom);
        }];
        [self.socialContactControlArr addObject:control];
    }
    [self.socialContactControlArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:30 tailSpacing:30];
    [self.socialContactControlArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.socialContactPortrayalImageView.mas_bottom).offset(30);
        make.height.equalTo(@(44));
    }];
    self.socialContactView = socialContactView;
}

/** 初始化消耗品视图 */
- (void)initializeConsumablesViewWith {
    
    // 消耗品根视图
    UIView *consumablesView = [UIView new];
    consumablesView.backgroundColor = [UIColor whiteColor];
    consumablesView.xk_openClip = YES;
    consumablesView.xk_radius = 8;
    consumablesView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    [self addSubview:consumablesView];
    [consumablesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.socialContactView.mas_bottom).offset(kMineMainViewSocialContactTableHeaderHeight - kMineMainViewSocialContactTableHeaderSocialContactViewHeight - kMineMainViewSocialContactTableHeaderConsumablesViewHeight - kMineMainViewSocialContactTableHeaderViewiPhoneXHeightDifference);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@(kMineMainViewSocialContactTableHeaderConsumablesViewHeight));
    }];
    
    // 消耗品选择视图
    for (NSInteger index = 0; index < 6; index++) {
        UIControl *control = [UIControl new];
        control.tag = 2000 + index;
        [control addTarget:self action:@selector(clickConsumablesControls:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [control addGestureRecognizer:longPress];
        [consumablesView addSubview:control];
        UIImageView *imageView = [UIImageView new];
        [control addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(control.mas_centerX);
            make.centerY.equalTo(control.mas_centerY).offset(-10);
            make.width.height.equalTo(@38);
        }];
        UILabel *titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor darkTextColor];
        titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:14.0];
        switch (index) {
            case 0:
                titleLabel.text = @"卡券";
                imageView.image = [UIImage imageNamed:@"xk_ic_home_coupon"];
                break;
            case 1:
                titleLabel.text = @"晓可币";
                imageView.image = [UIImage imageNamed:@"xk_ic_home_coin"];
                break;
            case 2:
                titleLabel.text = @"消费券";
                imageView.image = [UIImage imageNamed:@"xk_ic_home_consume_coupon"];
                break;
            case 3:
                titleLabel.text = @"我的礼物";
                imageView.image = [UIImage imageNamed:@"xk_ic_home_gift"];
                break;
            case 4:
                titleLabel.text = @"我的获奖";
                imageView.image = [UIImage imageNamed:@"xk_ic_home_ award"];
                break;
            case 5:
                titleLabel.text = @"红包";
                imageView.image = [UIImage imageNamed:@"xk_ic_home_packet"];
                break;
            default:
                break;
        }
        [control addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(5);
            make.centerX.equalTo(imageView.mas_centerX);
        }];
        
        // 数量背景
        UIImageView *countBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
        countBgImageView.image = [UIImage imageNamed:@"xk_ic_home_count_background"];
        countBgImageView.contentMode = UIViewContentModeScaleToFill;
        countBgImageView.xk_openClip = YES;
        countBgImageView.xk_radius = 4;
        countBgImageView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight | XKCornerClipTypeBottomRight;
        countBgImageView.hidden = YES;
        [control addSubview:countBgImageView];
        [self.consumablesCountImageViewArr addObject:countBgImageView];
        
        // 显示数量
        UILabel *countLabel = [UILabel new];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:10.0];
        countLabel.text = @"";
        countLabel.hidden = YES;
        countLabel.adjustsFontSizeToFitWidth = YES;
        [countBgImageView addSubview:countLabel];
        [self.consumablesCountLabelArr addObject:countLabel];
        
        [countBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top);
            make.left.equalTo(titleLabel.mas_centerX).offset(5);
            make.height.equalTo(@(15));
            make.width.equalTo(@(50));
//            make.right.equalTo(countLabel.mas_right).offset(2).priorityHigh();
        }];
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(countBgImageView.mas_centerY);
            make.centerX.equalTo(countBgImageView.mas_centerX);
            make.width.equalTo(@(50));
//            make.left.equalTo(countBgImageView.mas_left).offset(5);
        }];
        if (index >= 0 && index < 3) {
            [self.consumablesControlLineOneArr addObject:control];
        } else {
            [self.consumablesControlLineTwoArr addObject:control];
        }
    }
    
    // 水平两行排列消耗品选择视图
    [self.consumablesControlLineOneArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:45 leadSpacing:35 tailSpacing:35];
    [self.consumablesControlLineOneArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(consumablesView.mas_top);
        make.width.height.equalTo(@(kMineMainViewSocialContactTableHeaderConsumablesViewHeight / 2));
    }];
    [self.consumablesControlLineTwoArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:45 leadSpacing:35 tailSpacing:35];
    [self.consumablesControlLineTwoArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(kMineMainViewSocialContactTableHeaderConsumablesViewHeight / 2));
        make.bottom.equalTo(consumablesView.mas_bottom);
    }];
    
    self.consumablesView = consumablesView;
}

#pragma mark events

- (void)clickHistoryButton:(UIButton *)sender {
    [self.delegate socialContactTableHeaderView:self clickHistoryButton:sender];
}

- (void)clickSettingButton:(UIButton *)sender {
    [self.delegate socialContactTableHeaderView:self clickSettingButton:sender];
}

- (void)clickSocialContactControls:(UIControl *)sender {
    switch (sender.tag) {
        case 1000: {
            [self.delegate socialContactTableHeaderView:self clickSocialContactControls:XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateFans];
            break;
        }
        case 1001: {
            [self.delegate socialContactTableHeaderView:self clickSocialContactControls:XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStatePraise];
            break;
        }
        case 1002: {
            [self.delegate socialContactTableHeaderView:self clickSocialContactControls:XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStatedFocus];
            break;
        }
        case 1003: {
            [self.delegate socialContactTableHeaderView:self clickSocialContactControls:XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateCollect];
            break;
        }
        case 1004: {
            [self.delegate socialContactTableHeaderView:self clickSocialContactControls:XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateComment];
            break;
        }
        default:
            break;
    }
}

// 点击消耗品
- (void)clickConsumablesControls:(UIControl *)sender {
    switch (sender.tag) {
        case 2000: {
            [self.delegate socialContactTableHeaderView:self clickConsumablesControls:XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateCouponPackage];
            break;
        }
        case 2001: {
            [self.delegate socialContactTableHeaderView:self clickConsumablesControls:XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateCoin];
            break;
        }
        case 2002: {
            [self.delegate socialContactTableHeaderView:self clickConsumablesControls:XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateConsume];
            break;
        }
        case 2003: {
            [self.delegate socialContactTableHeaderView:self clickConsumablesControls:XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateMyGift];
            break;
        }
        case 2004: {
            [self.delegate socialContactTableHeaderView:self clickConsumablesControls:XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateWinningRecords];
            break;
        }
        case 2005: {
            [self.delegate socialContactTableHeaderView:self clickConsumablesControls:XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateRedEnvelope];
            break;
        }
    }
}

// 长按消耗品
- (void)longPressGesture:(UILongPressGestureRecognizer *)theLongPress {
    
    UILabel *countLabel = self.consumablesCountLabelArr[theLongPress.view.tag - 2000];
    UIImageView *imageView = self.consumablesCountImageViewArr[theLongPress.view.tag - 2000];
    if (theLongPress.state == UIGestureRecognizerStateEnded) {
        // 长按结束时隐藏
        countLabel.hidden = YES;
        imageView.hidden = YES;
    } else {
        if (countLabel.text && ![countLabel.text isEqualToString:@""]) {
            countLabel.hidden = NO;
            imageView.hidden = NO;
        }
    }
}

#pragma mark setter and getter

- (NSMutableArray *)socialContactControlArr {
    
    if (!_socialContactControlArr) {
        _socialContactControlArr = @[].mutableCopy;
    }
    return _socialContactControlArr;
}

- (NSMutableArray *)socialContactCountLabelArr {
    
    if (!_socialContactCountLabelArr) {
        _socialContactCountLabelArr = @[].mutableCopy;
    }
    return _socialContactCountLabelArr;
}

- (NSMutableArray *)consumablesControlLineOneArr {
    
    if (!_consumablesControlLineOneArr) {
        _consumablesControlLineOneArr = @[].mutableCopy;
    }
    return _consumablesControlLineOneArr;
}

- (NSMutableArray *)consumablesControlLineTwoArr {
    
    if (!_consumablesControlLineTwoArr) {
        _consumablesControlLineTwoArr = @[].mutableCopy;
    }
    return _consumablesControlLineTwoArr;
}

- (NSMutableArray *)consumablesCountLabelArr {
    
    if (!_consumablesCountLabelArr) {
        _consumablesCountLabelArr = @[].mutableCopy;
    }
    return _consumablesCountLabelArr;
}

- (NSMutableArray *)consumablesCountImageViewArr {
    
    if (!_consumablesCountImageViewArr) {
        _consumablesCountImageViewArr = @[].mutableCopy;
    }
    return _consumablesCountImageViewArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
