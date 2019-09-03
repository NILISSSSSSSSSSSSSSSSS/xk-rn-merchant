//
//  XKLatestSecretViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/24.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLatestSecretViewController.h"
#import "XKLatestSecretTableViewCell.h"
#import "XKLatestSecretModel.h"
#import "XKGrandPrizeDetailViewController.h"

@interface XKLatestSecretViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@property (nonatomic, strong) NSMutableArray *latestSecrets;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger latestSecretCount;

@end

@implementation XKLatestSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.vcType == XKLatestSecretVCTypeLatestSecret) {
        [self setNavTitle:@"最新揭秘" WithColor:[UIColor whiteColor]];
    } else if (self.vcType == XKLatestSecretVCTypeShopGrandPrize) {
        [self setNavTitle:@"店铺大奖" WithColor:[UIColor whiteColor]];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = HEX_RGB(0xf1f1f1);
    self.tableView.backgroundColor = HEX_RGB(0xf6f6f6);
    [self.tableView registerClass:[XKLatestSecretTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKLatestSecretTableViewCell class])];
    [self.containView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView);
    }];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postGrandPrizes];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.latestSecrets.count >= weakSelf.latestSecretCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postGrandPrizes];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.tableView.mj_footer = footer;
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    
    
    self.page = 1;
    [self postGrandPrizes];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController.viewControllers == nil ||
        self.navigationController.viewControllers.count == 0) {
        for (XKLatestSecretTableViewCell *cell in self.tableView.visibleCells) {
            [cell removeTimer];
        }
    }
}

#pragma mark - POST

- (void)postGrandPrizes {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.vcType == XKLatestSecretVCTypeLatestSecret) {
        
    } else if (self.vcType == XKLatestSecretVCTypeShopGrandPrize) {
        
    }
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.latestSecrets removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 1) {
                self.latestSecretCount = dict[@"total"] ? [dict[@"total"] integerValue] : 0;
            }
            [self.latestSecrets addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKLatestSecretModel class] json:dict[@"data"]]];
            [self.tableView reloadData];
        }
        if (self.latestSecrets.count) {
            [self.emptyView hide];
        } else {
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.latestSecrets.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postGrandPrizes];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.latestSecrets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKLatestSecretTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKLatestSecretTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XKLatestSecretModel *latestSecret = self.latestSecrets[indexPath.row];
    [cell configCellWithLatestSecretModel:latestSecret];
    if (self.latestSecrets.count == 1) {
        [cell cutCornerWithRoundedRect:CGRectMake(5.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 110.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
    } else if (indexPath.row == 0) {
        [cell cutCornerWithRoundedRect:CGRectMake(5.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 110.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
    } else if (indexPath.row == self.latestSecrets.count - 1) {
        [cell cutCornerWithRoundedRect:CGRectMake(5.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 110.0) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
    } else {
        [cell cutCornerWithRoundedRect:CGRectMake(5.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 110.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
    [vc creatWkWebViewWithMethodNameArray:@[] requestUrlString:@"http://www.bing.com"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter setter

- (NSMutableArray *)latestSecrets {
    if (!_latestSecrets) {
        _latestSecrets = [NSMutableArray array];
//        测试数据
        XKLatestSecretModel *latestSecret = [[XKLatestSecretModel alloc] init];
        latestSecret.openTimeStamp = 1546185600;
        [_latestSecrets addObjectsFromArray:@[latestSecret, latestSecret, latestSecret, latestSecret, latestSecret]];
    }
    return _latestSecrets;
}

@end
