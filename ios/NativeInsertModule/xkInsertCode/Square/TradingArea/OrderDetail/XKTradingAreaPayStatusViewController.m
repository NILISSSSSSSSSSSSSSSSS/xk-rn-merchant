//
//  XKTradingAreaPayStatusViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaPayStatusViewController.h"

@interface XKTradingAreaPayStatusViewController ()

@property (nonatomic, strong) UIView        *bgView;
@property (nonatomic, strong) UIImageView   *iconImgView;
@property (nonatomic, strong) UILabel       *stautsLabel;
@property (nonatomic, strong) UIButton      *sureBtn;

@end

@implementation XKTradingAreaPayStatusViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configNavigationBar];
    [self addCustomSubviews];
}


#pragma mark - Events

- (void)sureBtnClick:(UIButton *)sender {
    //
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Private Metheods

- (void)configNavigationBar {
    if (self.payStatus == PayStatusVC_fail || self.payStatus == PayStatusVC_success) {
        [self setNavTitle:@"支付结果" WithColor:[UIColor whiteColor]];

    } else if (self.payStatus == PayStatusVC_share) {
        [self setNavTitle:@"评价完成" WithColor:[UIColor whiteColor]];
    }
}

- (void)addCustomSubviews {
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.stautsLabel];
    [self.bgView addSubview:self.sureBtn];
    
    [self addUIContains];
}

- (void)addUIContains {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(10 + NavigationAndStatue_Height);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(213*ScreenScale);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(66*ScreenScale, 66*ScreenScale));
        make.top.equalTo(self.bgView.mas_top).offset(30*ScreenScale);
        make.centerX.equalTo(self.bgView);
    }];
    
    [self.stautsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom).offset(16*ScreenScale);
        make.left.right.equalTo(self.bgView);
        make.centerX.equalTo(self.bgView);
    }];

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(98, 30));
    }];
}


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
        if (self.payStatus == PayStatusVC_success || self.payStatus == PayStatusVC_share) {
            _iconImgView.image = [UIImage imageNamed:@"xk_btn_personal_success"];
        } else if (self.payStatus == PayStatusVC_fail) {
            _iconImgView.image = [UIImage imageNamed:@"xk_coin_pay_fail"];
        }
    }
    return _iconImgView;
}


- (UILabel *)stautsLabel {
    if(!_stautsLabel) {
        _stautsLabel = [[UILabel alloc] init];
        _stautsLabel.textAlignment = NSTextAlignmentCenter;
        _stautsLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17];
        _stautsLabel.textColor = UIColorFromRGB(0x222222);
        
        if (self.payStatus == PayStatusVC_success) {
            _stautsLabel.text = @"支付成功";
        } else if (self.payStatus == PayStatusVC_fail) {
            _stautsLabel.text = @"支付失败";
        } else if (self.payStatus == PayStatusVC_share) {
            _stautsLabel.text = @"感谢您的评价";
        }
    }
    return _stautsLabel;
}

- (UIButton *)sureBtn {
    
    if(!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.layer.cornerRadius = 5.f;
        _sureBtn.layer.borderWidth = 1.f;
        _sureBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13];
        if (self.payStatus == PayStatusVC_success) {
            [_sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        } else if (self.payStatus == PayStatusVC_fail) {
            [_sureBtn setTitle:@"重新支付" forState:UIControlStateNormal];
        } else if (self.payStatus == PayStatusVC_share) {
            [_sureBtn setTitle:@"分享" forState:UIControlStateNormal];
        }
        [_sureBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _sureBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end







