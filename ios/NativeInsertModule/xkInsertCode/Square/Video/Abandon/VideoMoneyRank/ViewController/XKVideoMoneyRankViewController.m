//
//  XKVideoMoneyRankViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoMoneyRankViewController.h"
#import "XKVideoAnchorRankTableViewCell.h"

@interface XKVideoMoneyRankViewController () <UITableViewDelegate, UITableViewDataSource>

// 主视图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

// 时间选择视图
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIView *switchingView;
@property (nonatomic, strong) NSMutableArray *filterButtonArr;

@end

@implementation XKVideoMoneyRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)initializeViews {
    
    // 导航栏
    [self setNavTitle:@"金主排行榜" WithColor:[UIColor whiteColor]];
    [self hideNavigationSeperateLine];
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[XKVideoAnchorRankTableViewCell class] forCellReuseIdentifier:@"XKVideoAnchorRankTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    //    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 260;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 区头根视图
    UIView *headerView = [UIView new];
    
    // 背景视图
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_bg_video_rank_background"]];
    [headerView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@(225));
    }];
    
// =================================================== 冠军 ===================================================
    
    // 冠军-颁奖台
    UIImageView *championBgImageView = [UIImageView new];
    championBgImageView.image = [UIImage imageNamed:@"xk_bg_video_champion"];
    [headerView addSubview:championBgImageView];
    [championBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundView.mas_bottom);
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.width.equalTo(@(130));
        make.height.equalTo(@(110));
    }];
    UILabel *championDescribeLabel = [UILabel new];
    championDescribeLabel.text = @"总贡献";
    championDescribeLabel.textColor = [UIColor whiteColor];
    championDescribeLabel.textAlignment = NSTextAlignmentCenter;
    championDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:12.0];
    [championBgImageView addSubview:championDescribeLabel];
    [championDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(championBgImageView.mas_top).offset(15);
        make.centerX.equalTo(championBgImageView.mas_centerX);
    }];
    UILabel *championCoinLabel = [UILabel new];
    championCoinLabel.text = @" 6666晓可币 ";
    championCoinLabel.backgroundColor = RGB(39, 90, 225);
    championCoinLabel.layer.cornerRadius = 7;
    championCoinLabel.layer.masksToBounds = YES;
    championCoinLabel.textColor = [UIColor whiteColor];
    championCoinLabel.textAlignment = NSTextAlignmentCenter;
    championCoinLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [championBgImageView addSubview:championCoinLabel];
    [championCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(championDescribeLabel.mas_top).offset(20);
        make.centerX.equalTo(championBgImageView.mas_centerX);
        make.height.equalTo(@(14));
    }];
    
    // 冠军-头像
    UIImageView *championHeadImageView = [UIImageView new];
    championHeadImageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
    championHeadImageView.layer.borderWidth = 2;
    championHeadImageView.layer.borderColor = RGB(254, 208, 30).CGColor;
    championHeadImageView.layer.cornerRadius = 34;
    championHeadImageView.layer.masksToBounds = YES;
    [headerView addSubview:championHeadImageView];
    [championHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(13);
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.height.equalTo(@(68));
    }];
    UIImageView *championIcImageView = [UIImageView new];
    championIcImageView.image = [UIImage imageNamed:@"xk_ic_video_champion"];
    [headerView addSubview:championIcImageView];
    [championIcImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(championHeadImageView.mas_top).offset(-5);
        make.left.equalTo(championHeadImageView.mas_left).offset(-5);
        make.width.height.equalTo(@(25));
    }];
    
    // 冠军-关注按钮
    UIButton *championattentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    championattentionButton.layer.cornerRadius = 9;
    championattentionButton.layer.masksToBounds = YES;
    championattentionButton.backgroundColor = RGB(254, 208, 30);
    [championattentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [championattentionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    championattentionButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [headerView addSubview:championattentionButton];
    [championattentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(championHeadImageView.mas_bottom).offset(-12);
        make.centerX.equalTo(championHeadImageView.mas_centerX);
        make.width.equalTo(@(44));
        make.height.equalTo(@(18));
    }];
    
    // 冠军-名字
    UILabel *championNameLabel = [UILabel new];
    championNameLabel.text = @"唯美主义者";
    championNameLabel.textColor = [UIColor whiteColor];
    championNameLabel.textAlignment = NSTextAlignmentCenter;
    championNameLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [headerView addSubview:championNameLabel];
    [championNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(championattentionButton.mas_bottom).offset(5);
        make.centerX.equalTo(championattentionButton.mas_centerX);
    }];
    
