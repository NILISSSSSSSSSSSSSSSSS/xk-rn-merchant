//
//  XKBusinessAreaOrderListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/11/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBusinessAreaOrderListViewController.h"
#import "XKBusinessAreaOrderListManyCell.h"
#import "XKBusinessAreaOrderListSingleCell.h"
#import "XKSquareTradingAreaTool.h"
#import "XKBusinessAreaOrderListModel.h"
#import "XKTradingAreaOrderDetailViewController.h"
#import "XKOrderEvaluationController.h"
@interface XKBusinessAreaOrderListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) UIAlertController  *cancelAlert;
@property (nonatomic, assign) NSInteger          page;
@property (nonatomic, strong) NSMutableArray     *dataMuArr;
@property (nonatomic, strong) XKEmptyPlaceView   *emptyView;

@end

@implementation XKBusinessAreaOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
//    [self requestDataWithTips:YES];
}

- (void)handleData {
    [super handleData];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.tableView];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
}

#pragma mark 网络请求
- (void)requestDataWithTips:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@(self.page) forKey:@"page"];
    [muDic setObject:@(10) forKey:@"limit"];
    if(self.page == 1) {
        [muDic setObject:[XKTimeSeparateHelper backTimestampSecondStringWithDate:[NSDate date]] forKey:@"lastUpdateAt"];
    }
    
    [XKSquareTradingAreaTool tradingAreaOrderList:muDic orderType:(NSUInteger)self.orderType success:^(NSArray<AreaOrderListModel *> *list) {
        [XKHudView hideHUDForView:self.view];
        [self.tableView stopRefreshing];
        [self handleSuccessData:list];
    } faile:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.view];
        [self.tableView stopRefreshing];
        if (self.page > 1) {
            self.page--;
        }
        XKWeakSelf(ws);
        if (self.dataMuArr.count == 0) {//无数据 请求第一页 请求出错
            self.emptyTipView.config.viewAllowTap = YES;
            [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [ws requestDataWithTips:YES];
            }];
        } else {//请求更多出错
            [self.emptyTipView hide];
            [XKHudView showErrorMessage:error.message];
        }
    }];
    
}

- (void)handleSuccessData:(NSArray <AreaOrderListModel *>*)list {
    if (self.page == 1) {
        [self.dataMuArr removeAllObjects];
    }
    if (!list.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.dataMuArr addObjectsFromArray:list];
        if (list.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    if (self.dataMuArr.count == 0) {
        self.emptyView.config.viewAllowTap = YES;
        XKWeakSelf(weakSelf);
        [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    } else {
        [self.emptyView hide];
    }
    
    [self.tableView reloadData];
}


#pragma mark 响应事件
- (void)detailBtnClick:(UIButton *)sender {
    
}

- (void)payBtnClick:(UIButton *)sender {
    
}

- (void)transportBtnClick:(UIButton *)sender {
    
}


#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMuArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    AreaOrderListModel *item = self.dataMuArr[indexPath.section];
    if(item.goods.count > 1) {
        XKBusinessAreaOrderListManyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBusinessAreaOrderListManyCell" forIndexPath:indexPath];
        cell.cellType = (NSUInteger)self.orderType;
        [cell bindData:item];
        cell.index = indexPath;
        cell.evluateBlock = ^(NSIndexPath *index) {
            AreaOrderListModel *item = self.dataMuArr[indexPath.section];
            XKOrderEvaluationController *evaluate = [XKOrderEvaluationController new];
            evaluate.model = item;
            evaluate.evaluationType = XKEvaluationTypeArea;
            [ws.navigationController pushViewController:evaluate animated:YES];
        };
        return cell;
        
    } else {
        XKBusinessAreaOrderListSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBusinessAreaOrderListSingleCell" forIndexPath:indexPath];
        cell.cellType = (NSUInteger)self.orderType;
        cell.index = indexPath;
        [cell bindData:item];
        cell.evluateBlock = ^(NSIndexPath *index) {
            AreaOrderListModel *item = self.dataMuArr[indexPath.section];
            XKOrderEvaluationController *evaluate = [XKOrderEvaluationController new];
            evaluate.evaluationType = XKEvaluationTypeArea;
            evaluate.model = item;
            [ws.navigationController pushViewController:evaluate animated:YES];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.dataMuArr.count - 1 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    AreaOrderListModel *item = self.dataMuArr[indexPath.section];
    XKTradingAreaOrderDetailViewController *vc = [[XKTradingAreaOrderDetailViewController alloc] init];
    vc.orderId = item.orderId;
    if (self.orderType == AreaOrderType_REFUND) {
        vc.isAfterSaleOrder = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        CGFloat h = self.entryType == 0 ?  SCREEN_HEIGHT - NavigationAndStatue_Height - 40 - 40 - kBottomSafeHeight: SCREEN_HEIGHT - NavigationAndStatue_Height  - TabBar_Height - 40 - 40;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKBusinessAreaOrderListSingleCell class] forCellReuseIdentifier:@"XKBusinessAreaOrderListSingleCell"];
        [_tableView registerClass:[XKBusinessAreaOrderListManyCell class] forCellReuseIdentifier:@"XKBusinessAreaOrderListManyCell"];
        XKWeakSelf(ws);
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            ws.page = 1;
            [ws requestDataWithTips:YES];
        }];
        _tableView.mj_header = narmalHeader;
        
        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            ws.page += 1;
            [ws requestDataWithTips:YES];
        }];
        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = foot;
        
        //
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (NSMutableArray *)dataMuArr {
    if (!_dataMuArr) {
        _dataMuArr = [NSMutableArray array];
    }
    return _dataMuArr;
}

- (XKEmptyPlaceView *)emptyView {
    if (!_emptyView) {
        _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    }
    return _emptyView;
}


@end
