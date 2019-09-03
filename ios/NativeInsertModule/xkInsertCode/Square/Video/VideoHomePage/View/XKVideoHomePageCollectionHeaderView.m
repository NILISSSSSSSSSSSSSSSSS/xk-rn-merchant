//
//  XKVideoHomePageCollectionHeaderView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoHomePageCollectionHeaderView.h"
#import "XKAutoScrollView.h"
#import "XKAutoScrollImageItem.h"
#import "XKLiveBannerModel.h"

// 2018.10.19版本
//static const CGFloat kVideoHomePageCollectionHeaderViewTopImageViewHeight = 135;
//static const CGFloat kVideoHomePageCollectionHeaderViewRankViewHeight = 110;
static const CGFloat kVideoHomePageCollectionHeaderViewTopImageViewHeight = 125;

@interface XKVideoHomePageCollectionHeaderView () <XKAutoScrollViewDelegate>

@property (nonatomic, strong) XKAutoScrollView  *loopView;

@property (nonatomic, strong) NSMutableArray <UIControl *> *anchorList;
@property (nonatomic, strong) NSMutableArray <UIControl *> *moneyList;

@end

@implementation XKVideoHomePageCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)configHeaderViewWithModel:(NSArray<XKLiveBannerModelListItem *> *)liveBannerModelList {
    
    NSMutableArray *arr = @[].mutableCopy;
    for (XKLiveBannerModelListItem *item in liveBannerModelList) {
        NSMutableDictionary *dict = @{}.mutableCopy;
        [dict setObject:item.url forKey:@"link"];
        [dict setObject:item.img forKey:@"image"];
        [arr addObject:dict];
    }
    [self.loopView setScrollViewItems:arr];
}

- (void)initializeViews {
    
    
    self.backgroundColor = HEX_RGB(0xF6F6F6);
    
    // 顶部轮播视图
    self.loopView = [[XKAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kVideoHomePageCollectionHeaderViewTopImageViewHeight) delegate:self isShowPageControl:YES isAuto:YES];
    [self addSubview:self.loopView];

    // 热门视频
    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.xk_openClip = YES;
    titleView.xk_radius = 8;
    titleView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopView.mas_bottom).offset(5);
        make.left.equalTo(self.loopView.mas_left).offset(10);
        make.right.equalTo(self.loopView.mas_right).offset(-10);
        make.height.equalTo(@(44));
    }];
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = XKMainTypeColor;
    [titleView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.centerX.equalTo(titleView.mas_centerX);
        make.height.equalTo(@(3));
        make.width.equalTo(@(140));
    }];
    UILabel *titleLabel = [UILabel new];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"热门视频";
    titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:15.0];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.centerX.equalTo(titleView.mas_centerX);
        make.width.equalTo(@(90));
    }];
}

#pragma mark - XKAutoScrollViewDelegate

- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index {
    [self.delegate headerView:self clickBannerWithUrlLink:item.link];
}

#pragma mark - setter & getter

- (NSMutableArray *)anchorList {
    
    if (!_anchorList) {
        _anchorList = @[].mutableCopy;
    }
    return _anchorList;
}

- (NSMutableArray *)moneyList {
    
    if (!_moneyList) {
        _moneyList = @[].mutableCopy;
    }
    return _moneyList;
}


