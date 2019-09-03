//
//  XKMineCouponPackageMainViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineCouponPackageMainViewController.h"
#import "UIView+XKCornerRadius.h"
#import "XKMineCouponPackageCompanyCardTableViewCell.h"
#import "XKMineCouponPackageTerminalCardTableViewCell.h"
#import "XKMineCouponPackageCompanyCouponTableViewCell.h"
#import "XKMineCouponPackageTerminalCouponTableViewCell.h"
#import "XKMineCouponPackageCardViewController.h"
#import "XKMineCouponPackageCouponViewController.h"
#import "XKMineCouponPackageCardModel.h"
#import "XKMineCouponPackageCouponModel.h"
#import "XKMineCouponPackageHeaderView.h"

@interface XKMineCouponPackageMainViewController () <UITableViewDelegate, UITableViewDataSource, XKMineCouponPackageHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

// 数据源
@property (nonatomic, strong) NSMutableArray *currentTableViewDataArr;
@property (nonatomic, strong) NSMutableArray *companyCardArr;
@property (nonatomic, strong) NSMutableArray *terminalCardArr;
@property (nonatomic, strong) NSMutableArray *companyCouponArr;
@property (nonatomic, strong) NSMutableArray *terminalCouponArr;
@property (nonatomic, assign) NSInteger companyCardPage;
@property (nonatomic, assign) NSInteger terminalCardPage;
@property (nonatomic, assign) NSInteger companyCouponPage;
@property (nonatomic, assign) NSInteger terminalCouponPage;
@property (nonatomic, assign) BOOL isCompanyCardHaveData;
@property (nonatomic, assign) BOOL isTerminalCardHaveData;
@property (nonatomic, assign) BOOL isCompanyCouponHaveData;
@property (nonatomic, assign) BOOL isTerminalCouponHaveData;

@end

@implementation XKMineCouponPackageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViews];
    
    self.companyCardPage = 1;
    self.terminalCardPage = 1;
    self.companyCouponPage = 1;
    self.terminalCouponPage = 1;
    
    [self getCardAndCouponCount];
    [self loadViewData:self.currentTimeType filterType:self.currentFilterType isBackgroundLoad:NO];
    [self loadViewData:self.currentTimeType filterType:XKMineCouponPackageMainViewControllerFilterTypeTerminalCard isBackgroundLoad:YES];
    [self loadViewData:self.currentTimeType filterType:XKMineCouponPackageMainViewControllerFilterTypeCompanyCoupon isBackgroundLoad:YES];
    [self loadViewData:self.currentTimeType filterType:XKMineCouponPackageMainViewControllerFilterTypeTerminalCoupon isBackgroundLoad:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentTableViewDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject *item = self.currentTableViewDataArr[indexPath.row];
    if ([item isKindOfClass:[XKMineCouponPackageCardItem class]]) {
        return 120.0;
    } else {
        return 110.0;
    }
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    XKMineCouponPackageHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XKMineCouponPackageHeaderView"];
    header.delegate = self;
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject *item = self.currentTableViewDataArr[indexPath.row];
    
    if (self.currentTableViewDataArr == self.companyCardArr) {
        XKMineCouponPackageCardItem *cardItem = (XKMineCouponPackageCardItem *)item;
        XKMineCouponPackageCompanyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCardTableViewCell" forIndexPath:indexPath];
        [cell configCellWithModel:cardItem];
        cell.indexPath = indexPath;
        [cell hiddenSelectButton];
        [cell hiddenCountChangeView];
        [cell hiddenCountLabel];
        return cell;
        
    } else if (self.currentTableViewDataArr == self.terminalCardArr) {
        XKMineCouponPackageCardItem *cardItem = (XKMineCouponPackageCardItem *)item;
        XKMineCouponPackageTerminalCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCardTableViewCell" forIndexPath:indexPath];
        [cell configCellWithModel:cardItem];
        cell.indexPath = indexPath;
        [cell hiddenSelectButton];
        [cell hiddenCountChangeView];
        [cell hiddenCountLabel];
        return cell;
        
    } else if (self.currentTableViewDataArr == self.companyCouponArr) {
        XKMineCouponPackageCouponItem *couponItem = (XKMineCouponPackageCouponItem *)item;
        XKMineCouponPackageCompanyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageCompanyCouponTableViewCell" forIndexPath:indexPath];
        [cell configCellWithModel:couponItem];
        cell.indexPath = indexPath;
        [cell hiddenSelectButton];
        [cell hiddenCountChangeView];
        [cell hiddenCountLabel];
        return cell;
        
    } else {
        XKMineCouponPackageCouponItem *couponItem = (XKMineCouponPackageCouponItem *)item;
        XKMineCouponPackageTerminalCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMineCouponPackageTerminalCouponTableViewCell" forIndexPath:indexPath];
        [cell configCellWithModel:couponItem];
        cell.indexPath = indexPath;
        [cell hiddenSelectButton];
        [cell hiddenCountChangeView];
        [cell hiddenCountLabel];
        return cell;
    }
}

