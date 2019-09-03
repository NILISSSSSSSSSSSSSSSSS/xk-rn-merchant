//
//  XKRedEnvelopeViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedEnvelopeViewController.h"
#import "XKRedEnvelopeInfoHeaderView.h"
#import "XKRedEnvelopeXKCoinTableViewCell.h"
#import "XKRedEnvelopeCardCouponTableViewCell.h"
#import "XKRedEnvelopeGiftTableViewCell.h"
#import "XKRedPacketDetailCell.h"
#import "XKCoinViewController.h"
#import "XKMineCouponPackageMainViewController.h"
#import "XKMyGiftRootController.h"

@interface XKRedEnvelopeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XKRedEnvelopeInfoHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger test;

@end

@implementation XKRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.test = arc4random() % 3;
    
    self.navigationView.backgroundColor = HEX_RGB(0xEE6161);
    if (self.test == 0) {
        // 晓可币红包
        [self setNavTitle:@"晓可币红包" WithColor:HEX_RGB(0xffffff)];
    } else if (self.test == 1) {
        // 卡券红包
        [self setNavTitle:@"卡券红包" WithColor:HEX_RGB(0xffffff)];
    } else {
        // 礼物红包
        [self setNavTitle:@"礼物红包" WithColor:HEX_RGB(0xffffff)];
    }
    [self hideNavigationSeperateLine];
    [self initializeViews];
    [self updateViews];
}

- (void)initializeViews {
    
    self.headerView = [[XKRedEnvelopeInfoHeaderView alloc] init];
    if (iPhoneX_Serious) {
        self.headerView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 215.0 + 24.0);
    } else {
        self.headerView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 215.0);
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[XKRedEnvelopeXKCoinTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKRedEnvelopeXKCoinTableViewCell class])];
    [self.tableView registerClass:[XKRedEnvelopeCardCouponTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKRedEnvelopeCardCouponTableViewCell class])];
    [self.tableView registerClass:[XKRedEnvelopeGiftTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKRedEnvelopeGiftTableViewCell class])];
    [self.tableView registerClass:[XKRedPacketDetailCell class] forCellReuseIdentifier:NSStringFromClass([XKRedPacketDetailCell class])];
    [self.view insertSubview:self.tableView belowSubview:self.navigationView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInset = UIEdgeInsetsMake(-kStatusBarHeight, 0.0, 0.0, 0.0);
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)updateViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0));
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == XKRedEnvelopeVCTypeOpened || self.type == XKRedEnvelopeVCTypeGetDone) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.type == XKRedEnvelopeVCTypeOpened || self.type == XKRedEnvelopeVCTypeDetail) {
            return self.mineArray.count + 3;
        } else {
            return 1;
        }
    } else if (section == 1) {
        return self.allArray.count + 10;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.type == XKRedEnvelopeVCTypeOpened || self.type == XKRedEnvelopeVCTypeDetail) {
            if (self.test == 0) {
                // 晓可币红包
                XKRedEnvelopeXKCoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRedEnvelopeXKCoinTableViewCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell configCellWithNum:100.0];
                return cell;
            } else if (self.test == 1) {
                // 卡券红包
                XKRedEnvelopeCardCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRedEnvelopeCardCouponTableViewCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell configCellWithName:@"大吉大利，今晚吃鸡优惠券" num:100];
                return cell;
            } else {
                // 礼物红包
                XKRedEnvelopeGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRedEnvelopeGiftTableViewCell class]) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell configCellWithImgUrl:nil num:100];
                return cell;
            }
        } else {
            // 红包已被抢完
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            for (UIView *temp in cell.contentView.subviews) {
                [temp removeFromSuperview];
            }
            UILabel *label = [[UILabel alloc] init];
            label.text = @"红包已被抢完";
            label.font = XKRegularFont(36.0);
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView);
            }];
            return cell;
        }
    } else {
        // 领取情况
        XKRedPacketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKRedPacketDetailCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.allArray.count == 1) {
            cell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
        } else {
            if(indexPath.row == 0) {
                cell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
            } else if(indexPath.row == self.allArray.count - 1) {
                cell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                cell.bgContainView.xk_clipType = XKCornerClipTypeNone;
            }
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return 32.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        UIView *view = [[UIView alloc] init];
        
        UILabel *detailLab = [[UILabel alloc] init];
        detailLab.text = @"领取详情";
        detailLab.font = XKRegularFont(12.0);
        detailLab.textColor = XKMainTypeColor;
        [view addSubview:detailLab];
        
        UILabel *remarkLab = [[UILabel alloc] init];
        remarkLab.text = @"已领取100/100个，共100晓可币";
        remarkLab.font = XKRegularFont(12.0);
        remarkLab.textColor = HEX_RGB(0x999999);
        [view addSubview:remarkLab];
        
        [detailLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(view);
            make.leading.mas_equalTo(12.0);
        }];
        
        [remarkLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(view);
            make.left.mas_equalTo(detailLab.mas_right).offset(10.0);
            make.trailing.mas_equalTo(-12.0);
        }];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.type == XKRedEnvelopeVCTypeOpened || self.type == XKRedEnvelopeVCTypeDetail) {
            if (self.test == 0) {
                // 晓可币红包
                return 72.0;
            } else if (self.test == 1) {
                // 卡券红包
                return 40.0;
                // 礼物红包
            } else {
                return 40.0;
            }
        } else {
            // 红包已被抢完
            return 70.0;
        }
    } else {
        return 60.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 32.0;
    } else {
        return 20.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = XKRegularFont(14.0);
        if (self.type == XKRedEnvelopeVCTypeOpened || self.type == XKRedEnvelopeVCTypeDetail) {
            if (self.test == 0) {
                // 晓可币红包
                [btn setTitle:@"已存入晓可币账户" forState:UIControlStateNormal];
            } else if (self.test == 1) {
                // 卡券红包
                [btn setTitle:@"已放入卡券包" forState:UIControlStateNormal];
            } else {
                // 礼物红包
                [btn setTitle:@"查看收到的礼物" forState:UIControlStateNormal];
            }
        } else {
            // 红包已被抢完
            [btn setTitle:@"查看领取详情 >" forState:UIControlStateNormal];
        }
        [btn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(view);
            make.centerX.mas_equalTo(view);
        }];
        [btn bk_whenTapped:^{
            if (self.type == XKRedEnvelopeVCTypeOpened || self.type == XKRedEnvelopeVCTypeDetail) {
                if (self.test == 0) {
                    // 晓可币红包
                    XKCoinViewController *vc = [[XKCoinViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (self.test == 1) {
                    // 卡券红包
                    XKMineCouponPackageMainViewController *vc = [[XKMineCouponPackageMainViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    // 礼物红包
                    XKMyGiftRootController *vc = [[XKMyGiftRootController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                // 红包已被抢完
                XKRedEnvelopeViewController *vc = [[XKRedEnvelopeViewController alloc] init];
                vc.type = XKRedEnvelopeVCTypeDetail;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return view;
    } else {
        return nil;
    }
}

#pragma mark - getter setter

- (NSMutableArray *)openedArray {
    if (!_mineArray) {
        _mineArray = [NSMutableArray array];
    }
    return _mineArray;
}

- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

@end
