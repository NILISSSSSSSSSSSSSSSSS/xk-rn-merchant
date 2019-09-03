//
//  XKBuyCoinListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBuyCoinListViewController.h"
#import "XKBuyCoinListTableViewCell.h"
#import "XKGamesCoinRechargeViewController.h"
#import "XKGameCoinAccountListViewController.h"

static NSString * const cardCellID   = @"cardCellID";

@interface XKBuyCoinListViewController () <UITableViewDelegate, UITableViewDataSource, BuyCoinDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy  ) NSArray     *dataSource;
@end

@implementation XKBuyCoinListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configTableView];
}

#pragma mark - Events

- (void)rightButtonClicked {
    
    XKGameCoinAccountListViewController *vc = [[XKGameCoinAccountListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"购买" WithColor:[UIColor whiteColor]];
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"账号管理" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self setNaviCustomView:rightButton withframe:CGRectMake(SCREEN_WIDTH - 80, 0, 70, 30)];
}

- (void)configTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height+10, 0, 0, 0));
    }];
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKBuyCoinListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
    if (!cell) {
        cell = [[XKBuyCoinListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row == 0) {
        [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 64)];
    } else if (indexPath.row == 4) {
        [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 64)];
    } else {
        [cell restoreFromCorner];
    }
    return cell;
}

#pragma Coustom Delegate

- (void)buyButtonClicked:(UIButton *)sender binded:(BOOL)binded{
    
    XKGamesCoinRechargeViewController *vc = [[XKGamesCoinRechargeViewController alloc] init];
    vc.binded = binded;
    vc.titleName = @"Q币";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 64;
    }
    return _tableView;
}


@end
