//
//  XKCustomerServiceHistoryMainViewController.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKCustomerServiceHistoryMainViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKCustomerServiceHistoryListViewController.h"
@interface XKCustomerServiceHistoryMainViewController ()
/*menu 视图*/
@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;

@property(nonatomic, strong)XKCustomerServiceHistoryListViewController *normalVC;

@property(nonatomic, strong)XKCustomerServiceHistoryListViewController *abnormalVC;
@end

@implementation XKCustomerServiceHistoryMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

//- (void)viewDidDisappear:(BOOL)animated {
//  [super viewDidDisappear:animated];
//  self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//}
//#pragma mark 默认加载方法
//- (void)handleData {
//  self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
//  self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//}

- (void)addCustomSubviews {
  [self setNavTitle:@"历史咨询" WithColor:[UIColor whiteColor]];
//  [self.view addSubview:self.pageMenu];
  self.normalVC = [[XKCustomerServiceHistoryListViewController alloc] init];
  self.normalVC.serviceType = XKCustomerServiceTypeNormal;
  [self.containView addSubview:self.normalVC.view];
  [self addChildViewController:self.normalVC];
  [self.normalVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(self.containView);
  }];
}

#pragma mark 懒加载
- (XKScrollPageMenuView *)pageMenu {
  if(!_pageMenu) {

    CGFloat h =  SCREEN_HEIGHT - NavigationAndStatue_Height;
    _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, h)];
    
    _normalVC = [XKCustomerServiceHistoryListViewController new];
    _normalVC.serviceType = XKCustomerServiceTypeNormal;
    
    _abnormalVC = [XKCustomerServiceHistoryListViewController new];
    _abnormalVC.serviceType = XKCustomerServiceTypeAbnormal;
  
    [self addChildViewController:_normalVC];
    [self addChildViewController:_abnormalVC];
    
    _pageMenu.titles = @[@"正常", @"异常"];
    _pageMenu.childViews = @[_normalVC, _abnormalVC];
    _pageMenu.sliderSize = CGSizeMake(68, 6);
    _pageMenu.selectedPageIndex = 0;
    _pageMenu.numberOfTitles = 2;
    _pageMenu.titleBarHeight = 40;
    _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
    _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
    _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
    _pageMenu.titleSelectedColor = [UIColor whiteColor];
    _pageMenu.sliderColor = [UIColor whiteColor];
  }
  return _pageMenu;
}


@end
