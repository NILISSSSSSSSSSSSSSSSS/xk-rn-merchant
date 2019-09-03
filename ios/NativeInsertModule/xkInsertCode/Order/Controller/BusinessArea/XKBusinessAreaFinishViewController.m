//
//  XKBusinessAreaFinishViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBusinessAreaFinishViewController.h"
#import "XKBusinessAreaFinishManyCell.h"
#import "XKBusinessAreaFinishSingleCell.h"
#import "XKSquareTradingAreaTool.h"
#import "XKBusinessAreaOrderListModel.h"


@interface XKBusinessAreaFinishViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) UIAlertController  *cancelAlert;
@property (nonatomic, assign) NSInteger          page;
@property (nonatomic, strong) NSMutableArray     *dataMuArr;
@property (nonatomic, strong) XKEmptyPlaceView   *emptyView;

@end

@implementation XKBusinessAreaFinishViewController

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
    
    [XKSquareTradingAreaTool tradingAreaOrderList:muDic orderType:MOT_FINISH success:^(NSArray<AreaOrderListModel *> *list) {
        [XKHudView hideHUDForView:self.view];
        [self.tableView stopRefreshing];
        [self handleSuccessData:list];
    } faile:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.view];
        [self.tableView stopRefreshing];
        if (self.page > 1) {
            self.page--;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    MallOrderListDataItem *item = _viewModel.dataArr[indexPath.row];
    //    return item.goods.count > 1 ? 175 : 190;
    return indexPath.section == 0 ? 190 : 175;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AreaOrderListModel *item = self.dataMuArr[indexPath.section];
    if(item.goods.count > 1) {
        XKBusinessAreaFinishManyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBusinessAreaFinishManyCell" forIndexPath:indexPath];
        [cell bindData:item];
        return cell;
    } else {
        XKBusinessAreaFinishSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBusinessAreaFinishSingleCell" forIndexPath:indexPath];
        [cell bindData:item];
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
    
    
    
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        CGFloat h = self.entryType == 0 ?  SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight : SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - TabBar_Height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKBusinessAreaFinishSingleCell class] forCellReuseIdentifier:@"XKBusinessAreaFinishSingleCell"];
        [_tableView registerClass:[XKBusinessAreaFinishManyCell class] forCellReuseIdentifier:@"XKBusinessAreaFinishManyCell"];
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