// =================================================== 亚军 ===================================================
    
    // 亚军-颁奖台
    UIImageView *runnerBgImageView = [UIImageView new];
    runnerBgImageView.image = [UIImage imageNamed:@"xk_bg_video_runner"];
    [headerView addSubview:runnerBgImageView];
    [runnerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundView.mas_bottom);
        make.right.equalTo(championBgImageView.mas_left).offset(15);
        make.width.equalTo(@(120));
        make.height.equalTo(@(90));
    }];
    UILabel *runnerDescribeLabel = [UILabel new];
    runnerDescribeLabel.text = @"总贡献";
    runnerDescribeLabel.textColor = [UIColor whiteColor];
    runnerDescribeLabel.textAlignment = NSTextAlignmentCenter;
    runnerDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:12.0];
    [runnerBgImageView addSubview:runnerDescribeLabel];
    [runnerDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(runnerBgImageView.mas_top).offset(15);
        make.centerX.equalTo(runnerBgImageView.mas_centerX);
    }];
    UILabel *runnerCoinLabel = [UILabel new];
    runnerCoinLabel.text = @" 6666晓可币 ";
    runnerCoinLabel.backgroundColor = RGB(39, 90, 225);
    runnerCoinLabel.layer.cornerRadius = 7;
    runnerCoinLabel.layer.masksToBounds = YES;
    runnerCoinLabel.textColor = [UIColor whiteColor];
    runnerCoinLabel.textAlignment = NSTextAlignmentCenter;
    runnerCoinLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [runnerBgImageView addSubview:runnerCoinLabel];
    [runnerCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(runnerDescribeLabel.mas_top).offset(20);
        make.centerX.equalTo(runnerBgImageView.mas_centerX);
        make.height.equalTo(@(14));
    }];
    
    // 亚军-头像
    UIImageView *runnerHeadImageView = [UIImageView new];
    runnerHeadImageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
    runnerHeadImageView.layer.borderWidth = 2;
    runnerHeadImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    runnerHeadImageView.layer.cornerRadius = 30;
    runnerHeadImageView.layer.masksToBounds = YES;
    [headerView addSubview:runnerHeadImageView];
    [runnerHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(36);
        make.centerX.equalTo(runnerBgImageView.mas_centerX);
        make.width.height.equalTo(@(60));
    }];
    UIImageView *runnerIcImageView = [UIImageView new];
    runnerIcImageView.image = [UIImage imageNamed:@"xk_ic_video_runner"];
    [headerView addSubview:runnerIcImageView];
    [runnerIcImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(runnerHeadImageView.mas_top).offset(-5);
        make.left.equalTo(runnerHeadImageView.mas_left).offset(-5);
        make.width.height.equalTo(@(25));
    }];
    
    // 亚军-关注按钮
    UIButton *runnerattentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    runnerattentionButton.layer.cornerRadius = 9;
    runnerattentionButton.layer.masksToBounds = YES;
    runnerattentionButton.backgroundColor = RGB(254, 208, 30);
    [runnerattentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [runnerattentionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    runnerattentionButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [headerView addSubview:runnerattentionButton];
    [runnerattentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(runnerHeadImageView.mas_bottom).offset(-12);
        make.centerX.equalTo(runnerHeadImageView.mas_centerX);
        make.width.equalTo(@(44));
        make.height.equalTo(@(18));
    }];
    
    // 亚军-名字
    UILabel *runnerNameLabel = [UILabel new];
    runnerNameLabel.text = @"布鲁布鲁";
    runnerNameLabel.textColor = [UIColor whiteColor];
    runnerNameLabel.textAlignment = NSTextAlignmentCenter;
    runnerNameLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [headerView addSubview:runnerNameLabel];
    [runnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(runnerattentionButton.mas_bottom).offset(5);
        make.centerX.equalTo(runnerattentionButton.mas_centerX);
    }];
    
