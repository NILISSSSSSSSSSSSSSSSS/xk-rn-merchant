//
//  XKMineCouponPackageHeaderView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineCouponPackageHeaderView.h"

@interface XKMineCouponPackageHeaderView ()

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIView *middleContainerView;
@property (nonatomic, strong) UIView *switchingView;
@property (nonatomic, strong) NSMutableArray *filterButtonArr;
@property (nonatomic, strong) UILabel *cardCountLabel;
@property (nonatomic, strong) UILabel *couponCountLabel;

@end

@implementation XKMineCouponPackageHeaderView

/*
 * 配置卡券数量
 */
- (void)configHeaderViewWithCountDictionary:(NSDictionary *)dataDict {
    
    NSString *cardCount = [NSString stringWithFormat:@"%@", dataDict[@"memberCount"]];
    NSString *couponCount = [NSString stringWithFormat:@"%@", dataDict[@"couponCount"]];
    self.cardCountLabel.text = cardCount;
    self.couponCountLabel.text = couponCount;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    // 导航栏延伸视图
    UIView *extensionView = [UIView new];
    extensionView.backgroundColor = XKMainTypeColor;
    [self.contentView addSubview:extensionView];
    [extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    // 顶部容器视图
    UIView *topContainerView = [self initializeTopContainerView];
    [self.contentView addSubview:topContainerView];
    [topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(126);
    }];
    self.topContainerView = topContainerView;
    
    // 中部容器视图
    UIView *middleContainerView = [self initializeMiddleContainerView];
    [self.contentView addSubview:middleContainerView];
    [middleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topContainerView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(84);
    }];
    self.middleContainerView = middleContainerView;
    
    return self;
}

/** 初始化顶部容器视图 */
- (UIView *)initializeTopContainerView {
    
    // 容器视图
    UIView *topContainerView = [UIView new];
    topContainerView.backgroundColor = [UIColor whiteColor];
    topContainerView.xk_openClip = YES;
    topContainerView.xk_radius = 5.0;
    topContainerView.xk_clipType = XKCornerClipTypeAllCorners;
    
    // 分割线
    UIView *topContainerViewSeparator = [UIView new];
    topContainerViewSeparator.backgroundColor = XKSeparatorLineColor;
    [topContainerView addSubview:topContainerViewSeparator];
    [topContainerViewSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topContainerView.mas_top);
        make.bottom.equalTo(topContainerView.mas_bottom);
        make.centerX.equalTo(topContainerView.mas_centerX);
        make.width.mas_equalTo(1);
    }];
    
    // 左侧视图
    UIControl *topContainerLeftControl = [UIControl new];
    [topContainerLeftControl addTarget:self action:@selector(clickCard:) forControlEvents:UIControlEventTouchUpInside];
    [topContainerView addSubview:topContainerLeftControl];
    [topContainerLeftControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topContainerView.mas_top).offset(5);
        make.left.equalTo(topContainerView.mas_left).offset(5);
        make.bottom.equalTo(topContainerView.mas_bottom).offset(-5);
        make.right.equalTo(topContainerViewSeparator.mas_left).offset(-5);
    }];
    UIImageView *topContainerLeftImageView = [UIImageView new];
    topContainerLeftImageView.image = [UIImage imageNamed:@"xk_ic_card"];
    [topContainerLeftControl addSubview:topContainerLeftImageView];
    [topContainerLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(50);
        make.centerX.equalTo(topContainerLeftControl.mas_centerX);
        make.top.equalTo(topContainerLeftControl.mas_top).offset(12);
    }];
    UILabel *topContainerLeftDescribeLabel = [UILabel new];
    topContainerLeftDescribeLabel.text = @"折扣卡";
    topContainerLeftDescribeLabel.textColor = [UIColor darkTextColor];
    topContainerLeftDescribeLabel.textAlignment = NSTextAlignmentCenter;
    topContainerLeftDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:16.0];
    [topContainerLeftControl addSubview:topContainerLeftDescribeLabel];
    [topContainerLeftDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topContainerLeftControl.mas_centerX);
        make.top.equalTo(topContainerLeftImageView.mas_bottom).offset(5);
    }];
    UILabel *topContainerLeftCountLabel = [UILabel new];
    topContainerLeftCountLabel.textColor = RGB(241, 114, 94);
    topContainerLeftCountLabel.textAlignment = NSTextAlignmentCenter;
    topContainerLeftCountLabel.font = [UIFont fontWithName:XK_PingFangSC_Semibold size:14.0];
    [topContainerLeftControl addSubview:topContainerLeftCountLabel];
    [topContainerLeftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topContainerLeftControl.mas_centerX);
        make.top.equalTo(topContainerLeftDescribeLabel.mas_bottom).offset(3);
    }];
    self.cardCountLabel = topContainerLeftCountLabel;
    
    // 右侧视图
    UIControl *topContainerRightControl = [UIControl new];
    [topContainerRightControl addTarget:self action:@selector(clickCoupon:) forControlEvents:UIControlEventTouchUpInside];
    [topContainerView addSubview:topContainerRightControl];
    [topContainerRightControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topContainerView.mas_top).offset(5);
        make.left.equalTo(topContainerViewSeparator.mas_right).offset(5);
        make.bottom.equalTo(topContainerView.mas_bottom).offset(-5);
        make.right.equalTo(topContainerView.mas_right).offset(-5);
    }];
    UIImageView *topContainerRightImageView = [UIImageView new];
    topContainerRightImageView.image = [UIImage imageNamed:@"xk_ic_coupon"];
    [topContainerRightControl addSubview:topContainerRightImageView];
    [topContainerRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(50);
        make.centerX.equalTo(topContainerRightControl.mas_centerX);
        make.top.equalTo(topContainerRightControl.mas_top).offset(12);
    }];
    UILabel *topContainerRightDescribeLabel = [UILabel new];
    topContainerRightDescribeLabel.text = @"优惠券";
    topContainerRightDescribeLabel.textColor = [UIColor darkTextColor];
    topContainerRightDescribeLabel.textAlignment = NSTextAlignmentCenter;
    topContainerRightDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:16.0];
    [topContainerRightControl addSubview:topContainerRightDescribeLabel];
    [topContainerRightDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topContainerRightControl.mas_centerX);
        make.top.equalTo(topContainerRightImageView.mas_bottom).offset(5);
    }];
    UILabel *topContainerRightCountLabel = [UILabel new];
    topContainerRightCountLabel.textColor = RGB(241, 114, 94);
    topContainerRightCountLabel.textAlignment = NSTextAlignmentCenter;
    topContainerRightCountLabel.font = [UIFont fontWithName:XK_PingFangSC_Semibold size:14.0];
    [topContainerRightControl addSubview:topContainerRightCountLabel];
    [topContainerRightCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topContainerRightControl.mas_centerX);
        make.top.equalTo(topContainerRightDescribeLabel.mas_bottom).offset(3);
    }];
    self.couponCountLabel = topContainerRightCountLabel;
    
    return topContainerView;
}

