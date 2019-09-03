//
//  XKMyLotteryTicketsSubViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyLotteryTicketsSubViewController.h"
#import "XKActivityTicketTableViewCell.h"
#import "XKPlatFormTicketTableViewCell.h"
#import "XKMerchantTicketTableViewCell.h"
#import "XKLotteryTicketModel.h"
#import "XKWelfareOrderDetailFinishViewController.h"
#import "XKWelfareOrderListViewModel.h"

@interface XKMyLotteryTicketsSubViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) XKEmptyPlaceView *emptyView;

@property (nonatomic, strong) NSMutableArray *lotteryTickets;


@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger lotteryTicketCount;

@end

@implementation XKMyLotteryTicketsSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HEX_RGB(0xF6F6F6);
    [self.tableView registerClass:[XKActivityTicketTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKActivityTicketTableViewCell class])];
    [self.tableView registerClass:[XKPlatFormTicketTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKPlatFormTicketTableViewCell class])];
    [self.tableView registerClass:[XKMerchantTicketTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKMerchantTicketTableViewCell class])];
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf postLotteryTickets];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.lotteryTickets.count > weakSelf.lotteryTicketCount) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postLotteryTickets];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了～" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    
    self.tableView.mj_footer = footer;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(7.5, 0.0, 0.0, 0.0));
    }];
    self.emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    self.emptyView.config.verticalOffset = -75.0;
    
    self.page = 1;
    [self postLotteryTickets];
}

#pragma mark - POST

- (void)postLotteryTickets {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [HTTPClient postEncryptRequestWithURLString:@"" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.lotteryTickets removeAllObjects];
        }
        if (responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            if (self.page == 1) {
                self.lotteryTicketCount = dict[@"total"] ? [dict[@"total"] integerValue] : 0;
            }
            [self.lotteryTickets addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKLotteryTicketModel class] json:dict[@"data"]]];
            [self.tableView reloadData];
        }
        if (self.lotteryTickets.count) {
            [self.emptyView hide];
        } else {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                [weakSelf postLotteryTickets];
            }];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.lotteryTickets.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyView.config.viewAllowTap = YES;
            [self.emptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postLotteryTickets];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lotteryTickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vcType == XKMyLotteryTicketsVCTypeActivity) {
//        活动券
        XKActivityTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKActivityTicketTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (self.vcType == XKMyLotteryTicketsVCTypePlatform) {
//        平台券
        XKPlatFormTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKPlatFormTicketTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
//        商铺券
        XKMerchantTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKMerchantTicketTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKWelfareOrderDetailFinishViewController *vc = [[XKWelfareOrderDetailFinishViewController alloc] init];
    WelfareOrderDataItem *item = [[WelfareOrderDataItem alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter setter

- (NSMutableArray *)lotteryTickets {
    if (!_lotteryTickets) {
        _lotteryTickets = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [_lotteryTickets addObject:[[XKLotteryTicketModel alloc] init]];
        }
    }
    return _lotteryTickets;
}


@end