// =================================================== 季军 ===================================================
    
    // 季军-颁奖台
    UIImageView *thirdWinnerBgImageView = [UIImageView new];
    thirdWinnerBgImageView.image = [UIImage imageNamed:@"xk_bg_video_third_winner"];
    [headerView addSubview:thirdWinnerBgImageView];
    [thirdWinnerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundView.mas_bottom);
        make.left.equalTo(championBgImageView.mas_right).offset(-15);
        make.width.equalTo(@(120));
        make.height.equalTo(@(75));
    }];
    UILabel *thirdWinnerDescribeLabel = [UILabel new];
    thirdWinnerDescribeLabel.text = @"总贡献";
    thirdWinnerDescribeLabel.textColor = [UIColor whiteColor];
    thirdWinnerDescribeLabel.textAlignment = NSTextAlignmentCenter;
    thirdWinnerDescribeLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:12.0];
    [thirdWinnerBgImageView addSubview:thirdWinnerDescribeLabel];
    [thirdWinnerDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdWinnerBgImageView.mas_top).offset(15);
        make.centerX.equalTo(thirdWinnerBgImageView.mas_centerX);
    }];
    UILabel *thirdWinnerCoinLabel = [UILabel new];
    thirdWinnerCoinLabel.text = @" 6666晓可币 ";
    thirdWinnerCoinLabel.backgroundColor = RGB(39, 90, 225);
    thirdWinnerCoinLabel.layer.cornerRadius = 7;
    thirdWinnerCoinLabel.layer.masksToBounds = YES;
    thirdWinnerCoinLabel.textColor = [UIColor whiteColor];
    thirdWinnerCoinLabel.textAlignment = NSTextAlignmentCenter;
    thirdWinnerCoinLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [thirdWinnerBgImageView addSubview:thirdWinnerCoinLabel];
    [thirdWinnerCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdWinnerDescribeLabel.mas_top).offset(20);
        make.centerX.equalTo(thirdWinnerBgImageView.mas_centerX);
        make.height.equalTo(@(14));
    }];
    
    // 季军-头像
    UIImageView *thirdWinnerHeadImageView = [UIImageView new];
    thirdWinnerHeadImageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
    thirdWinnerHeadImageView.layer.borderWidth = 2;
    thirdWinnerHeadImageView.layer.borderColor = RGB(195, 118, 81).CGColor;
    thirdWinnerHeadImageView.layer.cornerRadius = 30;
    thirdWinnerHeadImageView.layer.masksToBounds = YES;
    [headerView addSubview:thirdWinnerHeadImageView];
    [thirdWinnerHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(53);
        make.centerX.equalTo(thirdWinnerBgImageView.mas_centerX);
        make.width.height.equalTo(@(60));
    }];
    UIImageView *thirdWinnerIcImageView = [UIImageView new];
    thirdWinnerIcImageView.image = [UIImage imageNamed:@"xk_ic_video_third_winner"];
    [headerView addSubview:thirdWinnerIcImageView];
    [thirdWinnerIcImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdWinnerHeadImageView.mas_top).offset(-5);
        make.left.equalTo(thirdWinnerHeadImageView.mas_left).offset(-5);
        make.width.height.equalTo(@(25));
    }];
    
    // 季军-关注按钮
    UIButton *thirdWinnerattentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdWinnerattentionButton.layer.cornerRadius = 9;
    thirdWinnerattentionButton.layer.masksToBounds = YES;
    thirdWinnerattentionButton.backgroundColor = RGB(254, 208, 30);
    [thirdWinnerattentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [thirdWinnerattentionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    thirdWinnerattentionButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [headerView addSubview:thirdWinnerattentionButton];
    [thirdWinnerattentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdWinnerHeadImageView.mas_bottom).offset(-12);
        make.centerX.equalTo(thirdWinnerHeadImageView.mas_centerX);
        make.width.equalTo(@(44));
        make.height.equalTo(@(18));
    }];
    
    // 季军-名字
    UILabel *thirdWinnerNameLabel = [UILabel new];
    thirdWinnerNameLabel.text = @"jaufy";
    thirdWinnerNameLabel.textColor = [UIColor whiteColor];
    thirdWinnerNameLabel.textAlignment = NSTextAlignmentCenter;
    thirdWinnerNameLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:10.0];
    [headerView addSubview:thirdWinnerNameLabel];
    [thirdWinnerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdWinnerattentionButton.mas_bottom).offset(5);
        make.centerX.equalTo(thirdWinnerattentionButton.mas_centerX);
    }];
    
    // 冠军颁奖台移到顶层
    [headerView bringSubviewToFront:championBgImageView];
    
