//
//  XKMineMainViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineMainViewController.h"
#import "XKMineMainViewProductionTableViewCell.h"
#import "XKMineSettingRootViewController.h"
#import "XKMineCollectRootViewController.h"
#import "XKMineFansListController.h"
#import "XKCoinViewController.h"
#import "XKConsumeCouponViewController.h"
#import "XKMyGiftRootController.h"
#import "XKMineCouponPackageMainViewController.h"
#import "XKMyPraiseRootController.h"
#import "XKMineCommentRootController.h"
#import "XKWelfareOrderViewController.h"
#import "XKMineMainViewSocialContactTableHeaderView.h"
#import "XKMineMainViewProductionTableHeaderView.h"
#import "XKMineMainViewTableFooterView.h"
#import "CYLConstants.h"
#import "XKPersonalDataModel.h"
#import "XKWelfareGoodsListViewModel.h"
#import "XKVideoDisplayModel.h"
#import "XKMallGoodsDetailViewController.h"
#import "XKMineFocusListController.h"
#import "XKVideoDisplayMediator.h"
#import "XKMyWinningRecordsViewController.h"
#import "XKMineRedEnvelopeRecordsViewController.h"
// yuan'mock
#import "XKPayPasswordInputViewController.h"

static const CGFloat kMineMainViewControllerSocialContactViewHeight = 362;

NSString *const kMineMainViewProductionTableViewCell = @"XKMineMainViewProductionTableViewCell";
NSString *const kMineMainViewSocialContactTableHeaderView = @"XKMineMainViewSocialContactTableHeaderView";
NSString *const kMineMainViewProductionTableHeaderView = @"XKMineMainViewProductionTableHeaderView";
NSString *const kMineMainViewTableFooterView = @"XKMineMainViewTableFooterView";

@interface XKMineMainViewController () <UITableViewDelegate, UITableViewDataSource, XKMineMainViewSocialContactTableHeaderViewDelegate, XKMineMainViewProductionTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XKMineMainViewSocialContactTableHeaderView *socialContactTableHeaderView;

@property (nonatomic, strong) XKPersonalDataModel *personalDataModel;
@property (nonatomic, strong) NSDictionary *socialContactCountDict;
@property (nonatomic, strong) NSMutableArray *myProductionListArr;
@property (nonatomic, assign) NSInteger myProductionListCurrentPage;
@property (nonatomic, assign) CGFloat myProductionCellHeight;

@end

@implementation XKMineMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.hidden = YES;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取登录用户信息
    [self getUserInfo];
    
    // 获取社交模块信息
    [self getSocialContactData];
    
    // 获取我的作品列表
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    self.myProductionListCurrentPage = 0;
    self.myProductionCellHeight = SCREEN_HEIGHT - kIphoneXNavi(kMineMainViewControllerSocialContactViewHeight);
    [self getProductionListWithPage:self.myProductionListCurrentPage];
//    });
    
    [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate

// 根据scrollView滚动缩放区头视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = 0;
    if (scrollView.mj_offsetY > 0) {//向上移动
        y = 0;
    } else {//向下移动
        y = scrollView.mj_offsetY;
    }
   [self.socialContactTableHeaderView configHeaderViewBackgroundImageWithY:y];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return kIphoneXNavi(kMineMainViewControllerSocialContactViewHeight);
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 0;
    } else {
        return self.myProductionCellHeight;
    }
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.socialContactTableHeaderView == nil) {
            XKMineMainViewSocialContactTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMineMainViewSocialContactTableHeaderView];
            headerView.delegate = self;
            self.socialContactTableHeaderView = headerView;
        }
        [self.socialContactTableHeaderView configHeaderViewWithPersonalDataModel:self.personalDataModel];
        [self.socialContactTableHeaderView configHeaderViewWithSocialContactCountDict:self.socialContactCountDict];
        return self.socialContactTableHeaderView;
    } else {
        XKMineMainViewProductionTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMineMainViewProductionTableHeaderView];
        return headerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return nil;
    } else {
        XKMineMainViewProductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineMainViewProductionTableViewCell forIndexPath:indexPath];
        cell.delegate = self;
        [cell configCellWithProductionListArray:self.myProductionListArr.copy collectionViewHeight:self.myProductionCellHeight];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XKMineMainViewTableFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMineMainViewTableFooterView];
    return footerView;
}

