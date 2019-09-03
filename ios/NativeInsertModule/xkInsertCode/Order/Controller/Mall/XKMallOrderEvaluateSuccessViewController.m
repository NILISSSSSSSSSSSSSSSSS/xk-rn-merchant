//
//  XKMallOrderEvaluateSuccessViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderEvaluateSuccessViewController.h"
#import "XKMineCommentRootController.h"
@interface XKMallOrderEvaluateSuccessViewController ()
/*导航栏*/
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UIButton *evaluateBtn;
@property (nonatomic, strong)UIButton *backBtn;
@end

@implementation XKMallOrderEvaluateSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    XKCustomNavBar *navBar =  [[XKCustomNavBar alloc] init];
    navBar.titleString = @"评价成功";
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
//        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//        for (UIViewController *vc in tmpArr) {
//            if ([vc isKindOfClass:NSClassFromString(@"XKMallOrderDetailWaitEvaluateViewController")])
//            {
//                [ws.navigationController popToViewController:vc animated:YES];
//                return;
//            }
//        }
         [ws.navigationController popToRootViewControllerAnimated:YES];
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.evaluateBtn];
    [self.bgView addSubview:self.backBtn];
    [self addUIContains];
}

- (void)addUIContains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(10 + kIphoneXNavi(64));
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(190);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(95, 90));
        make.top.equalTo(self.bgView.mas_top).offset(15);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(10);
    }];
    
    CGFloat pad = (SCREEN_WIDTH - 20 - 100 * 2)/3;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(pad);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(- 10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-pad);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(- 10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

- (void)evaluateBtnClick:(UIButton *)sender {
    XKMineCommentRootController *detail = [XKMineCommentRootController new];
    detail.pageType = XKMineCommentPageTypeGoods;
    detail.segmentIndex = 1;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)backBtnClick:(UIButton *)sender {

     [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark  懒加载
- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 190)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20 - 90)/2, 15, 90, 96)];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.image = [UIImage imageNamed:@"xk_ic_main_authResult"];
    }
    return _iconImgView;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.frame) + 10, SCREEN_WIDTH - 20, 20)];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17];
        _tipLabel.textColor = UIColorFromRGB(0x555555);
        _tipLabel.text = @"评价成功";
    }
    return _tipLabel;
}

- (UIButton *)evaluateBtn {
    if(!_evaluateBtn) {
        _evaluateBtn = [[UIButton alloc] init];
        _evaluateBtn.layer.cornerRadius = 4.f;
        _evaluateBtn.layer.borderWidth = 1.f;
        [_evaluateBtn setTitle:@"查看评价" forState:0];
        _evaluateBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _evaluateBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_evaluateBtn setTitleColor:XKMainTypeColor forState:0];
        _evaluateBtn.layer.masksToBounds = YES;
        [_evaluateBtn addTarget:self action:@selector(evaluateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluateBtn;
}

- (UIButton *)backBtn {
    if(!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.layer.cornerRadius = 4.f;
        _backBtn.layer.borderWidth = 1.f;
        _backBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13];
        [_backBtn setTitle:@"返回订单页" forState:0];
        _backBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        [_backBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        _backBtn.layer.masksToBounds = YES;
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
@end
