//
//  XKMallGoodsOponionResultViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallGoodsOponionResultViewController.h"

#import "XKEmptyPlaceView.h"
#import "UIImage+Edit.h"
#import "XKRealNameAuthController.h"

@interface XKMallGoodsOponionResultViewController ()
/**<##>*/
@property(nonatomic, strong) XKEmptyPlaceView *resultView;
@end

@implementation XKMallGoodsOponionResultViewController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];

}


#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navigationView.hidden = NO;
    [self setNavTitle:@"提交成功" WithColor:[UIColor whiteColor]];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view insertSubview:scrollView belowSubview:self.navigationView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
    config.btnColor = [UIColor whiteColor];
    config.btnFont = XKRegularFont(17);
    config.descriptionColor = HEX_RGB(0x777777);
    config.descriptionFont = XKRegularFont(14);
    config.btnMargin = 10;
    config.btnBackImg = HEX_RGB(0x4A90FA);
    config.spaceHeight = 10;
//    config.verticalOffset = - 0;
    _resultView = [XKEmptyPlaceView configScrollView:scrollView config:config];
}

- (void)viewDidLayoutSubviews {
    [_resultView showWithImgName:@"xk_ic_main_authResult" title:@"" des:@"\n您已提交成功\n" btnText:@"返回" btnImg:nil tapClick:^{
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"XKMallGoodsDetailViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
            
            if ([vc isKindOfClass:NSClassFromString(@"XKWelfareGoodsDetailViewController")]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }];
}

@end
