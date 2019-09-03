//
//  XKTradingAreaMainListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaMainListViewController.h"
#import "XKSquareTradingAreaShopListCell.h"
#import "XKTradingAreaPullDownMenu.h"
#import "XKSquareTradingAreaTool.h"
#import "XKBaiduLocation.h"
#import "XKStoreRecommendViewController.h"

#import "XKTradingAreaSortModel.h"
#import "XKTradingAreaIndustyAllCategaryModel.h"
#import "XKTradingAreaShopListModel.h"

static NSString * const tradingAreaCellID   = @"TradingAreaCellId";

@interface XKTradingAreaMainListViewController ()<UITableViewDataSource, UITableViewDelegate, XKTradingAreaPullDownMenuDelegate>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray     *dataSource;
@property (nonatomic, assign) NSInteger          page;
@property (nonatomic, strong) XKEmptyPlaceView   *emptyView;

@property (nonatomic, assign) double            lat;
@property (nonatomic, assign) double            lng;

@property (nonatomic, assign) BOOL                   firstLoad;
@property (nonatomic, strong) XKTradingAreaSortModel *sortModel;
@property (nonatomic, strong) IndustyTwoLevelItem    *twoLeveModel;

@end

@implementation XKTradingAreaMainListViewController



#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    if (self.listVCType == TradingAreaMainListVC_topHeight84) {
        self.navigationView.hidden = YES;
    }

    self.firstLoad = YES;
    self.page = 1;
    
    if (self.sortArr.count || self.twoLeverArr.count) {
        if (self.sortArr.count) {
            self.sortModel = self.sortArr[0];
        }
//        if (self.twoLeverArr.count) {
//            self.twoLeveModel = self.twoLeverArr[0];
//        }
        [self configView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //重新选择了城市 需要刷新
    if ([[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude != self.lat || [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude != self.lng) {
        self.firstLoad = YES;
        self.page = 1;
    }
    self.lat = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude;
    self.lng = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude;
    
    if (self.sortArr.count || self.twoLeverArr.count) {
        if (self.firstLoad) {
            self.firstLoad = NO;
            [self requestAllData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - request
- (void)requestAllData {
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    
    [muDic setObject:@(self.page) forKey:@"page"];
    [muDic setObject:@"10" forKey:@"limit"];
    [muDic setObject:@(self.lat) forKey:@"lat"];
    [muDic setObject:@(self.lng) forKey:@"lng"];
    if (self.sortModel.type) {
        [muDic setObject:self.sortModel.type forKey:@"orderType"];
    }
    if (self.oneLeverCode) {
        [muDic setObject:self.oneLeverCode forKey:@"levelOneCode"];
    }
    if (self.twoLeveModel.code) {
        [muDic setObject:self.twoLeveModel.code forKey:@"levelTwoCode"];
    }
    
    [XKHudView showLoadingTo:self.tableView animated:YES];

    [XKSquareTradingAreaTool tradingAreaShopList:muDic success:^(NSArray<ShopListItem *> *listArr) {
        [self.tableView stopRefreshing];
        [XKHudView hideHUDForView:self.tableView];
        if (!self.dataSource) {
            self.dataSource = [NSMutableArray array];
        }
        if (self.page == 1) {
            [self.dataSource removeAllObjects];
        }
        if (!listArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.dataSource addObjectsFromArray:listArr];
            if (listArr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.dataSource.count == 0) {
            self.emptyView.config.viewAllowTap = NO;
            [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无相关数据" tapClick:nil];
        } else {
            [self.emptyView hide];
        }
        [self.tableView reloadData];
        
    } faile:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
        if (self.page > 1) {
            self.page--;
        }
    }];
    
}

#pragma mark - Events

#pragma mark - Private Metheods

- (void)configView {
    
    XKWeakSelf(weakSelf);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestAllData];
    }];
    self.tableView.mj_header = narmalHeader;
    
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf requestAllData];
    }];
    [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = foot;
    
    NSMutableArray *sortNameArr = [NSMutableArray array];
    NSMutableArray *leverNameArr = [NSMutableArray array];
    for (XKTradingAreaSortModel *item in self.sortArr) {
        [sortNameArr addObject:item.name];
    }
    for (IndustyTwoLevelItem *item in self.twoLeverArr) {
        [leverNameArr addObject:item.name];
    }
    [self.filterView setMenuDataArray:[NSMutableArray arrayWithObjects:sortNameArr, leverNameArr, nil]];
    [self.view addSubview:self.filterView];
    [self.filterView addSubview:self.tableView];
    //蒙版加到主tableview上面
    [self.filterView addPullMaskingView];
    [self.filterView addPullTableView];

    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.listVCType == TradingAreaMainListVC_nomal) {
            make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        } else if (self.listVCType == TradingAreaMainListVC_topHeight84) {
            make.top.equalTo(self.view).offset(0);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView).offset(44);
        make.left.right.bottom.equalTo(self.filterView);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
}



#pragma mark - UITableViewDelegate && UITableViewDataSoure


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSquareTradingAreaShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:tradingAreaCellID];
    if (!cell) {
        cell = [[XKSquareTradingAreaShopListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:tradingAreaCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xk_openClip = YES;
        cell.xk_radius = 5;
    }
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row == self.dataSource.count - 1) {
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    } else {
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    [cell setValueWithModle:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
    ShopListItem *item = self.dataSource[indexPath.row];
    vc.shopId = item.itemId;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)selectedTitleAtIndex:(NSInteger)index itemIndex:(NSInteger)itemIndex {
    [self.filterView selectedAtIndex:index items:itemIndex];
}

#pragma mark - Custom Delegates

- (void)selectedKeyWord:(NSString *)keyWord indexPath:(NSIndexPath *)indexPath currentMenuIndex:(NSInteger)index {
    
    if (index == 0) {//排序
        self.sortModel = self.sortArr[indexPath.row];
    } else if (index == 1) {//二级分类
        self.twoLeveModel = self.twoLeverArr[indexPath.row];
    }
    self.page = 1;
    [self requestAllData];
}

#pragma mark - Custom Block


#pragma mark - Getters and Setters

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

- (XKTradingAreaPullDownMenu *)filterView {
    if (!_filterView) {
        _filterView = [[XKTradingAreaPullDownMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) menuTitleArray:@[@"排序", @"二级类"]];
        _filterView.delegate = self;
    }
    return _filterView;
}


- (XKEmptyPlaceView *)emptyView {
    if (!_emptyView) {
        _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    }
    return _emptyView;
}

@end
