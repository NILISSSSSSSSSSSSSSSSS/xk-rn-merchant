//
//  XKMainBusinessAreaViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMainBusinessAreaViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKBusinessAreaOrderListViewController.h"

/*
#import "XKBusinessAreaWaitPickViewController.h"
#import "XKBusinessAreaWaitPayViewController.h"
#import "XKBusinessAreaWaitUseViewController.h"
#import "XKBusinessAreaPrepareViewController.h"
#import "XKBusinessAreaUsingViewController.h"
#import "XKBusinessAreaWaitEvaluateViewController.h"
#import "XKBusinessAreaFinishViewController.h"
#import "XKBusinessAreaRefundViewController.h"
#import "XKBusinessAreaCloseViewController.h"
*/

@interface XKMainBusinessAreaViewController ()
/*menu 视图*/
@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;

@end

@implementation XKMainBusinessAreaViewController

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
        [_navBar customNaviBarWithTitle:@"商圈订单" andRightButtonImageTitle:@""];
        [self.view addSubview:_navBar];
    }
    [self.view addSubview:self.pageMenu];
    
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
        CGFloat viewH = self.entryType == 0 ?  SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - 50: SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight - TabBar_Height - 50;
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 9; i ++) {
            XKBusinessAreaOrderListViewController *list = [XKBusinessAreaOrderListViewController new];
            list.entryType = self.entryType == 0 ? 0 : 1;
            list.orderType = i;
            [self addChildViewController:list];
            [tmpArr addObject:list];
        }
        _pageMenu.titles = @[@"待接单", @"待付款", @"待消费", @"备货中", @"进行中",@"待评价",@"已完成", @"售后中",@"已关闭"];
        _pageMenu.childViews = tmpArr;
        _pageMenu.numberOfTitles = 5;
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.titleBarHeight = 40;
        _pageMenu.sliderSize = CGSizeMake(42, 6);
        if (self.entryType == 0 ) {
            _pageMenu.titleFont = XKSemiboldFont(14);
            _pageMenu.titleSelectedFont = XKSemiboldFont(14);
            _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
            _pageMenu.titleSelectedColor = [UIColor whiteColor];
            _pageMenu.sliderColor = [UIColor whiteColor];
        } else {
            _pageMenu.titleFont = XKRegularFont(14);
            _pageMenu.titleSelectedFont = XKMediumFont(14);
            _pageMenu.titleColor = UIColorFromRGB(0x555555);
            _pageMenu.titleSelectedColor = XKMainTypeColor;
            _pageMenu.sliderColor = XKMainTypeColor;
            _pageMenu.topBgColor = [UIColor whiteColor];
        }
    }
    return _pageMenu;
}

@end