#pragma mark - XKMineCouponPackageHeaderViewDelegate
/** 点击【折扣卡】 */
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickCard:(UIControl *)sender {
    
    XKMineCouponPackageCardViewController *couponPackageCardViewController = [XKMineCouponPackageCardViewController new];
    [self.navigationController pushViewController:couponPackageCardViewController animated:YES];
}

/** 点击【优惠券】 */
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickCoupon:(UIControl *)sender {
    
    XKMineCouponPackageCouponViewController *couponPackageCouponViewController = [XKMineCouponPackageCouponViewController new];
    [self.navigationController pushViewController:couponPackageCouponViewController animated:YES];
}

/** 点击【最近领取】 */
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickRecentControl:(UIControl *)sender {
    
    [self remakeFilterArr:XKMineCouponPackageMainViewControllerCurrentTimeTypeRecent];
    self.currentTimeType = XKMineCouponPackageMainViewControllerCurrentTimeTypeRecent;
}

/** 点击【即将失效】 */
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickOldControl:(UIControl *)sender {
    
    [self remakeFilterArr:XKMineCouponPackageMainViewControllerCurrentTimeTypeOld];
    self.currentTimeType = XKMineCouponPackageMainViewControllerCurrentTimeTypeOld;
}

/** 点击【筛选按钮】 */
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickCardOrCouponTypeButton:(UIButton *)button {
    
    NSString *titleString = button.titleLabel.text;
    if ([titleString isEqualToString:@"晓可卡"]) {
        self.currentTableViewDataArr = self.companyCardArr;
    } else if ([titleString isEqualToString:@"商户卡"]) {
        self.currentTableViewDataArr = self.terminalCardArr;
    } else if ([titleString isEqualToString:@"优惠券"]) {
        self.currentTableViewDataArr = self.companyCouponArr;
    } else if ([titleString isEqualToString:@"商户券"]) {
        self.currentTableViewDataArr = self.terminalCouponArr;
    }
    [self.tableView reloadData];
}

#pragma mark - private methods

