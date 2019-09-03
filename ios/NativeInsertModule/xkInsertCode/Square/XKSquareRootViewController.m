////
////  XKSquareRootViewController.m
////  XKSquare
////
////  Created by hupan on 2018/8/3.
////  Copyright © 2018年 xk. All rights reserved.
////
//
#import "XKSquareRootViewController.h"
//#import "XKSquareRootViewAdapter.h"
//#import "BaseViewFactory.h"
//#import "XKCustomSearchBar.h"
//#import "XKSubscriptionCellModel.h"
//#import "XKQRCodeScanViewController.h"
//#import "XKWelfareNewMainViewController.h"
//#import "XKSubscriptionViewController.h"
//#import "XKStoreRecommendViewController.h"
//#import "XKSqureSearchViewController.h"
//#import "XKSqureConsultDetailViewController.h"
////#import "XKCityListViewController.h"
//#import "XKRouter.h"
//#import "XKMallNewMainViewController.h"
//#import "XKGamesSupermarketViewController.h"
//#import <BlocksKit+UIKit.h>
//#import "XKTradingAreaRootViewController.h"
//#import "XKVideoMainViewController.h"
//#import "XKGamesDetailViewController.h"
//#import "XKFriendsCircleListController.h"
//#import "XKMallGoodsDetailViewController.h"
//#import "XKDeviceDataLibrery.h"
//#import "XKSqureConsultListViewController.h"
//#import "XKCityListDefaults.h"
//#import "XKCityDBManager.h"
//#import "XKBaiduLocation.h"
//#import "BaseWKWebViewController.h"
//#import "XKWinningAnnouncementViewController.h"
//#import "XKJumpWebViewController.h"
//#import "XKMallGoodsCategoryViewController.h"
//#import "XKFriendTalkDetailController.h"
//#import "XKVideoDisplayMediator.h"
//#import "XKLaunchAdvertisementViewController.h"
//#import "XKGlobleCommonTool.h"
//#import "XKQRCodeResultManager.h"
//
//#if DEBUG
//#import "DragStickinessView.h"
//#import <TZImagePickerController.h>
//#import "XKUploadManager.h"
//
//#endif
//
@interface XKSquareRootViewController ()//<XKSquareRootViewAdapterDelegate, XKBaiduLocationDelegate, UITextFieldDelegate>
//
//@property (nonatomic, strong) UITableView              *tableView;
//@property (nonatomic, strong) UIButton                 *chooseCityButton;
//@property (nonatomic, strong) XKCustomSearchBar        *searchBar;
//@property (nonatomic, strong) XKSquareRootViewAdapter  *adapter;
//
@end
//
@implementation XKSquareRootViewController
//
//
//#pragma mark - Life Cycle
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
//
////    [self.adapter requestUpdateInfoData];
//    [self configNavigationBar];
//    [self configTableView];
//    [self configTableFooterView];
//    /*[self configCurrentCity];*/
//    if ([[XKBaiduLocation shareManager] locationAuthorized]) {
//        //开启网络加载提示   定位结束或者失败时关闭
//        [XKHudView showLoadingTo:self.view animated:YES];
//        [self configBaiduMapLocation];
//    } else {
//        [self requestAllDataWithSubscriptionArr:self.adapter.subscriptionArray];
//    }
//
//#ifdef DEBUG
//    [self configTestBtn];
//#endif
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"广场首页-WillAppear");
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    NSLog(@"广场首页-DidDisappear");
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//#pragma mark - Private Metheods
//#ifdef DEBUG
//- (void)configTestBtn {
//    DragStickinessView *dragView = [[DragStickinessView alloc] initWithPoint:CGPointMake(10,SCREEN_HEIGHT-130-kBottomSafeHeight) superView:self.view];
//    dragView.tag = 10101;
//    dragView.viscosity  = 8;
//    dragView.bubbleWidth = 55;
//    dragView.bubbleColor = RGB(254, 67, 101);
//    dragView.limitInset = UIEdgeInsetsMake(20, 5, 60, 5);
//    dragView.autoBackMode = DragStickinessBackMixMode;
//    [dragView setUp];
//    dragView.bubbleLabel.text = @"测试";
//    dragView.bubbleLabel.textColor = [UIColor whiteColor];
//    dragView.bubbleLabel.font = [UIFont boldSystemFontOfSize:18];
//    dragView.bubbleLabel.userInteractionEnabled = YES;
//    [dragView.bubbleLabel bk_whenTapped:^{
//        [self testClick];
//    }];
//}
//
//- (void)testClick {
//    UIViewController *vc = [self getCurrentUIVC];
//    [[XKRouter sharedInstance] runRemoteUrl:@"xksquare://com.dynamic?targetclass=XKTestJumpViewController&name=%E4%BD%93%E8%B4%B4&num=2" ParentVC:vc];
////    TZImagePickerController *tz = [[TZImagePickerController alloc] init];
////    [self.navigationController pushViewController:tz animated:YES];
//}
//#endif
//
//- (void)configNavigationBar {
//    [self hiddenBackButton:YES];
//    
//    UIButton *scanQRButton = [[UIButton alloc] init];
//    [scanQRButton setImage:[UIImage imageNamed:@"xk_btn_home_scan"] forState:UIControlStateNormal];
//    [scanQRButton addTarget:self action:@selector(scanQRButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self setNaviCustomView:scanQRButton withframe:CGRectMake(SCREEN_WIDTH - 41, 11, 22, 22)];
//    [self setLeftView:self.chooseCityButton withframe:CGRectMake(0, 0, 50, 40)];
//    [self setMiddleView:self.searchBar withframe:CGRectMake(0, 0, SCREEN_WIDTH - 120, 30)];
//}
//
//- (void)configTableView {
//    
//    XKWeakSelf(weakSelf);
//    MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf requestAllDataWithSubscriptionArr:weakSelf.adapter.subscriptionArray];
//    }];
//    self.tableView.mj_header = narmalHeader;
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height, 0, 0, 0));
//    }];
//}
//
//- (void)configTableFooterView {
//    
//    UILabel *footerLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, SCREEN_WIDTH, 30) text:@"到底了..." font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12] textColor:HEX_RGB(0xCCCCCC) backgroundColor:HEX_RGB(0xf6f6f6)];
//    footerLabel.textAlignment = NSTextAlignmentCenter;
//    self.tableView.tableFooterView = footerLabel;
//}
//
//- (void)configBaiduMapLocation {
//    [XKBaiduLocation shareManager].delegate = self;
//    [[XKBaiduLocation shareManager] startBaiduSingleLocationService];
//}
//
//- (void)scanQRButtonClicked {
//    
//    XKQRCodeScanViewController *scanVC = [[XKQRCodeScanViewController alloc] init];
////    __weak typeof(scanVC)weakVC = scanVC;
//    scanVC.scanResult = ^(NSString *resultString) {
//        NSLog(@"结果%@", resultString);
//        [XKQRCodeResultManager dealResult:resultString];
//    };
//    [self.navigationController pushViewController:scanVC animated:YES];
//}
//
//- (void)chooseCity {
//    
//    XKCityListViewController *vc = [[XKCityListViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    XKWeakSelf(weakSelf);
//    vc.citySelectedBlock = ^(NSString *cityName, double laititude, double longtitude, NSString *cityCode) {
//        weakSelf.adapter.cityCode = cityCode;
//        [weakSelf.chooseCityButton setTitle:cityName.length >= 2 ? [cityName substringToIndex:2] : cityName forState:UIControlStateNormal];
//        [weakSelf requestAllDataWithSubscriptionArr:weakSelf.adapter.subscriptionArray];
//    };
//    [self presentViewController:nav animated:YES completion:nil];
//}
//
//#pragma mark - request
//
//- (void)requestAllDataWithSubscriptionArr:(NSArray *)subscriptionArr {
//     //轮播图
//    self.tableView.hidden = NO;
//    [XKHudView showLoadingTo:self.tableView animated:YES];
//    dispatch_group_enter(self.adapter.group);
//    [self.adapter requestBannerData];
//    
//    //工具栏
//    dispatch_group_enter(self.adapter.group);
//    [self.adapter requestSquareHomeToolData];
//    
//    //抽奖信息
////    dispatch_group_enter(self.adapter.group);
////    [self.adapter requestSqureRewardData];
//
//    for (XKSubscriptionCellModel *model in subscriptionArr) {
//        NSInteger index = model.itemId.integerValue + 3;
//        if (index == CellType_storeRecommend) {
//            //请求商城商品推荐
//            dispatch_group_enter(self.adapter.group);
//            [self.adapter requestStoreRecommendData];
//            
//        } else if (index == CellType_merchantRecommend) {
//            //请求商圈商家推荐
//            dispatch_group_enter(self.adapter.group);
//            [self.adapter requestMerchantRecommendData];
//            
//        } else if (index == CellType_squreConsult) {
//            //广场资讯
//            dispatch_group_enter(self.adapter.group);
//            [self.adapter requestSquareConsultData];
//            
//        } else if (index == CellType_friendCircle) {
//            //朋友圈推荐
//            dispatch_group_enter(self.adapter.group);
//            [self.adapter requestSquareFriendsCircleRecommendData];
//            
//        } else if (index == CellType_videoOfConcerned) {
//            //请求小视频推荐
//            dispatch_group_enter(self.adapter.group);
//            [self.adapter requestVideoRecommendData];
//            
//        } else if (index == CellType_gamesRecommend) {
//            //游戏推荐
////            dispatch_group_enter(self.adapter.group);
////            [self.adapter requestGamesRecommendData];
//        }
//    }
//    
//    dispatch_group_notify(self.adapter.group, dispatch_get_global_queue(0,0), ^{
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [XKHudView hideHUDForView:self.tableView];
//            [self.tableView stopRefreshing];
//            [self.adapter.tableView reloadData];
//        });
//    });
//}
//
//#pragma mark - Custom Blocks
//
//
//
//
//
//#pragma mark - XKBaiduLocationDelegate
//
//- (void)userLocationLaititude:(double)laititude longtitude:(double)longtitude {
//    [XKHudView hideHUDForView:self.view];
//    self.adapter.lat = laititude;
//    self.adapter.lng = longtitude;
//}
//
//- (void)userLocationCountry:(NSString *)country state:(NSString *)state city:(NSString *)city subLocality:(NSString *)subLocality name:(NSString *)name {
//    
//    if (subLocality.length) {
//        [self.chooseCityButton setTitle:subLocality.length > 2 ? [subLocality substringToIndex:2] : subLocality forState:UIControlStateNormal];
//    } else {
//        [self.chooseCityButton setTitle:city.length > 2 ? [city substringToIndex:2] : city forState:UIControlStateNormal];
//    }
//    
//    self.adapter.cityCode = [[XKCityDBManager shareInstance] getCityCodeWithCityName:city];
//    [XKCityListDefaults saveCityNumber:self.adapter.cityCode];
//    //刷新
//    [self requestAllDataWithSubscriptionArr:self.adapter.subscriptionArray];
//}
//
//- (void)failToLocateUserWithError:(NSError *)error {
//    [XKHudView hideHUDForView:self.view];
//    [XKHudView showErrorMessage:@"定位失败！"];
//    [self requestAllDataWithSubscriptionArr:self.adapter.subscriptionArray];
//}
//
//#pragma mark - Custom Delegates
//
//- (void)adapterTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath infoDic:(NSDictionary *)info {
//    NSLog(@"tableViewCell点击");
//    
//    if (indexPath.section == CellType_reward) {
//
////        抽奖
//        XKWinningAnnouncementViewController *vc = [[XKWinningAnnouncementViewController alloc] init];
////        [vc creatWkWebViewWithMethodNameArray:@[@"openMyPrize", @"openRecentPrize", @"openShopsPrize", @"openMyCoupon", @"openAllPrize", @"checkMyPrize", @"openCouponInfo"] requestUrlString:[NSString stringWithFormat:@"%@?client=xk&info=%@", [XKAPPNetworkConfig getWinningAnnouncementUrl], [XKGlobleCommonTool getH5CodeStr]]];
//// TODO: 先用本地地址调试，上线前换成通用地址
//        [vc creatWkWebViewWithMethodNameArray:@[@"openMyPrize", @"openRecentPrize", @"openShopsPrize", @"openMyCoupon", @"openAllPrize", @"checkMyPrize", @"lotteryGo", @"openCouponInfo"] requestUrlString:[NSString stringWithFormat:@"%@?client=xk&info=%@", @"192.168.2.115:8080/#/lotteryindex", [XKGlobleCommonTool getH5CodeStr]]];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if (indexPath.section == CellType_carouselAndTool) {
////        工具
//    } else if (indexPath.section == CellType_subscription) {//私人订制
//        
//        XKSubscriptionViewController *vc = [[XKSubscriptionViewController alloc] init];
//        XKWeakSelf(weakSelf);
//        vc.refreshBlock = ^{
//            NSString *jsonStr1 = [XKUserDefault objectForKey:kAlreadySubscriptionArr];
//            if (jsonStr1) {
//                weakSelf.adapter.subscriptionArray = [NSArray yy_modelArrayWithClass:[XKSubscriptionCellModel class] json:jsonStr1];
//                [weakSelf requestAllDataWithSubscriptionArr:weakSelf.adapter.subscriptionArray];
//            }
//            [weakSelf.adapter.tableView reloadData];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else {
//        
//        XKSubscriptionCellModel *model = self.adapter.subscriptionArray[indexPath.section - 3];
//        NSInteger index = model.itemId.integerValue + 3;
//        
//        if (index == CellType_merchantRecommend) {//商家推荐
//            XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
//            vc.shopId = info[@"itemId"];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        } else if (index == CellType_squreConsult) {//广场资讯
//            
//            XKSqureConsultDetailViewController *vc = [[XKSqureConsultDetailViewController alloc] init];
//            vc.url = info[@"url"];
//            vc.titleName = info[@"title"];
//            vc.content = info[@"content"];
//            vc.imgUrl = info[@"imgUrl"];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        } else if (index == CellType_friendCircle) {//朋友圈
//            XKFriendTalkDetailController *vc = [[XKFriendTalkDetailController alloc] init];
//            vc.did = info[@"did"];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        } else if (index == CellType_videoOfConcerned) {//关注小视频
//            //暂无
//            
//        } else if (index == CellType_gamesRecommend) {//游戏推荐
//            XKGamesDetailViewController *vc = [[XKGamesDetailViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
//}
//
//
////工具item
//- (void)adapterToolItemClicked:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath itemCode:(NSString *)code {
//    
//    if ([code isEqualToString:@"1"]) {//更多
//        XKMallGoodsCategoryViewController *vc = [[XKMallGoodsCategoryViewController alloc] init];
//        vc.type = CategoryTypeHome;
//        XKWeakSelf(weakSelf)
//        vc.refreshBlock = ^{
//            [weakSelf.adapter refreshHomeToolView];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else if ([code isEqualToString:@"101"]) {//福利
//
//        XKWelfareNewMainViewController *welfare = [XKWelfareNewMainViewController new];
//        [self.navigationController pushViewController:welfare animated:YES];
//        
//    } else if ([code isEqualToString:@"102"]) {//商城
//        XKMallNewMainViewController *mall = [XKMallNewMainViewController new];
//        [self.navigationController pushViewController:mall animated:YES];
//    
//    } else if ([code isEqualToString:@"103"]) {//商圈、周边
//        XKTradingAreaRootViewController *vc = [[XKTradingAreaRootViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//   
//    } else if ([code isEqualToString:@"104"]) {//小视频
//        XKVideoMainViewController *vc = [[XKVideoMainViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//   
//    } else if ([code isEqualToString:@"105"]) {//游戏
//        XKGamesSupermarketViewController *vc = [[XKGamesSupermarketViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else if ([code isEqualToString:@"106"]) {//读书
//    } else if ([code isEqualToString:@"107"]) {//电影
//    } else if ([code isEqualToString:@"108"]) {//餐饮
//    } else if ([code isEqualToString:@"109"]) {//休闲
//    }
//    
//}
//
////工具下拉条
//- (void)adapterPullDownButtonClicked:(UIButton *)sender cellIndexPath:(NSIndexPath *)indexPath {
//    if (sender.selected) {
//        NSLog(@"下拉");
//    } else {
//        NSLog(@"收起");
//    }
//    
//    if (self.tableView.contentOffset.y) {
//        [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        });
//    } else {
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
////轮播图
//- (void)adapterAutoScrollViewItemSelectedWithJumpType:(NSUInteger)jumpType jumpAddress:(NSString *)jumpAddress {
//    NSLog(@"type= %lu, address = %@", (unsigned long)jumpType, jumpAddress);
//
//    if (jumpType == 1) {//h5
//        XKJumpWebViewController *vc = [[XKJumpWebViewController alloc] init];
//        vc.url = jumpAddress;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else if (jumpType == 2) {//app内部跳转
//        [XKGlobleCommonTool bannerViewJumpAppInner:jumpAddress currentViewController:self];
//    }
//}
////查看跟多
//- (void)footerMoreViewSelected:(NSInteger)moreViewTag {
//    
//    if (moreViewTag == CellType_storeRecommend) {//商城推荐
//        XKMallNewMainViewController *mall = [XKMallNewMainViewController new];
//        [self.navigationController pushViewController:mall animated:YES];
//        
//    } else if (moreViewTag == CellType_merchantRecommend) {//商家推荐
//        XKTradingAreaRootViewController *vc = [[XKTradingAreaRootViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else if (moreViewTag == CellType_squreConsult) {//广场资讯
//        XKSqureConsultListViewController *vc = [[XKSqureConsultListViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else if (moreViewTag == CellType_friendCircle) {//我的朋友圈
//        XKFriendsCircleListController *vc = [[XKFriendsCircleListController alloc] init];
//        vc.showNaviBar = YES;
//        [vc refreshList];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else if (moreViewTag == CellType_videoOfConcerned) {//关注小视频
//        XKVideoMainViewController *vc = [[XKVideoMainViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } else if (moreViewTag == CellType_gamesRecommend) {//游戏推荐
//        XKGamesSupermarketViewController *vc = [[XKGamesSupermarketViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//
////商城推荐
//- (void)adapterStoreRecommendCollectionView:(UICollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath info:(NSDictionary *)info {
//    
//    XKMallGoodsDetailViewController *detail = [XKMallGoodsDetailViewController new];
//    detail.goodsId = info[@"id"];
//    [self.navigationController pushViewController:detail animated:YES];
//    
//}
//
//
//- (void)adapterFriendsCircleCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgUrlArr:(NSArray *)imgUrlArr {
//    
//    [XKGlobleCommonTool showBigImgWithImgsArr:imgUrlArr viewController:self];
//    
//}
//
//- (void)videoRecommendItemSelected:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath infoDic:(NSDictionary *)dic {
//    [XKVideoDisplayMediator displaySingleVideoWithViewController:self videoListItemModel:dic[@"videoModel"]];
//}
//
//
//#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//    XKSqureSearchViewController *vc = [[XKSqureSearchViewController alloc] init];
//    vc.searchType = SearchEntryType_Home;
//    [self.navigationController pushViewController:vc animated:NO];
//    return NO;
//}
//
//
//#pragma mark - Lazy load
//
//- (XKSquareRootViewAdapter *)adapter {
//    if (!_adapter) {
//        _adapter = [[XKSquareRootViewAdapter alloc] init];
//        _adapter.delegate = self;
//        _adapter.cityCode = [XKCityListDefaults getCityNumber];
//        _adapter.lat = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].latitude;
//        _adapter.lng = [[XKBaiduLocation shareManager] getUserLocationLaititudeAndLongtitude].longitude;
//        NSString *jsonStr1 = [XKUserDefault objectForKey:kAlreadySubscriptionArr];
//        if (jsonStr1) {
//            _adapter.subscriptionArray = [NSArray yy_modelArrayWithClass:[XKSubscriptionCellModel class] json:jsonStr1];
//        }
//    }
//    return _adapter;
//}
//
//- (UITableView *)tableView {
//    
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
//        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedRowHeight = 50;
//        _tableView.hidden = YES;
//        _tableView.delegate = self.adapter;
//        _tableView.dataSource = self.adapter;
//        self.adapter.tableView = _tableView;
//        [self.adapter registerAllCells];
//        [self.view addSubview:_tableView];
//    } 
//    return _tableView;
//    
//}
//
//- (XKCustomSearchBar *)searchBar {
//    
//    if (!_searchBar) {
//        _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 120, 30)];
//        [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] tintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56] textFont:XKMediumFont(14) textColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56] textPlaceholderColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56] textAlignment:NSTextAlignmentLeft masksToBounds:YES];
//        [_searchBar setPlaceholderWithStr:@"搜索" font:XKMediumFont(14) textColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56]];
//        _searchBar.textField.delegate = self;
//    }
//    return _searchBar;
//}
//
//- (UIButton *)chooseCityButton {
//    
//    if (!_chooseCityButton) {
//        _chooseCityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//        NSString *city = [XKCityListDefaults getCurrentCity];
//        if (city.length == 0) {
//            city = @"成都";
//        }
//        [_chooseCityButton setTitle:city.length > 2 ? [city substringToIndex:2] : city forState:UIControlStateNormal];
//        _chooseCityButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_chooseCityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_chooseCityButton addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
//        [_chooseCityButton setImage:[UIImage imageNamed:@"xk_btn_mall_select"] forState:UIControlStateNormal];
//
//        [_chooseCityButton setImageAtRightAndTitleAtLeftWithSpace:2];
//    }
//    return _chooseCityButton;
//}
//
///*
//- (void)configCurrentCity {
//    if ([XKCityListDefaults getCurrentCity]) {
//        if ([[XKCityListDefaults getCurrentCity]isEqualToString:[XKCityListDefaults getLocationCity]]) {
//            
//        }else {
//            XKCommonAlertView *alert = [[XKCommonAlertView alloc]initWithTitle:[NSString stringWithFormat:@"定位到您在%@",[XKCityListDefaults getLocationCity]] message:@"是否切换至该城市进行探索" leftButton:@"取消" rightButton:@"切换" leftBlock:nil rightBlock:^{
//                
//            } textAlignment:NSTextAlignmentCenter];
//            [alert show];
//        }
//    }
//}*/
@end
