//
//  XKMessageActivityAndSpecialViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageActivityAndSpecialViewController.h"
#import "XKMessageActivityAndSpecialViewModel.h"

@interface XKMessageActivityAndSpecialViewController ()
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) XKMessageActivityAndSpecialViewModel *viewModel;
@end

@implementation XKMessageActivityAndSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTable];
    if (self.type == XKSpecialSysMessageControllerType) {
        [self setNavTitle:@"专题" WithColor:[UIColor whiteColor]];
    }else if (self.type == XKActivitySysMessageControllerType){
        [self setNavTitle:@"活动" WithColor:[UIColor whiteColor]];
    }
}

- (void)creatTable {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    _tableView.estimatedRowHeight = 100;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.viewModel registerCellForTableView:_tableView];
    self.viewModel.type = self.type;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestRefresh:YES needTip:NO];
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestRefresh:NO needTip:NO];
    }];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer.hidden = YES;
}

- (XKMessageActivityAndSpecialViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XKMessageActivityAndSpecialViewModel alloc]init];
    }
    return _viewModel;
}

- (void)requestRefresh:(BOOL)refresh needTip:(BOOL)needTip {
    if (needTip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestIsRefresh:refresh complete:^(NSString * _Nonnull error, NSArray * _Nonnull dataArray) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [weakSelf resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:dataArray];
        [weakSelf.tableView reloadData];
    }];
    
}
@end