// =================================================== 时间维度选择 ===================================================
    
    // 时间维度选择 - 根视图
    UIView *filterView = [UIView new];
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.xk_openClip = YES;
    filterView.xk_radius = 8;
    filterView.xk_clipType = XKCornerClipTypeAllCorners;
    [headerView addSubview:filterView];
    [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_bottom).offset(-18);
        make.left.equalTo(headerView.mas_left).offset(10);
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.height.equalTo(@(44));
    }];
    self.filterView = filterView;
    
    // 时间维度选择视图 - 按钮
    NSMutableArray *filterButtonArr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        filterButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [filterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [filterButton addTarget:self action:@selector(clickFilterButton:) forControlEvents:UIControlEventTouchUpInside];
        [filterView addSubview:filterButton];
        switch (i) {
            case 0: {
                [filterButton setTitle:@"日榜" forState:UIControlStateNormal];
                [filterButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
                
                // 时间维度选择 - 选择滑块
                self.switchingView = [UIView new];
                self.switchingView.backgroundColor = XKMainTypeColor;
                [filterView addSubview:self.switchingView];
                [self.switchingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(filterButton.mas_bottom).offset(-3);
                    make.centerX.equalTo(filterButton.mas_centerX);
                    make.height.equalTo(@3);
                    make.width.equalTo(@60);
                }];
                break;
            }
            case 1: {
                [filterButton setTitle:@"周榜" forState:UIControlStateNormal];
                break;
            }
                
            case 2: {
                [filterButton setTitle:@"月榜" forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
        
        // 时间维度选择视图 - 分割线
        UIView *separatorView = [UIView new];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [filterButton addSubview:separatorView];
        [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(filterButton.mas_right);
            make.centerY.equalTo(filterButton.mas_centerY);
            make.width.equalTo(@(0.5));
            make.height.equalTo(@(20));
        }];
        [filterButtonArr addObject:filterButton];
    }
    [filterButtonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [filterButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(filterView.mas_top);
        make.bottom.equalTo(filterView.mas_bottom);
    }];
    self.filterButtonArr = filterButtonArr;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKVideoAnchorRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKVideoAnchorRankTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell showTopCornerRadius];
    }
    else if (indexPath.row == 4) {
        [cell showBottomCornerRadius];
    } else {
        [cell hiddenCornerRadius];
    }
    if (indexPath.row == 0) {
        [cell showSecondMedalImageView];
    } else if (indexPath.row == 1) {
        [cell showThirdMedalImageView];
    } else {
        [cell hiddenMedalImageView];
    }
    
    return cell;
}

#pragma mark - events

- (void)clickFilterButton:(UIButton *)button {
    
    // 移动选择滑块
    [self.switchingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(-3);
        make.centerX.equalTo(button.mas_centerX);
        make.height.equalTo(@3);
        make.width.equalTo(@60);
    }];
    [self.switchingView setNeedsUpdateConstraints];
    [self.switchingView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        [self.filterView layoutIfNeeded];
    }];
    
    // 改变按钮title颜色
    for (UIButton *filterButton in self.filterButtonArr) {
        [filterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
}

@end
