//
//  XKWelfareBuySuccessViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareBuySuccessViewController.h"
#import "XKBuySuccessView.h"
#import "XKWelfareOrderViewController.h"
@interface XKWelfareBuySuccessViewController ()
@property (nonatomic, strong) XKBuySuccessView  *centerView;
@end

@implementation XKWelfareBuySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self handleData];
    [self addCustomSubviews];
}

- (void)handleData {
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    XKCustomNavBar *navBar =  [[XKCustomNavBar alloc] init];
    navBar.titleString = @"兑奖成功";
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.centerView];
}

- (XKBuySuccessView *)centerView {
    if (!_centerView) {
        XKWeakSelf(ws);
        _centerView = [[XKBuySuccessView alloc] initWithFrame:CGRectMake(10, NavigationAndStatue_Height + 10, SCREEN_WIDTH - 20, 263 * ScreenScale)];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 6.0;
        _centerView.layer.shadowRadius = 6.0;
        _centerView.layer.shadowColor = HEX_RGB(0xd7d7d7).CGColor;
        _centerView.layer.shadowOffset = CGSizeMake(0.0, 0.5);
        _centerView.layer.shadowOpacity = 1.0;
        
        _centerView.orderBlock = ^(UIButton * _Nonnull sender) {
            XKWelfareOrderViewController *orderVC = [XKWelfareOrderViewController new];
            [ws.navigationController pushViewController:orderVC animated:YES];
        };
        
        _centerView.keepBlock = ^(UIButton * _Nonnull sender) {
            
            for (UIViewController *vc in ws.navigationController.childViewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"XKWelfareMainViewController")]) {
                    [ws.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        };
        
        _centerView.gorundBlock = ^(UIButton * _Nonnull sender) {
            
            for (UIViewController *vc in ws.navigationController.childViewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"XKSquareRootViewController")]) {
                    [ws.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
        };
        
        
    }
    return _centerView;
}
@end