/** 初始化中部容器视图 */
- (UIView *)initializeMiddleContainerView {
    
    UIView *middleContainerView = [UIView new];
    middleContainerView.backgroundColor = [UIColor whiteColor];
    middleContainerView.xk_openClip = YES;
    middleContainerView.xk_radius = 5.0;
    middleContainerView.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    
    // 分割线
    UIView *horizontalSeparatorOne = [UIView new];
    horizontalSeparatorOne.backgroundColor = XKSeparatorLineColor;
    [middleContainerView addSubview:horizontalSeparatorOne];
    [horizontalSeparatorOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleContainerView.mas_left);
        make.right.equalTo(middleContainerView.mas_right);
        make.centerY.equalTo(middleContainerView.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    UIView *horizontalSeparatorTwo = [UIView new];
    horizontalSeparatorTwo.backgroundColor = XKSeparatorLineColor;
    [middleContainerView addSubview:horizontalSeparatorTwo];
    [horizontalSeparatorTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleContainerView.mas_left);
        make.right.equalTo(middleContainerView.mas_right);
        make.bottom.equalTo(middleContainerView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    UIView *verticalSeparator = [UIView new];
    verticalSeparator.backgroundColor = XKSeparatorLineColor;
    [middleContainerView addSubview:verticalSeparator];
    [verticalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleContainerView.mas_top).offset(2);
        make.bottom.equalTo(horizontalSeparatorOne.mas_top).offset(-2);
        make.centerX.equalTo(middleContainerView.mas_centerX);
        make.width.mas_equalTo(1);
    }];
    
    // 最近领取/即将失效
    UIControl *recentControl = [UIControl new];
    [recentControl addTarget:self action:@selector(clickRecentControl:) forControlEvents:UIControlEventTouchUpInside];
    [middleContainerView addSubview:recentControl];
    [recentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleContainerView.mas_top).offset(5);
        make.left.equalTo(middleContainerView.mas_left).offset(5);
        make.bottom.equalTo(horizontalSeparatorOne.mas_top);
        make.right.equalTo(verticalSeparator.mas_left);
    }];
    UILabel *recentControlDescribeLabel = [UILabel new];
    recentControlDescribeLabel.text = @"最近领取";
    recentControlDescribeLabel.textAlignment = NSTextAlignmentCenter;
    recentControlDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [recentControl addSubview:recentControlDescribeLabel];
    [recentControlDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(recentControl.mas_centerX);
        make.centerY.equalTo(recentControl.mas_centerY);
    }];
    UIControl *oldControl = [UIControl new];
    [oldControl addTarget:self action:@selector(clickOldControl:) forControlEvents:UIControlEventTouchUpInside];
    [middleContainerView addSubview:oldControl];
    [oldControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleContainerView.mas_top).offset(5);
        make.left.equalTo(verticalSeparator.mas_right);
        make.bottom.equalTo(horizontalSeparatorOne.mas_top);
        make.right.equalTo(middleContainerView.mas_right).offset(-5);
    }];
    UILabel *oldControlDescribeLabel = [UILabel new];
    oldControlDescribeLabel.text = @"即将失效";
    oldControlDescribeLabel.textAlignment = NSTextAlignmentCenter;
    oldControlDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [oldControl addSubview:oldControlDescribeLabel];
    [oldControlDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oldControl.mas_centerX);
        make.centerY.equalTo(oldControl.mas_centerY);
    }];
    
    // 选择滑块
    UIView *switchingView = [UIView new];
    switchingView.backgroundColor = XKMainTypeColor;
    [middleContainerView addSubview:switchingView];
    [switchingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@3);
        make.width.equalTo(@60);
        make.centerX.equalTo(recentControl.mas_centerX);
        make.centerY.equalTo(middleContainerView.mas_centerY).offset(-1);
    }];
    self.switchingView = switchingView;
    
    // 筛选按钮
    NSMutableArray *filterButtonArr = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        filterButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [filterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [filterButton addTarget:self action:@selector(clickCardOrCouponTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [middleContainerView addSubview:filterButton];
        [filterButtonArr addObject:filterButton];
        switch (i) {
            case 0:
                [filterButton setTitle:@"晓可卡" forState:UIControlStateNormal];
                [filterButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
                break;
            case 1:
                [filterButton setTitle:@"商户卡" forState:UIControlStateNormal];
                break;
            case 2:
                [filterButton setTitle:@"优惠券" forState:UIControlStateNormal];
                break;
            case 3:
                [filterButton setTitle:@"商户券" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    [filterButtonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [filterButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(horizontalSeparatorOne.mas_bottom);
        make.bottom.equalTo(horizontalSeparatorTwo.mas_top);
    }];
    self.filterButtonArr = filterButtonArr;
    
    return middleContainerView;
}

// 移动选择滑块
- (void)updateSwitchingViewFrame:(UIControl *)sender {

    [self.switchingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@3);
        make.width.equalTo(@60);
        make.centerX.equalTo(sender.mas_centerX);
        make.centerY.equalTo(self.middleContainerView.mas_centerY).offset(-1);
    }];
    [self.switchingView setNeedsUpdateConstraints];
    [self.switchingView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        [self.middleContainerView layoutIfNeeded];
    }];
}

#pragma mark - events

// 点击折扣卡
- (void)clickCard:(UIControl *)sender {
    
    [self.delegate headerView:self clickCard:sender];
}

// 点击优惠券
- (void)clickCoupon:(UIControl *)sender {
    
    [self.delegate headerView:self clickCoupon:sender];
}

// 点击最近领取
- (void)clickRecentControl:(UIControl *)sender {
    
    [self updateSwitchingViewFrame:sender];
    [self clickCardOrCouponTypeButton:self.filterButtonArr[0]];
    [self.delegate headerView:self clickRecentControl:sender];
}

// 点击即将失效
- (void)clickOldControl:(UIControl *)sender {
    
    [self updateSwitchingViewFrame:sender];
    [self clickCardOrCouponTypeButton:self.filterButtonArr[0]];
    [self.delegate headerView:self clickOldControl:sender];
}

// 点击筛选按钮
- (void)clickCardOrCouponTypeButton:(UIButton *)button {
    
    for (UIButton *filterButton in self.filterButtonArr) {
        [filterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    [self.delegate headerView:self clickCardOrCouponTypeButton:button];
}

@end
