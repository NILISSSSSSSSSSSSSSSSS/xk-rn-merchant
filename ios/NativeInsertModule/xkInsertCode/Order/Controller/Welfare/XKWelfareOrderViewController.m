//
//  XKWelfareOrderViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKWelfareOrderWaitOpenViewController.h"
#import "XKWelfareOrderWinViewController.h"
#import "XKWelfareOrderFinishViewController.h"
@interface XKWelfareOrderViewController ()
/*menu 视图*/
@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property(nonatomic, strong)XKWelfareOrderFinishViewController *finishVC;
@property(nonatomic, strong)XKWelfareOrderWaitOpenViewController *waitOpenVC;
@property(nonatomic, strong)XKWelfareOrderWinViewController *winVC;
@end

@implementation XKWelfareOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
#pragma mark 默认加载方法
- (void)handleData {
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    if(self.entryType == 0) {
    _navBar =  [[XKCustomNavBar alloc] init];
    [_navBar customNaviBarWithTitle:@"福利商城" andRightButtonTitle:@"管理" andRightColor:[UIColor whiteColor]];
    _navBar.leftButtonBlock = ^{
        [ws.finishVC restoreLayout];
        [ws.navigationController popViewControllerAnimated:YES];
    };
    _navBar.rightButtonBlock = ^(UIButton *sender){
        if([ws.navBar.rightButton.currentTitle isEqualToString:@"管理"]) {
            [ws.navBar.rightButton setTitle:@"完成" forState:0];
            [ws.finishVC updateLayout];
        } else {
            [ws.navBar.rightButton setTitle:@"管理" forState:0];
            [ws.finishVC restoreLayout];
        }
    };
    [self.view addSubview:_navBar];
    }
    [self.view addSubview:self.pageMenu];
    
}

#pragma mark 懒加载
- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        XKWeakSelf(ws);
        CGFloat y = self.entryType == 0 ? NavigationAndStatue_Height : 0;
        CGFloat h = self.entryType == 0 ? SCREEN_HEIGHT - NavigationAndStatue_Height - kBottomSafeHeight : SCREEN_HEIGHT - kIphoneXNavi(64) - TabBar_Height;
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
        _pageMenu.selectedBlock = ^(NSInteger index) {
            if(index == 2) {
                ws.navBar.rightButton.hidden = NO;
            } else {
                ws.navBar.rightButton.hidden = YES;
            }
        };
        
        _waitOpenVC = [XKWelfareOrderWaitOpenViewController new];
        _waitOpenVC.entryType = self.entryType;
        _winVC = [XKWelfareOrderWinViewController new];
        _winVC.entryType = self.entryType;
        _finishVC = [XKWelfareOrderFinishViewController new];
        _finishVC.entryType = self.entryType;
        [self addChildViewController:_waitOpenVC];
        [self addChildViewController:_winVC];
        [self addChildViewController:_finishVC];
        
        _pageMenu.titles = @[@"待开奖", @"已中奖", @"已完成"];
        _pageMenu.childViews = @[_waitOpenVC, _winVC, _finishVC];
        _pageMenu.sliderSize = CGSizeMake(68, 6);
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.numberOfTitles = 3;
        _pageMenu.titleBarHeight = 40;
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
