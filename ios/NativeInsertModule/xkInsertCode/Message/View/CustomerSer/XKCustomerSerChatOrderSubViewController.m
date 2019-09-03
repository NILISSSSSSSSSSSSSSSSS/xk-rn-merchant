//
//  XKCustomerSerChatOrderSubViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCustomerSerChatOrderSubViewController.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKMallOrderViewModel.h"
#import "XKCustomerSerChatOrderTableViewCell.h"

@interface XKCustomerSerChatOrderSubViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger maxCount;

@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*selectedIndexPaths;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@end

@implementation XKCustomerSerChatOrderSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = XKSeparatorLineColor;
    [self.tableView registerClass:[XKCustomerSerChatOrderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKCustomerSerChatOrderTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.type == XKCustomerSerChatOrderSubVCTypeWelfare) {
            weakSelf.page = 1;
            [weakSelf postWelfareOrders];
        } else if (weakSelf.type == XKCustomerSerChatOrderSubVCTypePlatform) {
            weakSelf.page = 1;
            [weakSelf postPlatformOrders];
        }
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.datas.count >= weakSelf.maxCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        if (weakSelf.type == XKCustomerSerChatOrderSubVCTypeWelfare) {
            [weakSelf postWelfareOrders];
        } else if (weakSelf.type == XKCustomerSerChatOrderSubVCTypePlatform) {
            [weakSelf postPlatformOrders];
        }
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    self.emptyView.config.verticalOffset = -75.0;
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - POST

- (void)postWelfareOrders {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(1) forKey:@"page"];
    [para setObject:@(10) forKey:@"limit"];
    [para setObject:@(0) forKey:@"status"];
    [HTTPClient postEncryptRequestWithURLString:GetWelfareOrderListUrl timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.datas removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 0) {
                self.maxCount = [dict[@"total"] unsignedIntegerValue];
            }
            [self.datas addObjectsFromArray:[NSArray yy_modelArrayWithClass:[WelfareOrderDataItem class] json:dict[@"data"]]];
        }
        [self.tableView reloadData];
        if (self.datas.count) {
            [self.emptyView hide];
        } else {
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.datas.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postWelfareOrders];
            }];
        }
    }];
}

- (void)postPlatformOrders {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(1) forKey:@"page"];
    [para setObject:@(10) forKey:@"limit"];
//    [para setObject:@"" forKey:@"orderStatus"];
    [HTTPClient postEncryptRequestWithURLString:GetMallOrderListUrl timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.datas removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 0) {
                self.maxCount = [dict[@"total"] unsignedIntegerValue];
            }
            [self.datas addObjectsFromArray:[NSArray yy_modelArrayWithClass:[MallOrderListDataItem class] json:dict[@"data"]]];
        }
        [self.tableView reloadData];
        if (self.datas.count) {
            [self.emptyView hide];
        } else {
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.datas.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postWelfareOrders];
            }];
        }
    }];
}

#pragma mark - Public Methods

- (void)removeSelectedArray {
    [self.selectedIndexPaths removeAllObjects];
    [self.selectedArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKCustomerSerChatOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKCustomerSerChatOrderTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.type == XKCustomerSerChatOrderSubVCTypeWelfare) {
        [cell configCellWithWelfareOrder:self.datas[indexPath.row]];
    } else if (self.type == XKCustomerSerChatOrderSubVCTypePlatform) {
        [cell configCellWithPlatformOrder:self.datas[indexPath.row]];
    }
    [cell setCellSelected:[self.selectedIndexPaths containsObject:indexPath]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118 * ScreenScale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];
    } else {
        [self.selectedIndexPaths addObject:indexPath];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - getter setter

- (NSMutableArray *)selectedArray {
    NSMutableArray *array = [NSMutableArray array];
    [self.selectedIndexPaths sortUsingComparator:^NSComparisonResult(NSIndexPath   * _Nonnull obj1, NSIndexPath   * _Nonnull obj2) {
        return obj1.section > obj2.section || (obj1.section == obj2.section && obj1.row > obj2.row);
    }];
    for (NSIndexPath *indexpath in self.selectedIndexPaths) {
        [array addObject:self.datas[indexpath.row]];
    }
    return array;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray<NSIndexPath *> *)selectedIndexPaths {
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}

@end