#pragma mark - XKMineMainViewSocialContactTableHeaderViewDelegate

/** 点击浏览历史 */
- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickHistoryButton:(UIButton *)sender {
    
    // yuan'mock
//    [XKPayPasswordInputViewController showPayPasswordInputViewController:self];
//        return;
    
    XKMineCollectRootViewController *mineCollectRootViewController = [XKMineCollectRootViewController new];
    mineCollectRootViewController.hidesBottomBarWhenPushed = YES;
    mineCollectRootViewController.controllerType = XKBrowseControllerType;
    [self.navigationController pushViewController:mineCollectRootViewController animated:YES];
}

/** 点击设置 */
- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickSettingButton:(UIButton *)sender {
    
    // yuan'mock
//    [XKPayPasswordInputViewController showPayPasswordInputViewController:self];
//    return;
    
    XKMineSettingRootViewController *mineSettingRootViewController = [XKMineSettingRootViewController new];
    mineSettingRootViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineSettingRootViewController animated:YES];
}

/** 点击社交模块 */
- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickSocialContactControls:(XKMineMainViewSocialContactTableHeaderViewSocialContactControlsState)state {
    
    switch (state) {
        case XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateFans: {
            XKMineFansListController *mineFansListController = [XKMineFansListController new];
            mineFansListController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mineFansListController animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStatePraise: {
            XKMyPraiseRootController *myPraiseRootController = [XKMyPraiseRootController new];
            myPraiseRootController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myPraiseRootController animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStatedFocus: {
            XKMineFocusListController *focusVC = [[XKMineFocusListController alloc] init];
            focusVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:focusVC animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateCollect: {
            XKMineCollectRootViewController *mineCollectRootViewController = [XKMineCollectRootViewController new];
            mineCollectRootViewController.hidesBottomBarWhenPushed = YES;
            mineCollectRootViewController.controllerType = XKCollectControllerCollectType;
            [self.navigationController pushViewController:mineCollectRootViewController animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewSocialContactControlsStateComment: {
            XKMineCommentRootController *mineCommentRootController = [XKMineCommentRootController new];
            mineCommentRootController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mineCommentRootController animated:YES];
            break;
        }
    }
}

/** 点击消耗品模块 */
- (void)socialContactTableHeaderView:(UITableViewHeaderFooterView *)headerView clickConsumablesControls:(XKMineMainViewSocialContactTableHeaderViewConsumablesControlsState)state {
    
    switch (state) {
        case XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateCouponPackage: {
            XKMineCouponPackageMainViewController *mineCouponPackageMainViewController = [XKMineCouponPackageMainViewController new];
            mineCouponPackageMainViewController.currentTimeType = XKMineCouponPackageMainViewControllerCurrentTimeTypeRecent;
            mineCouponPackageMainViewController.currentFilterType = XKMineCouponPackageMainViewControllerFilterTypeCompanyCard;
            mineCouponPackageMainViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mineCouponPackageMainViewController animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateCoin: {
            XKCoinViewController *coinViewController = [XKCoinViewController new];
            coinViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:coinViewController animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateConsume: {
            XKConsumeCouponViewController *consumeCouponViewController = [XKConsumeCouponViewController new];
            consumeCouponViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:consumeCouponViewController animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateMyGift: {
            XKMyGiftRootController *myGiftRootController = [XKMyGiftRootController new];
            myGiftRootController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myGiftRootController animated:YES];
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateWinningRecords: {
            XKMyWinningRecordsViewController *myWinningRecordsViewController = [XKMyWinningRecordsViewController new];
            myWinningRecordsViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myWinningRecordsViewController animated:YES];
            
            break;
        }
        case XKMineMainViewSocialContactTableHeaderViewConsumablesControlsStateRedEnvelope: {
            XKMineRedEnvelopeRecordsViewController *mineRedEnvelopeRecordsViewController = [XKMineRedEnvelopeRecordsViewController new];
            mineRedEnvelopeRecordsViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mineRedEnvelopeRecordsViewController animated:YES];
            break;
        }
    }
}

#pragma mark - XKMineMainViewProductionTableViewCellDelegate

/** 刷新我的作品collectionView高度 */
- (void)productionTableViewCellReloadCollectionViewHeight:(CGFloat)cellHeight {
    
    self.myProductionCellHeight = cellHeight;
    [self.tableView reloadData];
}

/** 点击我的作品中视频 */
- (void)productionTableViewCell:(UITableViewCell *)cell clickProductionWithModel:(XKVideoDisplayVideoListItemModel *)model {
    [XKVideoDisplayMediator displaySingleVideoWithViewController:self videoListItemModel:model];
}

#pragma mark - events

#pragma mark - private method

/** 获取登录用户信息 */
- (void)getUserInfo {
    
    XKUserInfo *userInfo = [XKUserInfo currentUser];
    self.personalDataModel = [XKPersonalDataModel new];
    self.personalDataModel.uid = userInfo.uid;
    self.personalDataModel.nickname = userInfo.nickname;
    self.personalDataModel.signature = userInfo.signature;
    self.personalDataModel.avatar = userInfo.avatar;
    [self.tableView reloadData];
}

/** 获取社交模块信息 */
- (void)getSocialContactData {
    
    [HTTPClient postEncryptRequestWithURLString:GetSocialContactCountUrl timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        self.socialContactCountDict = dict;
        [self.tableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:@"获取数量失败"];
    }];
}

/** 获取我的作品列表 */
- (void)getProductionListWithPage:(NSInteger)page {
    
    // yuan'mock
//    NSDictionary *getProductionListParamsDict = @{@"limit": @(10),
//                                                   @"page": @(self.myProductionListCurrentPage),
//                                                 @"userId":@"5bc6ac490334552e19341bc4"};

    NSDictionary *getProductionListParamsDict = @{@"limit": @(10),
                                                  @"page": @(self.myProductionListCurrentPage)};
    [XKZBHTTPClient postRequestWithURLString:GetMyProductListUrl timeoutInterval:20.0 parameters:getProductionListParamsDict success:^(id responseObject) {
        
        XKVideoDisplayModel *model = [XKVideoDisplayModel yy_modelWithJSON:responseObject];
        NSArray *videoList = model.body.video_list;
        
        // 更新数据
        if (self.myProductionListCurrentPage == 0) {
            [self.myProductionListArr removeAllObjects];
        }
        [self.myProductionListArr addObjectsFromArray:videoList];
        
        // 区脚状态
        if (!self.myProductionListArr || self.myProductionListArr.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            if (videoList.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
}

#pragma mark - setter and getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.containView.backgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[XKMineMainViewProductionTableViewCell class] forCellReuseIdentifier:kMineMainViewProductionTableViewCell];
        [_tableView registerClass:[XKMineMainViewSocialContactTableHeaderView class] forHeaderFooterViewReuseIdentifier:kMineMainViewSocialContactTableHeaderView];
        [_tableView registerClass:[XKMineMainViewProductionTableHeaderView class] forHeaderFooterViewReuseIdentifier:kMineMainViewProductionTableHeaderView];
        [_tableView registerClass:[XKMineMainViewTableFooterView class] forHeaderFooterViewReuseIdentifier:kMineMainViewTableFooterView];
        
        // 上拉加载
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.myProductionListCurrentPage++;
            [self getProductionListWithPage:self.myProductionListCurrentPage];
        }];
        [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
        [footer setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
        self.tableView.mj_footer = footer;
    }
    return _tableView;
}

- (NSMutableArray *)myProductionListArr {
    
    if (!_myProductionListArr) {
        _myProductionListArr = @[].mutableCopy;
    }
    return _myProductionListArr;
}

// ABANDON
//#import "XKMineMainViewStoreTableViewCell.h"
//#import "XKMineMainViewStoreTableHeaderView.h"

//NSString *const kMineMainViewStoreTableViewCell = @"XKMineMainViewStoreTableViewCell";
//NSString *const kMineMainViewStoreTableHeaderView = @"XKMineMainViewStoreTableHeaderView";


//@property (nonatomic, strong) NSMutableArray *storeMerchListArr;


// 获取福利商城商品列表
//    [self getWelfareGoodsListWithPage:1];


// 解决tableView未覆盖状态栏
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }

//    return 3;
//
//    if (self.myProductionListArr.count == 0) {
//        return 1;
//    } else {
//        return 2;
//    }

//    if (indexPath.section == 0) {
//        return 0;
//    } else if (indexPath.section == 1) {
//        return 134;
//    } else {
//        return self.myProductionCellHeight;
//    }

//    } else if (section == 1) {
//        XKMineMainViewStoreTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMineMainViewStoreTableHeaderView];
//        headerView.delegate = self;
//        return headerView;

//    } else if (indexPath.section == 1) {
//        XKMineMainViewStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineMainViewStoreTableViewCell forIndexPath:indexPath];
//        cell.delegate = self;
//        [cell configCellWithMerchListArray:self.storeMerchListArr.copy];
//        return cell;


#pragma mark - XKMineMainViewStoreTableHeaderViewDelegate

/** 点击获奖记录 */
//- (void)storeTableHeaderView:(UITableViewHeaderFooterView *)headerView clickWinningRecordsButton:(UIButton *)sender {
//
//    XKWelfareOrderViewController *welfareOrderViewController = [XKWelfareOrderViewController new];
//    welfareOrderViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:welfareOrderViewController animated:YES];
//}

#pragma mark - XKMineMainViewStoreTableViewCellDelegate

/** 侧滑加载福利商品列表 */
//- (void)storeCell:(XKMineMainViewStoreTableViewCell *)cell loadMerchListWithPage:(NSInteger)page {
//
//    if (page == 1) {
//        [self.storeMerchListArr removeAllObjects];
//    }
//    [self getWelfareGoodsListWithPage:page];
//}

/** 选择福利商品 */
//- (void)storeCell:(XKMineMainViewStoreTableViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    WelfareDataItem *item = self.storeMerchListArr[indexPath.row];
//    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
//    [detail creatWkWebViewWithMethodNameArray:nil requestUrlString:[NSString stringWithFormat:@"http://test.xksquare.com/web/#/goodsdetail?client=xk&id=%@",item.ID]];
//    [self.navigationController pushViewController:detail animated:YES];
//}

//    [HTTPClient postEncryptRequestWithURLString:GetXkUserDetailUrl timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
//        XKPersonalDataModel *model = [XKPersonalDataModel yy_modelWithJSON:responseObject];
//        self.personalDataModel = model;
//        [self.tableView reloadData];
//    } failure:^(XKHttpErrror *error) {
//        [XKHudView showErrorMessage:@"获取信息失败"];
//    }];


/** 获取福利商城商品列表 */
//- (void)getWelfareGoodsListWithPage:(NSInteger)page {
//
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval timeInterval = [date timeIntervalSince1970];
//    NSString *timeString = [NSString stringWithFormat:@"%0.f", timeInterval];
//
//    NSDictionary *getMerchListParamsDict = @{@"limit": @(10),
//                                             @"page": @(page),
//                                             @"lastUpdateAt": timeString};
//    [HTTPClient getEncryptRequestWithURLString:kMineMainSequenceQPageActiveUrl timeoutInterval:20.0 parameters:getMerchListParamsDict success:^(id responseObject) {
//        XKWelfareGoodsListViewModel *model =  [XKWelfareGoodsListViewModel yy_modelWithJSON:responseObject];
//        NSMutableArray *welfareDataItemArr = model.data.mutableCopy;
//        [self.storeMerchListArr addObjectsFromArray:welfareDataItemArr];
//        [self.tableView reloadData];
//    } failure:^(XKHttpErrror *error) {
//        [XKHudView showErrorMessage:@"获取福利商品列表失败"];
//    }];
//}

//        [_tableView registerClass:[XKMineMainViewStoreTableViewCell class] forCellReuseIdentifier:kMineMainViewStoreTableViewCell];
//        [_tableView registerClass:[XKMineMainViewStoreTableHeaderView class] forHeaderFooterViewReuseIdentifier:kMineMainViewStoreTableHeaderView];


//- (NSMutableArray *)storeMerchListArr {
//
//    if (!_storeMerchListArr) {
//        _storeMerchListArr = @[].mutableCopy;
//    }
//    return _storeMerchListArr;
//}

@end
