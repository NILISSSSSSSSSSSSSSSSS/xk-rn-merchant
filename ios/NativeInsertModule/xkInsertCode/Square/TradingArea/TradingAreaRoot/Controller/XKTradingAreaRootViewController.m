////
////  XKTradingAreaRootViewController.m
////  XKSquare
////
////  Created by Lin Li on 2018/10/15.
////  Copyright © 2018年 xk. All rights reserved.
////
//
//#import "XKTradingAreaRootViewController.h"
//#import "XKTradingAreaViewModel.h"
//#import "XKTradingAreaMainViewController.h"
//#import "XKCityListViewController.h"
//#import "XKStoreRecommendViewController.h"
//#import "XKTradingShopListModel.h"
//#import "XKMallGoodsCategoryViewController.h"
//#import "XKSqureSearchViewController.h"
//#import "XKIMGlobalMethod.h"
//#import "XKMainBusinessAreaViewController.h"
//#import "XKTradingAreaPrizeViewController.h"
//
//@interface XKTradingAreaRootViewController ()<UITextFieldDelegate>
///**tableView*/
//@property(nonatomic, strong) UITableView *tableView;
//@property(nonatomic, strong) XKTradingAreaViewModel *viewModel;
//@property(nonatomic, strong) UIButton *chooseCityButton;
//@end
//
//@implementation XKTradingAreaRootViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setNavView];
//    [self setUI];
//    [self loadRequestShopListisRefresh:YES needTip:YES WithType:@"POPULARITY"];
//
//}
//
//- (void)setUI {
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.tableView.backgroundColor = RGB(240, 240, 240);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.delegate = self.viewModel;
//    self.tableView.dataSource = self.viewModel;
//    self.tableView.sectionFooterHeight = CGFLOAT_MIN;
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.navigationView.mas_bottom);
//    }];
//    XKWeakSelf(ws);
//    self.viewModel.reloadDataBlock = ^ {
//        [ws.tableView reloadData];
//    };
//    
//    self.viewModel.cellSelcetBlock = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"%ld", (long)indexPath.row);
//        if (indexPath.section == 0) {
//            XKTradingAreaPrizeViewController *vc = [XKTradingAreaPrizeViewController new];
//            [ws.navigationController pushViewController:vc animated:YES];
//        }else {
//            XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
//            XKTradingShopListDataItem *model = ws.viewModel.dataArray[indexPath.row];
//            vc.shopId = model.shopId;
//            [ws.navigationController pushViewController:vc animated:YES];
//        }
//    };
//    
//    self.viewModel.headerItemBlock = ^(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath ,NSString *code,NSMutableArray *iconArray) {
//        if (indexPath.row == (iconArray.count - 1)) {
//            XKMallGoodsCategoryViewController *vc = [[XKMallGoodsCategoryViewController alloc]init];
//            vc.type = CategoryTypeArea;
//            vc.refreshBlock = ^{
//                [ws.viewModel refreshAreaToolView];
//            };
//            [ws.navigationController pushViewController:vc animated:YES];
//        }else {
//            XKTradingAreaMainViewController *vc = [[XKTradingAreaMainViewController alloc] init];
//            vc.oneLeverCode = code;
//            [ws.navigationController pushViewController:vc animated:YES];
//        }
//        NSLog(@"%ld", (long)indexPath.item);
//    };
//    // 注册cell
//    [self.viewModel registerClassForTableView:self.tableView];
//    
//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        if ([ws.viewModel.orderType isEqualToString: @"DISTANCE"]) {
//            [ws loadRequestShopListisRefresh:NO needTip:NO WithType:@"DISTANCE"];
//        }else if ([self.viewModel.orderType isEqualToString: @"POPULARITY"]){
//            [ws loadRequestShopListisRefresh:NO needTip:NO WithType:@"POPULARITY"];
//        }
//    }];
//    [self.viewModel loadIconListBlock:^(NSMutableArray * _Nonnull array) {}];
//    [self.viewModel loadBannerBlock:^(NSMutableArray *array) {
//    }];
//    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.viewModel loadBannerBlock:^(NSMutableArray *array) {}];
//        [self.viewModel loadIconListBlock:^(NSMutableArray * _Nonnull array) {}];
//        if ([ws.viewModel.orderType isEqualToString: @"DISTANCE"]) {
//            [ws loadRequestShopListisRefresh:YES needTip:NO WithType:@"DISTANCE"];
//        }else if ([self.viewModel.orderType isEqualToString: @"POPULARITY"]){
//            [ws loadRequestShopListisRefresh:YES needTip:NO WithType:@"POPULARITY"];
//        }
//    }];
//    
//    self.tableView.mj_footer = footer;
//    [footer setTitle:@"已经到底了！" forState:MJRefreshStateNoMoreData];
//    self.tableView.mj_footer.hidden = YES;
//
//}
//
///**
// 店铺列表
// */
//- (void)loadRequestShopListisRefresh:(BOOL)refresh needTip:(BOOL)needTip WithType:(NSString *)type {
//    if (needTip) {
//        [XKHudView showLoadingTo:self.tableView animated:YES];
//    }
//    [self.viewModel loadRequestShopListisRefresh:refresh WithType:type Block:^(NSMutableArray * _Nonnull array) {
//            [XKHudView hideHUDForView:self.tableView animated:YES];
//            [self resetMJHeaderFooter:self.viewModel.refreshStatus tableView:self.tableView dataArray:array];
//            [self.tableView reloadData];
//    }];
//}
//
//#pragma mark - 设置导航栏
//- (void)setNavView {
//    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(40, 0, self.navigationView.width - 40, self.navigationView.height)];
//    UIButton *chooseCityButton = [[UIButton alloc] init];
//    [chooseCityButton setImage:[UIImage imageNamed:@"xk_btn_mall_select"] forState:UIControlStateNormal];
//    [chooseCityButton setTitle:@"成都" forState:UIControlStateNormal];
//    chooseCityButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//    [chooseCityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [chooseCityButton addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
//    [navBarView addSubview:chooseCityButton];
//    [chooseCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(navBarView);
//        make.right.mas_equalTo(-10);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(20);
//    }];
//    self.chooseCityButton = chooseCityButton;
//    UIButton *orderButton = [[UIButton alloc] init];
//    [orderButton setImage:[UIImage imageNamed:@"xk_btn_welfare_order"] forState:UIControlStateNormal];
//    [orderButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [navBarView addSubview:orderButton];
//    [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(chooseCityButton.mas_left).offset(-10);
//        make.centerY.equalTo(navBarView);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
//    
//    UIButton *messageButton = [[UIButton alloc] init];
//    [messageButton setImage:[UIImage imageNamed:@"xk_btn_welfare_order_message"] forState:UIControlStateNormal];
//    [messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [navBarView addSubview:messageButton];
//    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(orderButton.mas_left).offset(-10);
//        make.centerY.equalTo(navBarView);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
//    
//     XKCustomSearchBar * searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 180 , 30)];
//    [searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] tintColor:HEX_RGB(0xFFFFFF) textFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:HEX_RGB(0xFFFFFF) textPlaceholderColor:HEX_RGB(0xFFFFFF) textAlignment:NSTextAlignmentLeft masksToBounds:YES];
//    searchBar.textField.placeholder = @"夏季狂欢节";
//    searchBar.textField.delegate = self;
//    [navBarView addSubview:searchBar];
//    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(messageButton.mas_left).offset(-10);
//        make.centerY.equalTo(navBarView);
//        make.left.mas_equalTo(10);
//        make.height.mas_equalTo(30);
//    }];
//    
//    [self setNaviCustomView:navBarView withframe:CGRectMake(40, 0, self.navigationView.width - 40, self.navigationView.height)];
//}
//
///**
// 选择城市
// */
//- (void)chooseCity:(UIButton *)sender {
//    XKCityListViewController *vc = [[XKCityListViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    XKWeakSelf(weakSelf);
//    vc.citySelectedBlock = ^(NSString *cityName, double laititude, double longtitude, NSString *cityCode) {
//        NSString *city= @"";
//        city = [cityName substringWithRange:NSMakeRange(0, 2)];
//        NSString *cityn = [NSString stringWithFormat:@"%@",city];
//        [weakSelf.chooseCityButton setTitle:cityn forState:UIControlStateNormal];
//    };
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
//}
//
//- (void)orderButtonClicked:(UIButton *)sender {
//    //商圈首页跳订单
//    XKMainBusinessAreaViewController *orderVC = [XKMainBusinessAreaViewController new];
////    orderVC.type = MainMallOrderVCType_tradingArea;
//    [self.navigationController pushViewController:orderVC animated:YES];
//}
//
//- (void)messageButtonClicked:(UIButton *)sender {
//    [XKIMGlobalMethod gotoCustomerSerChatList];
//}
//
//#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    XKSqureSearchViewController * vc = [[XKSqureSearchViewController alloc]init];
//    vc.searchType = SearchEntryType_Area;
//    [self.navigationController pushViewController:vc animated:NO];
//    return NO;
//}
//
//- (XKTradingAreaViewModel *)viewModel {
//    if (!_viewModel) {
//        _viewModel = [[XKTradingAreaViewModel alloc]init];
//    }
//    return _viewModel;
//}
//@end
