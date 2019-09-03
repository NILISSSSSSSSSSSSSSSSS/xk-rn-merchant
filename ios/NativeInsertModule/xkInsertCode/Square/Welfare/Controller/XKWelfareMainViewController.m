//
//  XKWelfareMainViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareMainViewController.h"
#import "XKCustomNavBar.h"
#import "XKWelfarePageMenu.h"
#import "XKWelfareOrderViewController.h"
#import "XKWelfareOrderWaitOpenViewController.h"
#import "XKWelfareOrderWinViewController.h"
#import "XKWelfareOrderFinishViewController.h"
#import "XKWelfareListViewController.h"
#import "XKWelfareBuyCarViewController.h"
#import "XKWelfareCategoryModel.h"
#import "XKCustomeSerMessageManager.h"
#import "XKIMGlobalMethod.h"
@interface XKWelfareMainViewController () <XKWelfarePageMenuDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)XKWelfarePageMenu *pageMenu;
@property (nonatomic, strong)XKCustomNavBar *toolsBar;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *categoryArr;
@end

@implementation XKWelfareMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self requestCategoryListDataWithTips:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)handleData {
    [super handleData];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.bgScrollView config:nil];
    [self.view addSubview:self.pageMenu];
    [self.view addSubview:self.toolsBar];
    
    
}

#pragma mark network
- (void)requestCategoryListDataWithTips:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    [XKWelfareCategoryModel requestWelfareCategotyListSuccess:^(NSArray *modelList) {
         [self handleSuccessDataWithModel:modelList];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(NSArray *)listModel {
    
    if(listModel.count > 0) {
        self.bgScrollView.hidden = YES;
        [self.emptyTipView hide];
        self.categoryArr = listModel;
        [self.view addSubview:self.pageMenu];
    } else {
        self.bgScrollView.hidden = NO;
        [self.view bringSubviewToFront:self.bgScrollView];
        self.emptyTipView.config.viewAllowTap = NO;
        [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
    }
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    XKWeakSelf(ws);
    self.bgScrollView.hidden = NO;
    [self.view bringSubviewToFront:self.bgScrollView];
    self.emptyTipView.config.viewAllowTap = YES;
    [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
        [ws requestCategoryListDataWithTips:YES];
    }];
    [XKHudView showErrorMessage:reason];
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

#pragma mark  懒加载
- (XKWelfarePageMenu *)pageMenu {
    if(!_pageMenu) {
        XKWeakSelf(ws);
//        NSMutableArray *titleArr = [NSMutableArray array];
//        [ws.categoryArr enumerateObjectsUsingBlock:^(XKWelfareCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [titleArr addObject:obj.name];
//        }];
        NSArray *titleArr = @[@"推荐", @"福利商品", @"平台大奖", @"店铺大奖"];
        CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - 40;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kIphoneXNavi(64) + 40, SCREEN_WIDTH, scrollViewH)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        for (int i = 0; i < titleArr.count; i++) {
            XKWelfareListViewController *baseVc = [[NSClassFromString(@"XKWelfareListViewController") alloc] init];
            baseVc.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
        //    baseVc.model = ws.categoryArr[i];
            baseVc.type = i;
            [self addChildViewController:baseVc];
            [self.myChildViewControllers addObject:baseVc];
            [scrollView addSubview:baseVc.view];
            baseVc.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, scrollViewH);
        }
        scrollView.contentSize = CGSizeMake(titleArr.count * SCREEN_WIDTH, 0);
        // trackerStyle:跟踪器的样式
        _pageMenu = [XKWelfarePageMenu pageMenuWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH, 40) trackerStyle:XKWelfarePageMenuPageMenuTrackerStyleLine];
        // 传递数组，默认选中第2个
        _pageMenu.permutationWay = XKWelfarePageMenuPageMenuPermutationWayNotScrollEqualWidths;
        [_pageMenu setItems:titleArr selectedItemIndex:ws.choseIndex];
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.unSelectedItemTitleColor = UIColorFromRGB(0x555555);
        _pageMenu.selectedItemTitleColor = XKMainTypeColor;
        _pageMenu.itemTitleFont = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _pageMenu.tracker.backgroundColor = XKMainTypeColor;
        // 设置代理
        _pageMenu.delegate = self;

        
        // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
        self.pageMenu.bridgeScrollView = self.scrollView;
    }
    return _pageMenu;
}

- (XKCustomNavBar *)toolsBar {
    if(!_toolsBar) {
        XKWeakSelf(ws);
        _toolsBar  =  [[XKCustomNavBar alloc] init];
        [_toolsBar customWelfareNaviBar];
        
        _toolsBar.leftButtonBlock = ^{
            [ws.navigationController popViewControllerAnimated:YES];
        };
        
        _toolsBar.messageButtonBlock = ^{
            [XKIMGlobalMethod gotoCustomerSerChatList];
        };
        
        _toolsBar.buyCarButtonBlock = ^{
            XKWelfareBuyCarViewController *buyCarVC = [XKWelfareBuyCarViewController new];
            [ws.navigationController pushViewController:buyCarVC animated:YES];
        };
        
        _toolsBar.orderButtonBlock = ^{
            XKWelfareOrderViewController *orderVC = [XKWelfareOrderViewController new];
            [ws.navigationController pushViewController:orderVC animated:YES];
        };
        
        _toolsBar.layoutButtonBlock = ^{
            XKWelfareListViewController *listVC = ws.childViewControllers[ws.pageMenu.selectedItemIndex];
            listVC.layoutType =  (listVC.layoutType == XKWelfareListLayoutSingle) ? XKWelfareListLayoutDouble : XKWelfareListLayoutSingle;
            [listVC updateLayout];
        };
    }
    return _toolsBar;
}

- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
        
    }
    return _myChildViewControllers;
}


@end
