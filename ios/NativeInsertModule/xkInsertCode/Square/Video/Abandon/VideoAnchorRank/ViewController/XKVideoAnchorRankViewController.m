//
//  XKVideoAnchorRankViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoAnchorRankViewController.h"
#import "XKVideoAnchorRankTableViewCell.h"

@interface XKVideoAnchorRankViewController () <UITableViewDelegate, UITableViewDataSource>

// 主视图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

// 时间选择视图
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIView *switchingView;
@property (nonatomic, strong) NSMutableArray *filterButtonArr;

@end

@implementation XKVideoAnchorRankViewController

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
    [self setNavTitle:@"主播排行榜" WithColor:[UIColor whiteColor]];
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
    return 210;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 区头根视图
    UIView *headerView = [UIView new];
    
    // 背景视图
    UIImageView *gackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_bg_video_rank_background"]];
    [headerView addSubview:gackgroundView];
    [gackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.equalTo(@(175));
    }];

    // 主播头像
    UIImageView *headImageView = [UIImageView new];
    headImageView.layer.borderWidth = 2;
    headImageView.layer.borderColor = RGB(254, 208, 30).CGColor;
    headImageView.layer.cornerRadius = 25;
    headImageView.layer.masksToBounds = YES;
    [headerView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(13);
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.height.equalTo(@(50));
    }];

    // top1背景彩带
    UIImageView *headBackgroundImageView = [UIImageView new];
    headBackgroundImageView.image = [UIImage imageNamed:@"xk_bg_video_rank_top1"];
    [headerView addSubview:headBackgroundImageView];
    [headBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top);
        make.centerX.equalTo(headImageView.mas_centerX).offset(7);
        make.width.equalTo(@(156));
        make.height.equalTo(@(90));
    }];

    // 主播名字
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = RGB(254, 208, 30);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17.0];
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBackgroundImageView.mas_bottom).offset(-5);
        make.centerX.equalTo(headBackgroundImageView.mas_centerX);
    }];

    // 得到钻石
    UILabel *diamondLabel = [UILabel new];
    diamondLabel.textColor = [UIColor whiteColor];
    diamondLabel.textAlignment = NSTextAlignmentCenter;
    diamondLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:11.0];
    [headerView addSubview:diamondLabel];
    [diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(3);
        make.centerX.equalTo(headBackgroundImageView.mas_centerX);
    }];

    // 关注按钮
    UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButton.layer.borderWidth = 1;
    attentionButton.layer.borderColor = [UIColor yellowColor].CGColor;
    attentionButton.layer.cornerRadius = 13;
    attentionButton.layer.masksToBounds = YES;
    [attentionButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [attentionButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    attentionButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:14.0];
    [headerView addSubview:attentionButton];
    [attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_top).offset(5);
        make.right.equalTo(headerView.mas_right).offset(-20);
        make.width.equalTo(@(70));
        make.height.equalTo(@(26));
    }];
    
    // 时间维度选择视图
    UIView *filterView = [UIView new];
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.xk_openClip = YES;
    filterView.xk_radius = 8;
    filterView.xk_clipType = XKCornerClipTypeAllCorners;
    [headerView addSubview:filterView];
    [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gackgroundView.mas_bottom).offset(-18);
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
