//
//  XKTradingAreaSotreActivityMainViewController.m
//  XKSquare
//
//  Created by hupan on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaSotreActivityMainViewController.h"
#import "XKTradingAreaSotreActivityListViewController.h"
#import "XKWelfarePageMenu.h"


@interface XKTradingAreaSotreActivityMainViewController () <XKWelfarePageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) XKWelfarePageMenu  *pageMenu;
@property (nonatomic, strong) NSMutableArray     *myChildViewControllers;
@property (nonatomic, strong) UIScrollView       *scrollView;
@end

@implementation XKTradingAreaSotreActivityMainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self.view addSubview:self.pageMenu];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Private Metheods
- (void)configNavigationBar {
    [self setNavTitle:@"商家优惠" WithColor:[UIColor whiteColor]];
    
}



#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(XKWelfarePageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(XKWelfarePageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - 40;
    targetViewController.view.frame = CGRectMake(SCREEN_WIDTH * toIndex, 0, SCREEN_WIDTH, scrollViewH);
    [_scrollView addSubview:targetViewController.view];
    
}



#pragma mark - Getters and Setters

- (XKWelfarePageMenu *)pageMenu {
    if(!_pageMenu) {
        
        // trackerStyle:跟踪器的样式
        _pageMenu = [XKWelfarePageMenu pageMenuWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH, 40) trackerStyle:XKWelfarePageMenuPageMenuTrackerStyleLine];
        _pageMenu.backgroundColor = XKMainTypeColor;
        // 传递数组，默认选中第0个
        NSArray *dataArr = @[@"抽奖", @"优惠券", @"会员卡"];
        [_pageMenu setItems:dataArr selectedItemIndex:0];
        _pageMenu.itemPadding = SCREEN_WIDTH/(dataArr.count * 2);
        NSArray *controllerClassNames = @[@"XKTradingAreaSotreActivityListViewController",
                                          @"XKTradingAreaSotreActivityListViewController",
                                          @"XKTradingAreaSotreActivityListViewController"];
        for (int i = 0; i < controllerClassNames.count; i++) {
            XKTradingAreaSotreActivityListViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            baseVc.activityListType = i;
            baseVc.shopId = self.shopId;
            [self addChildViewController:baseVc];
            [self.myChildViewControllers addObject:baseVc];
            [_pageMenu setWidth:SCREEN_WIDTH/(dataArr.count * 2) forItemAtIndex:i];
        }

        _pageMenu.needTextColorGradients = NO;
        _pageMenu.unSelectedItemTitleColor = [UIColor colorWithWhite:1 alpha:0.5];
        _pageMenu.selectedItemTitleColor = [UIColor colorWithWhite:1 alpha:1];
        _pageMenu.itemTitleFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        _pageMenu.tracker.backgroundColor = [UIColor whiteColor];
        // 设置代理
        _pageMenu.delegate = self;
        CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - 40;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kIphoneXNavi(64) + 40, SCREEN_WIDTH, scrollViewH)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
        self.pageMenu.bridgeScrollView = self.scrollView;
        
        // pageMenu.selectedItemIndex就是选中的item下标
        if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
            BaseViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
            [scrollView addSubview:baseVc.view];
            baseVc.view.frame = CGRectMake(SCREEN_WIDTH * _pageMenu.selectedItemIndex, 0, SCREEN_WIDTH, scrollViewH);
            scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * self.pageMenu.selectedItemIndex, 0);
            scrollView.contentSize = CGSizeMake(dataArr.count * SCREEN_WIDTH, 0);
        }
        
    }
    return _pageMenu;
}

- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
        
    }
    return _myChildViewControllers;
}
@end
