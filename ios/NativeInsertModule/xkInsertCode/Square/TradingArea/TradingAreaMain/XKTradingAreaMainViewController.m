////
////  XKTradingAreaMainViewController.m
////  XKSquare
////
////  Created by hupan on 2018/9/29.
////  Copyright © 2018年 xk. All rights reserved.
////
//
//#import "XKTradingAreaMainViewController.h"
//#import "XKWelfarePageMenu.h"
//#import "XKMainBusinessAreaViewController.h"
//#import "XKTradingAreaMainListViewController.h"
//#import "XKMallBuyCarViewController.h"
//#import "XKCommonSheetView.h"
//#import "XKMallTypeView.h"
//#import "XKCityListDefaults.h"
//#import "XKIMGlobalMethod.h"
//#import "XKSqureSearchViewController.h"
//#import "XKSquareTradingAreaTool.h"
//#import "XKCityListViewController.h"
//#import "XKTradingAreaPullDownMenu.h"
//#import "XKTradingAreaIndustyAllCategaryModel.h"
//#import "XKTradingAreaSortModel.h"
//
//#define vcTag 10000
//
//@interface XKTradingAreaMainViewController () <XKWelfarePageMenuDelegate, UIScrollViewDelegate, UITextFieldDelegate>
//
//@property (nonatomic, strong) UIView                       *navBarView;
//@property (nonatomic, strong) UIButton                     *chooseCityButton;
//@property (nonatomic, strong) UIButton                     *orderButton;
//@property (nonatomic, strong) UIButton                     *messageButton;
//@property (nonatomic, strong) XKCustomSearchBar            *searchBar;
//
//@property (nonatomic, strong) XKWelfarePageMenu            *pageMenu;
//@property (nonatomic, strong) UIView                       *typeBtnview;
//@property (nonatomic, strong) XKHotspotButton              *typeBtn;
//@property (nonatomic, strong) UIView                       *lineView;
//@property (nonatomic, strong) UIScrollView                 *scrollView;
//
//@property (nonatomic, copy  ) NSArray               *menuTitleArr;
//@property (nonatomic, strong) NSMutableArray        *childVCMuArr;
//@property (nonatomic, strong) NSArray               *categoryArr;
//
//@property (nonatomic, strong) XKCommonSheetView     *sheetView;
//@property (nonatomic, strong) XKMallTypeView        *typeView;
//
//@property (nonatomic, strong) NSMutableArray *oneLevelArr;
//@property (nonatomic, strong) NSMutableArray *twoLevelArr;
//@property (nonatomic, strong) NSMutableArray *allTwoLeverMuArr;//二维数组
//
//@property (nonatomic, assign) BOOL           isFistEnter;
//
//
//@end
//
//@implementation XKTradingAreaMainViewController
//
//#pragma mark - lifeCycle
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
//    self.isFistEnter = YES;
////    [XKHudView showLoadingTo:self.view animated:YES];
//    [XKSquareTradingAreaTool tradingAreaIndustryAllCategaryList:nil success:^(XKTradingAreaIndustyAllCategaryModel *model) {
////        [XKHudView hideHUDForView:self.view];
//
//        self.oneLevelArr = [NSMutableArray arrayWithArray:model.oneLevel];
//        self.twoLevelArr = [NSMutableArray arrayWithArray:model.twoLevel];
//        
//        [self configViews];
//    } faile:^(XKHttpErrror *error) {
////        [XKHudView hideHUDForView:self.view];
//
//    }];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.searchBar.textField resignFirstResponder];
//}
//
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//}
//
//#pragma mark - privice
//
//- (void)configViews {
//    NSMutableArray *titleMuarr = [NSMutableArray array];
//    self.allTwoLeverMuArr = [NSMutableArray array];
//    NSInteger defaultIndex = 0;
//    for (IndustyOneLevelItem *oneItem in self.oneLevelArr) {
//        [titleMuarr addObject:oneItem.name];
//        if ([self.oneLeverCode isEqualToString:oneItem.code]) {
//            defaultIndex = [self.oneLevelArr indexOfObject:oneItem];
//        }
//        NSMutableArray *twoLeverMuArr = [NSMutableArray array];
//        for (IndustyTwoLevelItem *twoItem in self.twoLevelArr) {
//            if ([twoItem.parentCode isEqualToString:oneItem.code]) {
//                [twoLeverMuArr addObject:twoItem];
//            }
//        }
//        [self.allTwoLeverMuArr addObject:twoLeverMuArr.copy];
//    }
//    self.menuTitleArr = [titleMuarr copy];
//    /*
//     INTELLIGENCE,//智能排序
//     DISTANCE,//距离
//     POPULARITY,//人气
//     LEVEL,//评价等级
//     AVGCONSUMPTION_DESC; //人均消费降序
//     AVGCONSUMPTION_ASC; //人均消费升序
//     LOTTERY; //是否抽奖
//    */
//    NSArray *sortArr = @[@{@"name":@"智能排序", @"type":@"INTELLIGENCE"},
//                         @{@"name":@"距离优先", @"type":@"DISTANCE"},
//                         @{@"name":@"人气优先", @"type":@"POPULARITY"},
//                         @{@"name":@"好评优先", @"type":@"LEVEL"},
//                         @{@"name":@"人均消费从高到低", @"type":@"AVGCONSUMPTION_DESC"},
//                         @{@"name":@"人均消费从低到高", @"type":@"AVGCONSUMPTION_ASC"},
//                         @{@"name":@"抽奖优先", @"type":@"LOTTERY"}
//                         ];
//    NSMutableArray *sortModelArr = [NSMutableArray array];
//    for (NSDictionary *dic in sortArr) {
//        XKTradingAreaSortModel *model = [XKTradingAreaSortModel yy_modelWithDictionary:dic];
//        [sortModelArr addObject:model];
//    }
//    
//    
//    if (self.childVCMuArr) {
//        [self.childVCMuArr removeAllObjects];
//    } else {
//        self.childVCMuArr = [NSMutableArray array];
//    }
//    
//    CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - 44;
//    for (int i = 0; i < self.menuTitleArr.count; i++) {
//        XKTradingAreaMainListViewController *vc = [[NSClassFromString(@"XKTradingAreaMainListViewController") alloc] init];
//        vc.listVCType = TradingAreaMainListVC_topHeight84;
//        vc.sortArr = sortModelArr.copy;
//        if (i < self.oneLevelArr.count) {
//            IndustyOneLevelItem *oneItem = self.oneLevelArr[i];
//            vc.oneLeverCode = oneItem.code;
//        }
//        vc.twoLeverArr = self.allTwoLeverMuArr[i];
//        [self addChildViewController:vc];
//        
//        vc.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, scrollViewH);
//        [self.scrollView addSubview:vc.view];
//        [self.childVCMuArr addObject:vc];
//    }
//    self.scrollView.contentSize = CGSizeMake(self.menuTitleArr.count * SCREEN_WIDTH, 0);
//    
//    [self.pageMenu setItems:self.menuTitleArr selectedItemIndex:defaultIndex];
//    self.pageMenu.bridgeScrollView = self.scrollView;// 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
//    
//
//    [self setNaviCustomView:self.navBarView withframe:CGRectMake(50, 0, self.navigationView.width - 50, self.navigationView.height)];
//    [self.navBarView addSubview:self.chooseCityButton];
//    [self.navBarView addSubview:self.orderButton];
//    [self.navBarView addSubview:self.messageButton];
//    [self.navBarView addSubview:self.searchBar];
//
//    [self.view addSubview:self.pageMenu];
//    [self.view addSubview:self.typeBtnview];
//    [self.typeBtnview addSubview:self.typeBtn];
//    [self.view addSubview:self.lineView];
//    [self.view addSubview:self.scrollView];
//    
//    [self.chooseCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.navBarView);
//        make.right.mas_equalTo(-10);
//        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(20);
//    }];
//    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.chooseCityButton.mas_left).offset(-9);
//        make.centerY.equalTo(self.navBarView);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(18);
//    }];
//    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.orderButton.mas_left).offset(-11);
//        make.centerY.equalTo(self.navBarView);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
//    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.messageButton.mas_left).offset(-10);
//        make.centerY.equalTo(self.navBarView);
//        make.left.mas_equalTo(10);
//        make.height.mas_equalTo(30);
//    }];
//}
//
//#pragma mark network
//
//
//
//#pragma mark - Events
//
//- (void)chooseCity:(UIButton *)sender {
//    
//    XKCityListViewController *vc = [[XKCityListViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    XKWeakSelf(weakSelf);
//    vc.citySelectedBlock = ^(NSString *cityName, double laititude, double longtitude, NSString *cityCode) {
//        NSString *city= @"";
//        if (cityName.length >= 2) {
//            city = [cityName substringWithRange:NSMakeRange(0, 2)];
//        } else {
//            city = cityName;
//        }
//        [weakSelf.chooseCityButton setTitle:city forState:UIControlStateNormal];
//        [[XKBaiduLocation shareManager] setUserLocationLaititude:laititude longtitude:longtitude];
//    };
//
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
//}
//
//- (void)orderButtonClicked:(UIButton *)sender {
//
//    XKMainBusinessAreaViewController *orderVC = [XKMainBusinessAreaViewController new];
//    [self.navigationController pushViewController:orderVC animated:YES];
//}
//
//- (void)messageButtonClicked:(UIButton *)sender {
//    [XKIMGlobalMethod gotoCustomerSerChatList];
//}
//
//
//- (void)typeBtnClick:(UIButton *)sender {
//    [self.sheetView show];
//}
//
//
//#pragma mark - Delegate
//#pragma mark - SPPageMenu的代理方法
//
//- (void)pageMenu:(XKWelfarePageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
//    functionButton.titleLabel.font = XKMediumFont(14);
//}
//
//- (void)pageMenu:(XKWelfarePageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
//    NSLog(@"%zd",index);
//}
//
//- (void)pageMenu:(XKWelfarePageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    
//    NSLog(@"%zd------->%zd",fromIndex,toIndex);
//    if (fromIndex == toIndex && !self.isFistEnter) return;
//    self.isFistEnter = NO;
//    
//    XKTradingAreaMainListViewController *vc = (XKTradingAreaMainListViewController *)self.childVCMuArr[fromIndex];
//    [vc.filterView takeBackTableView];
//    
//    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
//    if (labs(toIndex - fromIndex) >= 2) {
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:NO];
//    } else {
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:YES];
//    }
//    if (self.childVCMuArr.count <= toIndex) {
//        return;
//    }
//    UIViewController *targetViewController = self.childVCMuArr[toIndex];
//    // 如果已经加载过，就不再加载
//    if ([targetViewController isViewLoaded]) {
//        return;
//    }
//    CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - 44;
//    targetViewController.view.frame = CGRectMake(SCREEN_WIDTH * toIndex, 0, SCREEN_WIDTH, scrollViewH);
//    [self.scrollView addSubview:targetViewController.view];
//}
//
//#pragma mark - UITextFieldDelegate
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    XKSqureSearchViewController *vc = [[XKSqureSearchViewController alloc] init];
//    vc.searchType = SearchEntryType_Area;
//    [self.navigationController pushViewController:vc animated:NO];
//    return YES;
//}
//
//#pragma mark - 懒加载
//
//- (UIView *)navBarView {
//    if (!_navBarView) {
//        _navBarView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, self.navigationView.width - 40, self.navigationView.height)];
//    }
//    return _navBarView;
//}
//
//- (UIButton *)chooseCityButton {
//    if (!_chooseCityButton) {
//        _chooseCityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
//        NSString *city = [XKCityListDefaults getCurrentCity];
//        if (city.length == 0) {
//            city = @"成都";
//        }
//        [_chooseCityButton setTitle:city.length > 2 ? [city substringToIndex:2] : city forState:UIControlStateNormal];
//        _chooseCityButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_chooseCityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_chooseCityButton addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
//        [_chooseCityButton setImage:[UIImage imageNamed:@"xk_btn_mall_select"] forState:UIControlStateNormal];
//        [_chooseCityButton setImageAtRightAndTitleAtLeftWithSpace:2];
//    }
//    return _chooseCityButton;
//}
//
//- (UIButton *)orderButton {
//    if (!_orderButton) {
//        _orderButton = [[UIButton alloc] init];
//        [_orderButton setImage:[UIImage imageNamed:@"xk_btn_welfare_order"] forState:UIControlStateNormal];
//        [_orderButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _orderButton;
//}
//
//
//- (UIButton *)messageButton {
//    if (!_messageButton) {
//        _messageButton = [[UIButton alloc] init];
//        [_messageButton setImage:[UIImage imageNamed:@"xk_btn_welfare_order_message"] forState:UIControlStateNormal];
//        [_messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _messageButton;
//}
//
//- (XKCustomSearchBar *)searchBar {
//    
//    if (!_searchBar) {
//        _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 200, 30)];
//        [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] tintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56] textFont:XKMediumFont(14) textColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56] textPlaceholderColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56] textAlignment:NSTextAlignmentLeft masksToBounds:YES];
//        [_searchBar setPlaceholderWithStr:@"夏季狂欢节" font:XKMediumFont(14) textColor:[[UIColor whiteColor] colorWithAlphaComponent:0.56]];
//        _searchBar.textField.delegate = self;
//    }
//    return _searchBar;
//}
//
//- (XKWelfarePageMenu *)pageMenu {
//    
//    if(!_pageMenu) {
//        // trackerStyle:跟踪器的样式
//        _pageMenu = [XKWelfarePageMenu pageMenuWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH - 40, 39) trackerStyle:XKWelfarePageMenuPageMenuTrackerStyleLine];
//        _pageMenu.needTextColorGradients = NO;
//        _pageMenu.unSelectedItemTitleColor = UIColorFromRGB(0x555555);
//        _pageMenu.selectedItemTitleColor = XKMainTypeColor;
//        _pageMenu.itemTitleFont = XKRegularFont(14);
//        _pageMenu.tracker.backgroundColor = XKMainTypeColor;
//        _pageMenu.selectedItemZoomScale = 1.1;
//        // 设置代理
//        _pageMenu.delegate = self;
//    }
//    return _pageMenu;
//}
//
//- (UIView *)typeBtnview {
//    if (!_typeBtnview) {
//        _typeBtnview = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 56,  kIphoneXNavi(64), 56, 39)];
//        _typeBtnview.backgroundColor = [UIColor whiteColor];
//    }
//    return _typeBtnview;
//}
//
//- (XKHotspotButton *)typeBtn {
//    if(!_typeBtn) {
//        _typeBtn = [[XKHotspotButton alloc] initWithFrame:CGRectMake(20,  15, 16, 9)];
//        [_typeBtn setBackgroundColor:[UIColor whiteColor]];
//        [_typeBtn setBackgroundImage:[UIImage imageNamed:@"xk_btn_mine_arrow_down"] forState:UIControlStateNormal];
//        [_typeBtn setBackgroundImage:[UIImage imageNamed:@"xk_btn_mine_arrow_down"] forState:UIControlStateSelected];
////        [_typeBtn setImage:[UIImage imageNamed:@"xk_btn_mine_arrow_down"] forState:UIControlStateNormal];
////        [_typeBtn setImage:[UIImage imageNamed:@"xk_btn_mine_arrow_down"] forState:UIControlStateSelected];
//        [_typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _typeBtn;
//}
//
//- (UIView *)lineView {
//    if (_lineView) {
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
//        _lineView.backgroundColor = XKSeparatorLineColor;
//    }
//    return _lineView;
//}
//
//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        CGFloat scrollViewY = kIphoneXNavi(64) + 40;
//        CGFloat scrollViewH = SCREEN_HEIGHT - scrollViewY;
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, SCREEN_WIDTH, scrollViewH)];
//        _scrollView.delegate = self;
//        _scrollView.pagingEnabled = YES;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//    }
//    return _scrollView;
//}
//
//- (XKCommonSheetView *)sheetView {
//    if(!_sheetView) {
//        _sheetView = [[XKCommonSheetView alloc] init];
//        _sheetView.contentView = self.typeView;
//        [_sheetView addSubview:self.typeView];
//    }
//    return _sheetView;
//}
//
//- (XKMallTypeView *)typeView {
//    if(!_typeView) {
//        _typeView = [[XKMallTypeView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - 100)];
//        [_typeView setTypeView:TypeView_tradingArea];
//        [_typeView updateDataSourceForLeftDataSource:self.oneLevelArr rightDataSource:self.allTwoLeverMuArr forIndex:0];
//        XKWeakSelf(weakSelf);
//        _typeView.choseIndexBlock = ^(NSInteger firstCode, NSInteger firstIndex, NSInteger secondCode, NSInteger secondIndex, NSString *searchName) {
//            [weakSelf.sheetView dismiss];
//            //移动指示条
//            weakSelf.pageMenu.selectedItemIndex = firstIndex;
//            
//            //刷新内容
//            XKTradingAreaMainListViewController *vc = (XKTradingAreaMainListViewController *)weakSelf.childVCMuArr[firstIndex];
//            [vc selectedTitleAtIndex:1 itemIndex:secondIndex];
//        };
//    }
//    return _typeView;
//}
//
//@end
