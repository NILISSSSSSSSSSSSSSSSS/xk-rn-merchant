//
//  XKMessageShoppingMallViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageShoppingMallViewController.h"
#import "XKMessageShoppingMallViewModel.h"

@interface XKMessageShoppingMallViewController ()
/**tableview*/
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) XKMessageShoppingMallViewModel *viewModel;

@end

@implementation XKMessageShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTable];
    [self requestRefresh:YES needTip:YES];
    if (self.type == XKShoppingSysMessageControllerType) {
        [self setNavTitle:@"自营商城消息" WithColor:[UIColor whiteColor]];
    }else if (self.type == XKMallSysMessageControllerType){
        [self setNavTitle:@"福利商城消息" WithColor:[UIColor whiteColor]];
    }else if (self.type == XKAreaSysMessageControllerType){
        [self setNavTitle:@"周边消息" WithColor:[UIColor whiteColor]];
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
    [self.view addSubview:self.tableView];
    self.viewModel.type = self.type;
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

- (XKMessageShoppingMallViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XKMessageShoppingMallViewModel alloc]init];
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
