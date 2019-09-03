//
//  XKMainOrderViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMainOrderViewController.h"
#import "XKWelfareOrderViewController.h"
#import "XKMainBusinessAreaViewController.h"
#import "XKMainMallOrderViewController.h"
#import "XKPhotoPickHelper.h"
#import "XKDataBase.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKScrollPageMenuView.h"

@interface XKMainOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;

@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;

@property (nonatomic, strong)XKWelfareOrderListViewModel *viewModel;

@property (nonatomic, strong) XKMainMallOrderViewController  *mallVC;
@property (nonatomic, strong) XKWelfareOrderViewController  *welfareVC;
@property (nonatomic, strong) XKMainBusinessAreaViewController *areaVC;
@end

@implementation XKMainOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
     XKWeakSelf(ws);
    _viewModel = [XKWelfareOrderListViewModel new];
    _viewModel.page = 0;
    _viewModel.limit = 10;
    self.refreshListBlock = ^{
        [ws.mallVC updateDate];
    };
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    [_navBar customBaseNavigationBar];
    _navBar.backButton.hidden = YES;
    _navBar.titleLabel.text = @"订单";
    [self.view addSubview:self.pageMenu];
    _navBar.welfareButtonBlock = ^{
        
        [ws.view bringSubviewToFront:ws.welfareVC.view];
    };
    
    _navBar.mallButtonBlock = ^{
       
        [ws.view bringSubviewToFront:ws.mallVC.view];
    };
    
    _navBar.businessButtonBlock = ^{
        [ws.view bringSubviewToFront:ws.welfareVC.view];
    };
    [self.view addSubview:_navBar];

    _navBar.welfareButtonBlock();
}


- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        XKWeakSelf(ws);
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height - TabBar_Height)];
        _pageMenu.selectedBlock = ^(NSInteger index) {
          
        };
        ws.welfareVC = [XKWelfareOrderViewController new];
        ws.welfareVC.entryType = 1;
        
        ws.areaVC = [XKMainBusinessAreaViewController new];
        ws.areaVC.entryType = 1;
        
        ws.mallVC = [XKMainMallOrderViewController new];
        ws.mallVC.entryType = 1;

        _pageMenu.titles = @[@"积券夺奖", @"实体商家", @"线上商城"];
        [self addChildViewController:ws.welfareVC];
        [self addChildViewController:ws.areaVC];
        [self addChildViewController:ws.mallVC];
        _pageMenu.childViews = @[ws.welfareVC ,ws.areaVC, ws.mallVC];
        
        _pageMenu.sliderSize = CGSizeMake(70, 6);
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
        _pageMenu.titleSelectedColor = [UIColor whiteColor];
        _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        _pageMenu.sliderColor = [UIColor whiteColor];
        _pageMenu.numberOfTitles = 3;
        _pageMenu.titleBarHeight = 40;
    }
    return _pageMenu;
}

@end
