//
//  XKCardOrCouponReceiveCenterViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKCardOrCouponReceiveCenterViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKCardOrCouponReceiveCenterSubViewController.h"
#import "XKMineCouponPackageCardViewController.h"

@interface XKCardOrCouponReceiveCenterViewController ()

@property (nonatomic, strong) XKScrollPageMenuView *pageMenu;

@end

@implementation XKCardOrCouponReceiveCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"领券中心" WithColor:[UIColor whiteColor]];
    UIButton *myCardPackageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myCardPackageBtn.titleLabel.font = XKRegularFont(18.0);
    [myCardPackageBtn setTitle:@"我的卡包" forState:UIControlStateNormal];
    [myCardPackageBtn addTarget:self action:@selector(myCardPackageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    CGSize myCardPackageBtnSize = [myCardPackageBtn.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : myCardPackageBtn.titleLabel.font} context:nil].size;
    [self setRightView:myCardPackageBtn withframe:CGRectMake(0.0, 0.0, myCardPackageBtnSize.width + 10.0, 36.0)];
    
    [self.containView addSubview:self.pageMenu];
}

- (void)myCardPackageBtnAction {
    XKMineCouponPackageCardViewController *vc = [[XKMineCouponPackageCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];
        XKCardOrCouponReceiveCenterSubViewController *vc1 = [XKCardOrCouponReceiveCenterSubViewController new];
        vc1.vcType = XKCardOrCouponReceiveCenterSubVCTypeXKCard;
        XKCardOrCouponReceiveCenterSubViewController *vc2 = [XKCardOrCouponReceiveCenterSubViewController new];
        vc2.vcType = XKCardOrCouponReceiveCenterSubVCTypeMerchantCard;
        XKCardOrCouponReceiveCenterSubViewController *vc3 = [XKCardOrCouponReceiveCenterSubViewController new];
        vc3.vcType = XKCardOrCouponReceiveCenterSubVCTypeXKCoupon;
        XKCardOrCouponReceiveCenterSubViewController *vc4 = [XKCardOrCouponReceiveCenterSubViewController new];
        vc4.vcType = XKCardOrCouponReceiveCenterSubVCTypeMerchantCoupon;
        _pageMenu.titles = @[@"晓可卡", @"商户卡", @"晓可券",  @"商户券"];
        [self addChildViewController:vc1];
        [self addChildViewController:vc2];
        [self addChildViewController:vc3];
        [self addChildViewController:vc4];
        _pageMenu.childViews = @[vc1, vc2, vc3, vc4];
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
