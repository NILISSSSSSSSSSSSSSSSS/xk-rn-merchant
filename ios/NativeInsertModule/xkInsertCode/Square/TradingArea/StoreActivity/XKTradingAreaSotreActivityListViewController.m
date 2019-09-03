//
//  XKTradingAreaSotreActivityListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaSotreActivityListViewController.h"
#import "XKStoreActivityCouponTableViewCell.h"
#import "XKStoreActivityCardTableViewCell.h"
#import "XKSquareTradingAreaTool.h"
#import "XKStoreActivityListShopCardModel.h"
#import "XKStoreActivityListCouponModel.h"

@interface XKTradingAreaSotreActivityListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) NSMutableArray     *dataListArr;
@property (nonatomic, assign) NSInteger          page;
@property (nonatomic, strong) XKEmptyPlaceView   *emptyView;

@end

@implementation XKTradingAreaSotreActivityListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    self.navigationView.hidden = YES;
    [self configTableView];
    
    [self requestData];
}


#pragma mark - Private Metheods
- (void)configTableView {
    self.page = 1;
    XKWeakSelf(weakSelf);
    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    self.tableView.mj_header = narmalHeader;
    
    MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf requestData];
    }];
    [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = foot;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


#pragma mark - reuqest

- (void)requestData {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@(self.page) forKey:@"page"];
    [muDic setObject:@"10" forKey:@"limit"];
    [muDic setObject:self.shopId ? self.shopId : @"" forKey:@"shopId"];

    [XKHudView hideHUDForView:self.tableView];

    if (self.activityListType == ActivityListType_reward) {
//        [XKSquareTradingAreaTool tradingAreaShopRewardList:muDic success:^(NSArray<CategaryGoodsItem *> *listArr) {
//            [self successfulRequest:listArr];
//        } faile:^(XKHttpErrror *error) {
//            [self faileRequest];
//        }];
        
    } else if (self.activityListType == ActivityListType_coupon) {
        [XKSquareTradingAreaTool tradingAreaShopCouponList:muDic success:^(NSArray<CouponItemModel *> *listArr) {
            [self successfulRequest:listArr];
        } faile:^(XKHttpErrror *error) {
            [self faileRequest];
        }];
        
    } else {
        [XKSquareTradingAreaTool tradingAreaShopMemberList:muDic success:^(NSArray<ShopCardModel *> *listArr) {
            [self successfulRequest:listArr];
        } faile:^(XKHttpErrror *error) {
            [self faileRequest];
        }];
    }
}

- (void)successfulRequest:(NSArray *)listArr {
    [XKHudView hideHUDForView:self.tableView];

    if (!self.dataListArr) {
        self.dataListArr = [NSMutableArray array];
    }
    if (self.page == 1) {
        [self.dataListArr removeAllObjects];
    }
    if (!listArr.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.dataListArr addObjectsFromArray:listArr];
        if (listArr.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    if (self.dataListArr.count == 0) {
        self.emptyView.config.viewAllowTap = YES;
        XKWeakSelf(weakSelf);
        [self.emptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无相关数据" tapClick:^{
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    } else {
        [self.emptyView hide];
    }
    
    [self.tableView stopRefreshing];
    [self.tableView reloadData];
}

- (void)faileRequest {
    [self.tableView stopRefreshing];
    [self.tableView reloadData];
    if (self.page > 1) {
        self.page--;
    }
}

- (void)userDraw:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:[XKUserInfo getCurrentUserId] ? [XKUserInfo getCurrentUserId] : @"" forKey:@"userId"];
    [muDic setObject:self.shopId ? self.shopId : @"" forKey:@"shopId"];
    [XKHudView showLoadingTo:self.tableView animated:YES];
    if (self.activityListType == ActivityListType_reward) {
//        if (model.whetherDraw) {
//            return;
//        }
//        [muDic setObject:@"" forKey:@""];
//        [XKSquareTradingAreaTool tradingAreaShopRewardUserDraw:muDic success:^(id result) {
//        [XKHudView hideHUDForView:self.tableView];
//            model.whetherDraw = YES;
//            [self.dataListArr replaceObjectAtIndex:indexPath.row withObject:model];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        } faile:^(XKHttpErrror *error) {
//        [XKHudView hideHUDForView:self.tableView];
//        }];
        
    } else if (self.activityListType == ActivityListType_coupon) {
        CouponItemModel *model = self.dataListArr[indexPath.row];
        if (model.whetherDraw) {
            return;
        }
        [muDic setObject:model.couponId ? model.couponId : @"" forKey:@"couponId"];
        
        [XKSquareTradingAreaTool tradingAreaShopCouponUserDraw:muDic success:^(id result) {
            [XKHudView hideHUDForView:self.tableView];
            model.whetherDraw = YES;
            [self.dataListArr replaceObjectAtIndex:indexPath.row withObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } faile:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.tableView];
        }];
        
    } else {
        ShopCardModel *model = self.dataListArr[indexPath.row];
        if (model.whetherDraw) {
            return;
        }
        [muDic setObject:model.memberId ? model.memberId : @"" forKey:@"memberCardId"];

        [XKSquareTradingAreaTool tradingAreaShopMemberUserDraw:muDic success:^(id result) {
            [XKHudView hideHUDForView:self.tableView];
            model.whetherDraw = YES;
            [self.dataListArr replaceObjectAtIndex:indexPath.row withObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } faile:^(XKHttpErrror *error) {
            [XKHudView hideHUDForView:self.tableView];
        }];
    }
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.activityListType == ActivityListType_reward) {
        
        XKStoreActivityCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell"];
        if (!cell) {
            cell = [[XKStoreActivityCardTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cardCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
        
        
    } else if (self.activityListType == ActivityListType_coupon) {
        XKStoreActivityCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponCell"];
        if (!cell) {
            cell = [[XKStoreActivityCouponTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"couponCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setVauleWithModel:self.dataListArr[indexPath.row]];
        return cell;
        
    } else {
        
        XKStoreActivityCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell"];
        if (!cell) {
            cell = [[XKStoreActivityCardTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cardCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setVauleWithModel:self.dataListArr[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self userDraw:indexPath];
    
}



#pragma mark - lazy load

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

- (XKEmptyPlaceView *)emptyView {
    if (!_emptyView) {
        _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
    }
    return _emptyView;
}

@end
