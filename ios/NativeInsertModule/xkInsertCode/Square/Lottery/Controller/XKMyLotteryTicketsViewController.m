//
//  XKMyLotteryTicketsViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyLotteryTicketsViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKMyLotteryTicketsSubViewController.h"

@interface XKMyLotteryTicketsViewController ()

@property (nonatomic, strong) XKScrollPageMenuView *pageMenu;

@end

@implementation XKMyLotteryTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"我的奖券" WithColor:[UIColor whiteColor]];
    [self.containView addSubview:self.pageMenu];
}

- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];
        XKMyLotteryTicketsSubViewController *vc1 = [XKMyLotteryTicketsSubViewController new];
        vc1.vcType = XKMyLotteryTicketsVCTypeActivity;
        XKMyLotteryTicketsSubViewController *vc2 = [XKMyLotteryTicketsSubViewController new];
        vc2.vcType = XKMyLotteryTicketsVCTypePlatform;
        XKMyLotteryTicketsSubViewController *vc3 = [XKMyLotteryTicketsSubViewController new];
        vc3.vcType = XKMyLotteryTicketsVCTypeMerchant;
        _pageMenu.titles = @[@"活动券", @"平台券", @"商铺券"];
        [self addChildViewController:vc1];
        [self addChildViewController:vc2];
        [self addChildViewController:vc3];
        _pageMenu.childViews = @[vc1, vc2, vc3];
        _pageMenu.sliderSize = CGSizeMake(70, 6);
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
        _pageMenu.titleSelectedColor = [UIColor whiteColor];
        _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        _pageMenu.sliderColor = [UIColor whiteColor];
        _pageMenu.numberOfTitles = _pageMenu.titles.count;
        _pageMenu.titleBarHeight = 40;
    }
    return _pageMenu;
}

@end