// 2018.10.19版本
//    // 榜单视图
//    UIView *rankView = [UIView new];
//    rankView.backgroundColor = [UIColor whiteColor];
//    rankView.xk_openClip = YES;
//    rankView.xk_radius = 8;
//    rankView.xk_clipType = XKCornerClipTypeAllCorners;
//    [self addSubview:rankView];
//    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.imageView.mas_bottom).offset(-25);
//        make.left.equalTo(self.mas_left).offset(10);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.height.equalTo(@(kVideoHomePageCollectionHeaderViewRankViewHeight));
//    }];
//
//    // 主播榜
//    UIControl *anchorControl = [UIControl new];
//    anchorControl.xk_openClip = YES;
//    anchorControl.xk_radius = 8;
//    anchorControl.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
//    [rankView addSubview:anchorControl];
//    [anchorControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(rankView.mas_top);
//        make.left.equalTo(rankView.mas_left);
//        make.right.equalTo(rankView.mas_right);
//        make.height.equalTo(rankView.mas_height).multipliedBy(0.5);
//    }];
//    [anchorControl addTarget:self action:@selector(clickAnchorControl:) forControlEvents:UIControlEventTouchUpInside];
//
//    // 主播榜-奖杯
//    UIImageView *anchorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_ic_video_cup"]];
//    [anchorControl addSubview:anchorImageView];
//    [anchorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(anchorControl.mas_left).offset(15);
//        make.centerY.equalTo(anchorControl.mas_centerY);
//        make.width.height.equalTo(@(20));
//    }];
//
//    // 主播榜-标题
//    UILabel *anchorTitle = [UILabel new];
//    anchorTitle.text = @"主播榜";
//    anchorTitle.font = [UIFont fontWithName:XK_PingFangSC_Medium size:15.0];
//    [anchorControl addSubview:anchorTitle];
//    [anchorTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(anchorImageView.mas_right).offset(5);
//        make.centerY.equalTo(anchorControl.mas_centerY);
//    }];
//
//    // 主播榜-箭头
//    UIImageView *anchorArrowsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"]];
//    [anchorControl addSubview:anchorArrowsImageView];
//    [anchorArrowsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(anchorControl.mas_right).offset(-10);
//        make.centerY.equalTo(anchorControl.mas_centerY);
//        make.width.height.equalTo(@(15));
//    }];
//
//    // 主播榜-主播列表
//    for (NSInteger index = 0; index < 3; index++) {
//        UIControl *control = [UIControl new];
//        control.tag = 1000 + index;
//        [control addTarget:self action:@selector(clickAnchorListControls:) forControlEvents:UIControlEventTouchUpInside];
//        [anchorControl addSubview:control];
//        [control mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@(36));
//            make.right.equalTo(anchorArrowsImageView.mas_left).offset(-8 - index * 50);
//            make.centerY.equalTo(anchorControl.mas_centerY);
//        }];
//        UIImageView *headImageView = [UIImageView new];
//
//        // yuan'mock
//        headImageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
//        headImageView.xk_openClip = YES;
//        headImageView.xk_radius = 18;
//        headImageView.xk_clipType = XKCornerClipTypeAllCorners;
//        [control addSubview:headImageView];
//        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(control.mas_centerX);
//            make.centerY.equalTo(control.mas_centerY);
//            make.width.height.equalTo(@(36));
//        }];
//        if (index == 2) {
//            UIImageView *championImageView = [UIImageView new];
//            championImageView.image = [UIImage imageNamed:@"xk_ic_video_champion"];
//            [control addSubview:championImageView];
//            [championImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(control.mas_top);
//                make.left.equalTo(control.mas_left);
//                make.width.height.equalTo(@(12));
//            }];
//        }
//    }
//
//    // 金主榜
//    UIControl *moneyControl = [UIControl new];
//    moneyControl.xk_openClip = YES;
//    moneyControl.xk_radius = 8;
//    moneyControl.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
//    [rankView addSubview:moneyControl];
//    [moneyControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(rankView.mas_bottom);
//        make.left.equalTo(rankView.mas_left);
//        make.right.equalTo(rankView.mas_right);
//        make.height.equalTo(rankView.mas_height).multipliedBy(0.5);
//    }];
//    [moneyControl addTarget:self action:@selector(clickMoneyControl:) forControlEvents:UIControlEventTouchUpInside];
//
//    // 金主榜-奖杯
//    UIImageView *moneyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_ic_video_cup"]];
//    [moneyControl addSubview:moneyImageView];
//    [moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(moneyControl.mas_left).offset(15);
//        make.centerY.equalTo(moneyControl.mas_centerY);
//        make.width.height.equalTo(@(20));
//    }];
//
//    // 金主榜-标题
//    UILabel *moneyTitle = [UILabel new];
//    moneyTitle.text = @"金主榜";
//    moneyTitle.font = [UIFont fontWithName:XK_PingFangSC_Medium size:15.0];
//    [moneyControl addSubview:moneyTitle];
//    [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(moneyImageView.mas_right).offset(5);
//        make.centerY.equalTo(moneyControl.mas_centerY);
//    }];
//
//    // 金主榜-箭头
//    UIImageView *moneyArrowsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"]];
//    [moneyControl addSubview:moneyArrowsImageView];
//    [moneyArrowsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(moneyControl.mas_right).offset(-10);
//        make.centerY.equalTo(moneyControl.mas_centerY);
//        make.width.height.equalTo(@(15));
//    }];
//
//    // 金主榜-主播列表
//    for (NSInteger index = 0; index < 3; index++) {
//        UIControl *control = [UIControl new];
//        control.tag = 2000 + index;
//        [control addTarget:self action:@selector(clickMoneyListControls:) forControlEvents:UIControlEventTouchUpInside];
//        [moneyControl addSubview:control];
//        [control mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.equalTo(@(36));
//            make.right.equalTo(moneyArrowsImageView.mas_left).offset(-8 - index * 50);
//            make.centerY.equalTo(moneyControl.mas_centerY);
//
//        }];
//        UIImageView *headImageView = [UIImageView new];
//        headImageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
//        headImageView.xk_openClip = YES;
//        headImageView.xk_radius = 18;
//        headImageView.xk_clipType = XKCornerClipTypeAllCorners;
//        [control addSubview:headImageView];
//        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(control.mas_centerX);
//            make.centerY.equalTo(control.mas_centerY);
//            make.width.height.equalTo(@(36));
//        }];
//        if (index == 2) {
//            UIImageView *championImageView = [UIImageView new];
//            championImageView.image = [UIImage imageNamed:@"xk_ic_video_champion"];
//            [control addSubview:championImageView];
//            [championImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(control.mas_top);
//                make.left.equalTo(control.mas_left);
//                make.width.height.equalTo(@(12));
//            }];
//        }
//    }


// 2018.10.19版本
///*
// * 点击主播列表
// */
//- (void)clickAnchorControl:(UIControl *)control {
//    [self.delegate headerView:self clickAnchorControl:control];
//}
//
///*
// * 点击金主列表
// */
//- (void)clickMoneyControl:(UIControl *)control {
//    [self.delegate headerView:self clickMoneyControl:control];
//}
//
///*
// * 点击单个主播
// */
//- (void)clickAnchorListControls:(UIControl *)control {
//
//}
//
///*
// * 点击单个金主
// */
//- (void)clickMoneyListControls:(UIControl *)control {
//
//}

@end
