//
//  XKBankCardDetailInfoViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBankCardDetailInfoViewController.h"
#import "XKBankCardDetailCell.h"
#import "XKBankCardUnbindViewController.h"

static NSString * const cardCellID   = @"cardCellID";

@interface XKBankCardDetailInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *headerView;
@property (nonatomic, strong) UIButton    *unbindButton;

@end

@implementation XKBankCardDetailInfoViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);

    [self configNavigationBar];
    [self configHeaderView];
    [self configTableView];
}

#pragma mark - Events

- (void)unbindButtonClicked:(UIButton *)sender {
    //
    XKBankCardUnbindViewController *vc = [[XKBankCardUnbindViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"银行卡信息" WithColor:[UIColor whiteColor]];
}

- (void)configHeaderView {
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
}

- (void)configTableView {
    
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH-20, 64)];
    [footerView addSubview:self.unbindButton];
    self.tableView.tableFooterView = footerView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30 + NavigationAndStatue_Height);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 121 * ScreenScale;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XKBankCardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
        if (!cell) {
            cell = [[XKBankCardDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cardCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = HEX_RGB(0x222222);
            cell.textLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
            cell.detailTextLabel.textColor = HEX_RGB(0x555555);
            cell.detailTextLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13];
            
            if (indexPath.row == 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
                lineView.backgroundColor = XKSeparatorLineColor;
                [cell.contentView addSubview:lineView];
            }
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"单笔限额";
            cell.detailTextLabel.text = @"￥10000";
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)];

        } else {
            cell.textLabel.text = @"每日限额";
            cell.detailTextLabel.text = @"￥20000";
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)];

        }
        
        return cell;
    }
}



#pragma mark - CustomDelegate



#pragma mark - lazy load


- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = XKMainTypeColor;
    }
    return _headerView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)unbindButton {
    if (!_unbindButton) {
        _unbindButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH - 20, 44)];
        [_unbindButton addTarget:self action:@selector(unbindButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _unbindButton.layer.masksToBounds = YES;
        _unbindButton.layer.cornerRadius = 5;
        _unbindButton.backgroundColor = HEX_RGB(0xEE6161);
        [_unbindButton setTitle:@"解除绑定" forState:UIControlStateNormal];
        [_unbindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _unbindButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _unbindButton;
}

@end
