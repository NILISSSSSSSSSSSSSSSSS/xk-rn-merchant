//
//  XKTradingAreaOrderReserveStatusViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderReserveStatusViewController.h"
#import "XKTradingAreaOrderDetailViewController.h"

@interface XKTradingAreaOrderReserveStatusViewController ()

@property (nonatomic, strong) UIView        *bgView;
@property (nonatomic, strong) UIImageView   *iconImgView;
@property (nonatomic, strong) UILabel       *stautsLabel;
@property (nonatomic, strong) UILabel       *tipLabel;

@property (nonatomic, strong) UIButton      *lookOrderDetailBtn;
@property (nonatomic, strong) UIButton      *backBtn;

@end

@implementation XKTradingAreaOrderReserveStatusViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configNavigationBar];
    [self addCustomSubviews];
}


#pragma mark - Events

- (void)lookOrderDetailBtnClick:(UIButton *)sender {
    //查看订单详情
    XKTradingAreaOrderDetailViewController *vc = [[XKTradingAreaOrderDetailViewController alloc] init];
    vc.orderId = self.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backBtnClick {
    [self backButtonClicked:nil];
}

- (void)backButtonClicked:(UIButton *)sender {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"XKStoreRecommendViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"预约成功" WithColor:[UIColor whiteColor]];
}

- (void)addCustomSubviews {
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.stautsLabel];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.lookOrderDetailBtn];
    [self.bgView addSubview:self.backBtn];
    
    [self addUIContains];
}

- (void)addUIContains {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10 + NavigationAndStatue_Height);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(232);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66, 66));
        make.top.equalTo(self.bgView.mas_top).offset(30);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.stautsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(16);
        make.left.right.equalTo(self.bgView);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.stautsLabel.mas_bottom).offset(10);
    }];


    [self.lookOrderDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        make.left.equalTo(self.bgView.mas_left).offset(54);
        make.size.mas_equalTo(CGSizeMake(108, 30));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        make.right.equalTo(self.bgView.mas_right).offset(-54);
        make.size.mas_equalTo(CGSizeMake(108, 30));
    }];
    
    
}


#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSoure

#pragma mark - Custom Delegates

#pragma mark - Getters and Setters

- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5.0f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.image = [UIImage imageNamed:@"xk_btn_personal_success"];
    }
    return _iconImgView;
}


- (UILabel *)stautsLabel {
    if(!_stautsLabel) {
        _stautsLabel = [[UILabel alloc] init];
        _stautsLabel.textAlignment = NSTextAlignmentCenter;
        _stautsLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17];
        _stautsLabel.textColor = UIColorFromRGB(0x222222);
        _stautsLabel.text = @"已预约";
    }
    return _stautsLabel;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = UIColorFromRGB(0x555555);
        _tipLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _tipLabel.text = @"预约已提交，等待商家接单";
    }
    return _tipLabel;
}


- (UIButton *)lookOrderDetailBtn {
    
    if(!_lookOrderDetailBtn) {
        _lookOrderDetailBtn = [[UIButton alloc] init];

        [_lookOrderDetailBtn setTitle:@"查看订单详情" forState:UIControlStateNormal];
        [_lookOrderDetailBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _lookOrderDetailBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        
        _lookOrderDetailBtn.layer.cornerRadius = 5.f;
        _lookOrderDetailBtn.layer.borderWidth = 1.f;
        _lookOrderDetailBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        _lookOrderDetailBtn.layer.masksToBounds = YES;
        [_lookOrderDetailBtn addTarget:self action:@selector(lookOrderDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookOrderDetailBtn;
}

- (UIButton *)backBtn {
    
    if(!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.layer.cornerRadius = 5.f;
        _backBtn.layer.borderWidth = 1.f;
        _backBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];

        _backBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _backBtn.layer.masksToBounds = YES;
        [_backBtn addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


@end







