////
////  XKVideoMainViewController.m
////  XKSquare
////
////  Created by RyanYuan on 2018/10/9.
////  Copyright © 2018年 xk. All rights reserved.
////
//
//#import "XKVideoMainViewController.h"
//#import "XKScrollPageMenuView.h"
//#import "XKVideoHomePageViewController.h"
//#import "XKVideoCitywideViewController.h"
//#import "XKVideoSearchViewController.h"
//#import "XKVideoDisplayMediator.h"
//
//@interface XKVideoMainViewController ()
//
//@property (nonatomic, strong) XKScrollPageMenuView *pageMenu;
//
//@end
//
//@implementation XKVideoMainViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self initializeViews];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)dealloc {
//    
//}
//
//#pragma mark - private method
//
//- (void)initializeViews {
//    
//    // 导航栏
//    [self setNavTitle:@"小视频" WithColor:[UIColor whiteColor]];
//    UIView *rightView = [UIView new];
//    UIButton *recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    recommendButton.titleLabel.font = XKRegularFont(18.0);
//    [recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
//    [recommendButton addTarget:self action:@selector(clickRecommendButton:) forControlEvents:UIControlEventTouchUpInside];
//    recommendButton.titleLabel.tintColor = [UIColor whiteColor];
//    [rightView addSubview:recommendButton];
//    [recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(rightView.mas_left);
//        make.top.equalTo(rightView.mas_top);
//        make.bottom.equalTo(rightView.mas_bottom);
//        make.width.equalTo(@(40));
//    }];
//    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchButton setImage:[UIImage imageNamed:@"xk_btn_welfare_search"] forState:UIControlStateNormal];
//    [searchButton addTarget:self action:@selector(clickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:searchButton];
//    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(recommendButton.mas_right);
//        make.top.equalTo(rightView.mas_top);
//        make.bottom.equalTo(rightView.mas_bottom);
//        make.width.equalTo(@(40));
//    }];
//    [self setRightView:rightView withframe:CGRectMake(20, 20, 80, 24)];
//    [self hideNavigationSeperateLine];
//    
//    // 滑动选择器
//    self.pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];
//    self.pageMenu.selectedBlock = ^(NSInteger index) {
//    };
//    XKVideoHomePageViewController *homePageViewController = [XKVideoHomePageViewController new];
//    XKVideoCitywideViewController *localViewController = [XKVideoCitywideViewController new];
//    self.pageMenu.titles = @[@"首页", @"同城"];
//    [self addChildViewController:homePageViewController];
//    [self addChildViewController:localViewController];
//    self.pageMenu.childViews = @[homePageViewController, localViewController];
//    self.pageMenu.sliderSize = CGSizeMake(70, 6);
//    self.pageMenu.selectedPageIndex = 0;
//    self.pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
//    self.pageMenu.titleSelectedColor = [UIColor whiteColor];
//    self.pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:15];
//    self.pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:15];
//    self.pageMenu.sliderColor = [UIColor whiteColor];
//    self.pageMenu.numberOfTitles = 2;
//    self.pageMenu.titleBarHeight = 40;
//    [self.view addSubview:self.pageMenu];
//}
//
//- (void)clickSearchButton:(UIButton *) sender {
//    XKVideoSearchViewController *vc = [[XKVideoSearchViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//#pragma mark - events
//
//- (void)clickRecommendButton:(UIButton *)button {
//    [XKVideoDisplayMediator displayRecommendVideoListWithViewController:self];
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
