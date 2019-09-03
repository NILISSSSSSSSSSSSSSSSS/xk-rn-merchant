//
//  XKMainMallOrderViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMainMallOrderViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKMallOrderWaitPayViewController.h"
#import "XKMallOrderWaitSendViewController.h"
#import "XKMallOrderWaitEvaluateViewController.h"
#import "XKMallOrderAfterSaleViewController.h"
#import "XKMallOrderWaitAcceptViewController.h"
#import "XKMallOrderFinishViewController.h"
@interface XKMainMallOrderViewController ()
/*menu 视图*/
@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;

@end

@implementation XKMainMallOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}

- (void)addCustomSubviews {
    
    [self hideNavigation];
    XKWeakSelf(ws);
    if(self.entryType == 0) {
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    
    [_navBar customNaviBarWithTitle:@"商城订单" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    }
    [self.view addSubview:self.pageMenu];
    
}

- (void)updateDate {
    for (BaseViewController *controller in self.childViewControllers) {
        if (controller.refreshListBlock) {
            controller.refreshListBlock();
        }
    }
}
#pragma mark 懒加载
- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        XKWeakSelf(ws);
        CGFloat y = self.entryType == 0 ? NavigationAndStatue_Height : 0;
        CGFloat h = self.entryType == 0 ? SCREEN_HEIGHT  - kIphoneXNavi(64) : SCREEN_HEIGHT - kIphoneXNavi(64) - TabBar_Height;
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
        _pageMenu.selectedBlock = ^(NSInteger index) {
            if(index == 4) {
                ws.navBar.rightButton.hidden = NO;
            } else {
                ws.navBar.rightButton.hidden = YES;
            }
        };
        XKMallOrderWaitPayViewController *waitPayVC = [XKMallOrderWaitPayViewController new];
        waitPayVC.entryType = self.entryType;
        XKMallOrderWaitSendViewController *waitSendVC = [XKMallOrderWaitSendViewController new];
        waitSendVC.entryType = self.entryType;
        XKMallOrderWaitAcceptViewController *waitAcceptVC = [XKMallOrderWaitAcceptViewController new];
        waitAcceptVC.entryType = self.entryType;
        XKMallOrderWaitEvaluateViewController *waitEvaVC = [XKMallOrderWaitEvaluateViewController new];
        waitEvaVC.entryType = self.entryType;
        XKMallOrderFinishViewController *finishVC = [XKMallOrderFinishViewController new];
        finishVC.entryType = self.entryType;
        XKMallOrderAfterSaleViewController *afterSaleVC = [XKMallOrderAfterSaleViewController new];
        afterSaleVC.entryType = self.entryType;
        
//        waitPayVC.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        waitSendVC.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        waitAcceptVC.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        waitEvaVC.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        finishVC.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
//        afterSaleVC.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _pageMenu.titles = @[@"待付款", @"待发货", @"待收货",@"待评价",@"已完成", @"售后"];
        [self addChildViewController:waitPayVC];
        [self addChildViewController:waitSendVC];
        [self addChildViewController:waitAcceptVC];
        [self addChildViewController:waitEvaVC];
        [self addChildViewController:finishVC];
        [self addChildViewController:afterSaleVC];

        _pageMenu.childViews = @[waitPayVC, waitSendVC, waitAcceptVC, waitEvaVC, finishVC, afterSaleVC];
        _pageMenu.numberOfTitles = 5;
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.titleBarHeight = 40;
        _pageMenu.sliderSize = CGSizeMake(42, 6);
        if (self.entryType == 0 ) {
            _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
            _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
            _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
            _pageMenu.titleSelectedColor = [UIColor whiteColor];
            _pageMenu.sliderColor = [UIColor whiteColor];
        } else {
            _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
            _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
            _pageMenu.titleColor = UIColorFromRGB(0x555555);
            _pageMenu.titleSelectedColor = XKMainTypeColor;
            _pageMenu.sliderColor = XKMainTypeColor;
            _pageMenu.topBgColor = [UIColor whiteColor];
        }
    }
    return _pageMenu;
}

@end
