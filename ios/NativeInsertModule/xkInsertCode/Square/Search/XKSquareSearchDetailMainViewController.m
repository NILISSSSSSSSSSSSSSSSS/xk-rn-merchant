//
//  XKSquareSearchDetailMainViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareSearchDetailMainViewController.h"
#import "XKWelfarePageMenu.h"
#import "XKSqureSearchViewController.h"


@interface XKSquareSearchDetailMainViewController () <XKWelfarePageMenuDelegate,UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) XKWelfarePageMenu  *pageMenu;
@property (nonatomic, strong) XKCustomSearchBar  *searchBar;
@property (nonatomic, strong) NSMutableArray     *myChildViewControllers;
@property (nonatomic, strong) UIScrollView       *scrollView;
@property (nonatomic, assign) CGFloat             pageMenuH;


@end

@implementation XKSquareSearchDetailMainViewController

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
    
    [self setNaviCustomView:self.searchBar withframe:CGRectMake(60, 0, SCREEN_WIDTH - 80, 30)];
    
}

- (void)backBtnClick {
    if (self.searchType == SearchMainEntryType_Area) {
        if (self.navigationController.viewControllers.count >= 2) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        }
    }else{
        if (self.navigationController.viewControllers.count >= 1) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        }
//        [super backBtnClick];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    XKSqureSearchViewController * vc = [[XKSqureSearchViewController alloc]init];
    if (self.searchType == SearchMainEntryType_Area) {
    }else {
        vc.searchText = _searchText;
    }
    vc.searchType = (NSUInteger)self.searchType;
    [self.navigationController pushViewController:vc animated:NO];
    return NO;
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
    CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - self.pageMenuH;
    targetViewController.view.frame = CGRectMake(SCREEN_WIDTH * toIndex, 0, SCREEN_WIDTH, scrollViewH);
    [_scrollView addSubview:targetViewController.view];
    
}



#pragma mark - Getters and Setters

- (XKWelfarePageMenu *)pageMenu {
    if(!_pageMenu) {
        NSArray *dataArr = nil;
        NSArray *controllerClassNames = nil;
        if (self.searchType == SearchMainEntryType_Home) {
            dataArr = @[@"综合", @"福利", @"商城", @"商圈"];
            controllerClassNames = @[@"XKSquareSearchSynthesisListViewController",
                                              @"XKSquareSearchWelfareListViewController",
                                              @"XKSquareSearchStoreListViewController",
                                              @"XKSquareSearchTradingAreaListViewController"];
        } else if (self.searchType == SearchMainEntryType_Welfare) {
            dataArr = @[@"福利"];
            controllerClassNames = @[@"XKSquareSearchWelfareListViewController"];
        } else if (self.searchType == SearchMainEntryType_Mall) {
            dataArr = @[@"商城"];
            controllerClassNames = @[@"XKSquareSearchStoreListViewController"];
        } else if (self.searchType == SearchMainEntryType_Area) {
            dataArr = @[@"商圈"];
            controllerClassNames = @[@"XKSquareSearchTradingAreaListViewController"];
        }
       
        self.pageMenuH = dataArr.count > 1 ? 40 : 0;
        // trackerStyle:跟踪器的样式
        _pageMenu = [XKWelfarePageMenu pageMenuWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH, self.pageMenuH) trackerStyle:XKWelfarePageMenuPageMenuTrackerStyleLine];
        _pageMenu.hidden = dataArr.count <= 1;
        // 传递数组，默认选中第0个

        [_pageMenu setItems:dataArr selectedItemIndex:0];
        _pageMenu.itemPadding = SCREEN_WIDTH/(dataArr.count * 2);

        for (int i = 0; i < controllerClassNames.count; i++) {
            BaseViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            [self addChildViewController:baseVc];
            [self.myChildViewControllers addObject:baseVc];
            [_pageMenu setWidth:SCREEN_WIDTH/(dataArr.count * 2) forItemAtIndex:i];
        }

        _pageMenu.needTextColorGradients = NO;
        _pageMenu.unSelectedItemTitleColor = UIColorFromRGB(0x555555);
        _pageMenu.selectedItemTitleColor = XKMainTypeColor;
        _pageMenu.itemTitleFont = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _pageMenu.tracker.backgroundColor = XKMainTypeColor;
        // 设置代理
        _pageMenu.delegate = self;
        CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - self.pageMenuH;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kIphoneXNavi(64) + self.pageMenuH, SCREEN_WIDTH, scrollViewH)];
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



- (XKCustomSearchBar *)searchBar {
    
    if (!_searchBar) {
        _searchBar = [[XKCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 30)];
        [_searchBar setTextFieldWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] tintColor:HEX_RGB(0xFFFFFF) textFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:[UIColor whiteColor] textPlaceholderColor:HEX_RGB(0xFFFFFF) textAlignment:NSTextAlignmentLeft masksToBounds:YES];
        _searchBar.textField.text = _searchText;
        _searchBar.textField.returnKeyType = UIReturnKeySearch;
        _searchBar.textField.delegate = self;
    }
    return _searchBar;
}


- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
        
    }
    return _myChildViewControllers;
}
@end