/** 初始化视图 */
- (void)initializeViews {

    self.view.backgroundColor = HEX_RGB(0xF6F6F6);
    [self setNavTitle:@"红包卡券" WithColor:[UIColor whiteColor]];
    [self hideNavigationSeperateLine];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView registerClass:[XKMineCouponPackageHeaderView class] forHeaderFooterViewReuseIdentifier:@"XKMineCouponPackageHeaderView"];
    [self.tableView registerClass:[XKMineCouponPackageCompanyCardTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageCompanyCardTableViewCell"];
    [self.tableView registerClass:[XKMineCouponPackageTerminalCardTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageTerminalCardTableViewCell"];
    [self.tableView registerClass:[XKMineCouponPackageCompanyCouponTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageCompanyCouponTableViewCell"];
    [self.tableView registerClass:[XKMineCouponPackageTerminalCouponTableViewCell class] forCellReuseIdentifier:@"XKMineCouponPackageTerminalCouponTableViewCell"];
}

/** 重构筛选数组 */
- (void)remakeFilterArr:(XKMineCouponPackageMainViewControllerCurrentTimeType)timeType {
    
    self.companyCardArr = @[].mutableCopy;
    self.terminalCardArr = @[].mutableCopy;
    self.companyCouponArr = @[].mutableCopy;
    self.terminalCouponArr = @[].mutableCopy;
    self.currentTableViewDataArr = @[].mutableCopy;
    [self.tableView reloadData];
    
    self.companyCardPage = 1;
    self.terminalCardPage = 1;
    self.companyCouponPage = 1;
    self.terminalCouponPage = 1;
    
    [self loadViewData:timeType filterType:self.currentFilterType isBackgroundLoad:NO];
    [self loadViewData:timeType filterType:XKMineCouponPackageMainViewControllerFilterTypeTerminalCard isBackgroundLoad:YES];
    [self loadViewData:timeType filterType:XKMineCouponPackageMainViewControllerFilterTypeCompanyCoupon isBackgroundLoad:YES];
    [self loadViewData:timeType filterType:XKMineCouponPackageMainViewControllerFilterTypeTerminalCoupon isBackgroundLoad:YES];
}

/** 获取会员卡及优惠券数量 */
- (void)getCardAndCouponCount {
    
    NSDictionary *params = @{@"type": @(1)};
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetCardAndCouponCountUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView];
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        XKMineCouponPackageHeaderView *headerView = (XKMineCouponPackageHeaderView *)[self.tableView headerViewForSection:0];
        [headerView configHeaderViewWithCountDictionary:dict];
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
  }];
}

/** 获取列表数据 */
- (void)loadViewData:(XKMineCouponPackageMainViewControllerCurrentTimeType)timeType filterType:(XKMineCouponPackageMainViewControllerFilterType)filterType isBackgroundLoad:(BOOL)isBackgroundLoad {
    
    NSInteger type;
    NSString *urlString;
    NSString *xkModule;
    NSInteger page;
    NSDictionary *coupon;
    NSMutableArray *tempDataArr = @[].mutableCopy;
    
    // 最近
    if (timeType == XKMineCouponPackageMainViewControllerCurrentTimeTypeRecent) {
        type = 1;
        
    // 即将过期
    } else {
        type = 2;
    }
    
    switch (filterType) {
            
        // 晓可卡
        case XKMineCouponPackageMainViewControllerFilterTypeCompanyCard: {
            urlString = GetCardListUrl;
            xkModule = @"mall";
            page = self.companyCardPage;
            tempDataArr = self.companyCardArr;
            break;
        }
            
        // 商户卡
        case XKMineCouponPackageMainViewControllerFilterTypeTerminalCard: {
            urlString = GetCardListUrl;
            xkModule = @"shop";
            page = self.terminalCardPage;
            tempDataArr = self.terminalCardArr;
            break;
        }
            
        // 晓可券
        case XKMineCouponPackageMainViewControllerFilterTypeCompanyCoupon: {
            urlString = GetCouponListUrl;
            xkModule = @"mall";
            page = self.companyCouponPage;
            tempDataArr = self.companyCouponArr;
            break;
        }
            
        // 商户券
        case XKMineCouponPackageMainViewControllerFilterTypeTerminalCoupon: {
            urlString = GetCouponListUrl;
            xkModule = @"shop";
            page = self.terminalCouponPage;
            tempDataArr = self.terminalCouponArr;
            break;
        }
    }
    
    coupon = @{@"xkModule": xkModule,
               @"type": @(type)};
    
    // 组装参数
    NSDictionary *params = @{@"limit": @(10),
                             @"page": @(page),
                             @"coupon": coupon};
    
    // 发送请求
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:urlString timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        
        [XKHudView hideHUDForView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (page == 1) {
            [tempDataArr removeAllObjects];
        }
        
        switch (filterType) {
            // 晓可卡
            case XKMineCouponPackageMainViewControllerFilterTypeCompanyCard: {
                
                
                
                // yuan'mock
                XKMineCouponPackageCardItem *cardItem = [XKMineCouponPackageCardItem new];
                cardItem.cardType = @"GENERAL";
                cardItem.discount = @"0.1";
                cardItem.invalidTime = 1538327520;
                cardItem.validTime = 1000000000;
                cardItem.memberId = @"5ba899ea84912c1e90acee6d";
                cardItem.message = @"XXX";
                cardItem.name = @"普通";
                cardItem.storeId = @"123123123";
                cardItem.storeName = @"asdfsdf";
                cardItem.userMemberId = @"123213";
                [tempDataArr addObject:cardItem];
                
                
//                XKMineCouponPackageCardModel *model =  [XKMineCouponPackageCardModel yy_modelWithJSON:responseObject];
//                [tempDataArr addObjectsFromArray:model.data];
//                self.companyCardPage++;
//                if (model.data.count < 10) {
//                    self.isCompanyCardHaveData = NO;
//                } else {
//                    self.isCompanyCardHaveData = YES;
//                }
                break;
            }
                
            // 商户卡
            case XKMineCouponPackageMainViewControllerFilterTypeTerminalCard: {
                
                
                // yuan'mock
                XKMineCouponPackageCardItem *cardItem = [XKMineCouponPackageCardItem new];
                cardItem.cardType = @"GENERAL";
                cardItem.discount = @"0.1";
                cardItem.invalidTime = 1538327520;
                cardItem.validTime = 1000000000;
                cardItem.memberId = @"5ba899ea84912c1e90acee6d";
                cardItem.message = @"XXX";
                cardItem.name = @"普通";
                cardItem.storeId = @"123123123";
                cardItem.storeName = @"asdfsdf";
                cardItem.userMemberId = @"123213";
                [tempDataArr addObject:cardItem];
                
                
                
                
//                XKMineCouponPackageCardModel *model =  [XKMineCouponPackageCardModel yy_modelWithJSON:responseObject];
//                [tempDataArr addObjectsFromArray:model.data];
//                self.terminalCardPage++;
//                if (model.data.count < 10) {
//                    self.isTerminalCardHaveData = NO;
//                } else {
//                    self.isTerminalCardHaveData = YES;
//                }
                break;
            }
                
            // 晓可券
            case XKMineCouponPackageMainViewControllerFilterTypeCompanyCoupon: {
                
                // yuan'mock
//                XKMineCouponPackageCouponItem *couponItem = [XKMineCouponPackageCouponItem new];
//                couponItem.couponId = @"12323";
//                couponItem.invalidTime = 1538327520;
//                couponItem.message = @"XXX";
//                couponItem.couponName = @"yuan test";
//                couponItem.price = @"1";
//                couponItem.couponType = @"DISCOUNT";
//                couponItem.validTime = 1538190710;
//                couponItem.userCouponId = @"52";
//                [tempDataArr addObject:couponItem];
                
                XKMineCouponPackageCouponModel *model =  [XKMineCouponPackageCouponModel yy_modelWithJSON:responseObject];
                for (XKMineCouponPackageCouponModelDataItem *dataItem in model.data) {
                    [tempDataArr addObjectsFromArray:dataItem.coupons];
                }
                self.companyCouponPage++;
                if (model.data.count < 10) {
                    self.isCompanyCouponHaveData = NO;
                } else {
                    self.isCompanyCouponHaveData = YES;
                }
                break;
            }
                
            // 商户券
            case XKMineCouponPackageMainViewControllerFilterTypeTerminalCoupon: {
                
                // yuan'mock
//                XKMineCouponPackageCouponItem *couponItem = [XKMineCouponPackageCouponItem new];
//                couponItem.couponId = @"12323";
//                couponItem.invalidTime = 1538327520;
//                couponItem.message = @"XXX";
//                couponItem.couponName = @"测试商户券";
//                couponItem.price = @"1";
//                couponItem.couponType = @"DISCOUNT";
//                couponItem.validTime = 1538190710;
//                couponItem.userCouponId = @"52";
//                [tempDataArr addObject:couponItem];
                
                XKMineCouponPackageCouponModel *model =  [XKMineCouponPackageCouponModel yy_modelWithJSON:responseObject];
                for (XKMineCouponPackageCouponModelDataItem *dataItem in model.data) {
                    [tempDataArr addObjectsFromArray:dataItem.coupons];
                }
                self.terminalCouponPage++;
                if (model.data.count < 10) {
                    self.isTerminalCouponHaveData = NO;
                } else {
                    self.isTerminalCouponHaveData = YES;
                }
                break;
            }
        }
        
        // 后台加载
        if (isBackgroundLoad) {
            
            return;
        } else {
            self.currentTableViewDataArr = tempDataArr;
            [self reloadTableViewFooter];
            [self.tableView reloadData];
        }
        
        
    } failure:^(XKHttpErrror *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [XKHudView hideHUDForView:self.tableView];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
        self.tableView.mj_footer.hidden = YES;
    }];
    
}

- (void)reloadTableViewFooter {
    
    BOOL isHaveData;
    switch (self.currentFilterType) {
        case XKMineCouponPackageMainViewControllerFilterTypeCompanyCard: {
            isHaveData = self.isCompanyCardHaveData;
            break;
        }
        case XKMineCouponPackageMainViewControllerFilterTypeTerminalCard: {
            isHaveData = self.isTerminalCardHaveData;
            break;
        }
        case XKMineCouponPackageMainViewControllerFilterTypeCompanyCoupon: {
            isHaveData = self.isCompanyCouponHaveData;
            break;
        }
        case XKMineCouponPackageMainViewControllerFilterTypeTerminalCoupon: {
            isHaveData = self.isTerminalCouponHaveData;
            break;
        }
    }
    if (isHaveData) {
        [self.tableView.mj_footer resetNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - setter and getter

/** 初始化底部卡券列表 */
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEX_RGB(0xF6F6F6);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        __weak typeof(self) weakSelf = self;
        // 下拉刷新 & 上拉加载
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            switch (weakSelf.currentFilterType) {
                case XKMineCouponPackageMainViewControllerFilterTypeCompanyCard: {
                    weakSelf.companyCardPage = 1;
                    break;
                }
                case XKMineCouponPackageMainViewControllerFilterTypeTerminalCard: {
                    weakSelf.terminalCardPage = 1;
                    break;
                }
                case XKMineCouponPackageMainViewControllerFilterTypeCompanyCoupon: {
                    weakSelf.companyCouponPage = 1;
                    break;
                }
                case XKMineCouponPackageMainViewControllerFilterTypeTerminalCoupon: {
                    weakSelf.terminalCouponPage = 1;
                    break;
                }
            }
            [weakSelf loadViewData:weakSelf.currentTimeType filterType:weakSelf.currentFilterType isBackgroundLoad:NO];
        }];
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadViewData:weakSelf.currentTimeType filterType:weakSelf.currentFilterType isBackgroundLoad:NO];
        }];
        [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (NSMutableArray *)currentTableViewDataArr {
    
    if (!_currentTableViewDataArr) {
        _currentTableViewDataArr = @[].mutableCopy;
    }
    return _currentTableViewDataArr;
}

- (NSMutableArray *)companyCardArr {
    
    if (!_companyCardArr) {
        _companyCardArr = @[].mutableCopy;
    }
    return _companyCardArr;
}

- (NSMutableArray *)terminalCardArr {
    
    if (!_terminalCardArr) {
        _terminalCardArr = @[].mutableCopy;
    }
    return _terminalCardArr;
}

- (NSMutableArray *)companyCouponArr {
    
    if (!_companyCouponArr) {
        _companyCouponArr = @[].mutableCopy;
    }
    return _companyCouponArr;
}

- (NSMutableArray *)terminalCouponArr {
    
    if (!_terminalCouponArr) {
        _terminalCouponArr = @[].mutableCopy;
    }
    return _terminalCouponArr;
}

@end
