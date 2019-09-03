//
//  XKGamesTransactionListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGamesTransactionListViewController.h"
#import "XKGamesTransactionListTableViewCell.h"


static NSString * const cardCellID   = @"cardCellID";

@interface XKGamesTransactionListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy  ) NSArray     *dataSource;
@end

@implementation XKGamesTransactionListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configTableView];
}

#pragma mark - Events



#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"交易明细" WithColor:[UIColor whiteColor]];
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
    
    XKGamesTransactionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
    if (!cell) {
        cell = [[XKGamesTransactionListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
