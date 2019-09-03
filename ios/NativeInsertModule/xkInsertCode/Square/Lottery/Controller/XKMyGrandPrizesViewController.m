//
//  XKMyGrandPrizesViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyGrandPrizesViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKMyGrandPrizesSubViewController.h"

@interface XKMyGrandPrizesViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) XKScrollPageMenuView *pageMenu;

@end

@implementation XKMyGrandPrizesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"我的大奖" WithColor:[UIColor whiteColor]];
    [self initializeViews];
    [self updateViews];
}

- (void)initializeViews {
    [self.containView addSubview:self.pageMenu];
}

- (void)updateViews {
    [self.pageMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter setter

- (XKScrollPageMenuView *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];
        XKMyGrandPrizesSubViewController *waitingChooseNumsVC = [[XKMyGrandPrizesSubViewController alloc] init];
        waitingChooseNumsVC.vcType = XKMyGrandPrizeSubVCTypeWaitingChooseNums;
        XKMyGrandPrizesSubViewController *waitingVC = [[XKMyGrandPrizesSubViewController alloc] init];
        waitingVC.vcType = XKMyGrandPrizeSubVCTypeWaiting;
        XKMyGrandPrizesSubViewController *alreadyVC = [[XKMyGrandPrizesSubViewController alloc] init];
        alreadyVC.vcType = XKMyGrandPrizeSubVCTypeAlready;
        [self addChildViewController:waitingChooseNumsVC];
        [self addChildViewController:waitingVC];
        [self addChildViewController:alreadyVC];
        _pageMenu.titles = @[@"待选号", @"待开奖", @"已开奖"];
        _pageMenu.childViews = @[waitingChooseNumsVC, waitingVC, alreadyVC];
        _pageMenu.sliderSize = CGSizeMake(68, 6);
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.numberOfTitles = 3;
        _pageMenu.titleBarHeight = 40;
        _pageMenu.titleFont = XKRegularFont(14.0);
        _pageMenu.titleSelectedFont = XKRegularFont(14.0);
        _pageMenu.titleColor = HEX_RGBA(0xFFFFFF, 0.5);
        _pageMenu.titleSelectedColor = HEX_RGB(0xFFFFFF);
        _pageMenu.sliderColor = HEX_RGB(0xFFFFFF);
    }
    return _pageMenu;
}

@end
