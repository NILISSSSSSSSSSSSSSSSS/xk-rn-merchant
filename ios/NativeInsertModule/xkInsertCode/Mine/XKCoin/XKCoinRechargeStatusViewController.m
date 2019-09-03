//
//  XKCoinRechargeStatusViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCoinRechargeStatusViewController.h"

@interface XKCoinRechargeStatusViewController ()

@property (nonatomic, strong) UIView        *bgView;
@property (nonatomic, strong) UIImageView   *iconImgView;
@property (nonatomic, strong) UILabel       *stautsLabel;
@property (nonatomic, strong) UILabel       *tipLabel;
@property (nonatomic, strong) UIButton      *tipBtn;
@property (nonatomic, strong) UIButton      *lookSquareBtn;
@property (nonatomic, strong) UIButton      *rePlayBtn;

@end

@implementation XKCoinRechargeStatusViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configNavigationBar];
    [self addCustomSubviews];
}


#pragma mark - Events

- (void)lookSquareBtnClick:(UIButton *)sender {
    //
    NSLog(@"----去商城-----");
}

- (void)rePlayBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tipBtnClick:(UIButton *)sender {
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"XKCoinViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"扫一扫充值" WithColor:[UIColor whiteColor]];
}

- (void)addCustomSubviews {
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.stautsLabel];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.tipBtn];
    [self.bgView addSubview:self.lookSquareBtn];
    
    if (self.rechargeStatusVC == RechargeStatusVC_success) {
        [self.lookSquareBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        self.lookSquareBtn.layer.borderColor = XKMainTypeColor.CGColor;
        self.iconImgView.image = [UIImage imageNamed:@"xk_btn_personal_success"];
        self.stautsLabel.text = @"支付成功";
        
    } else if (self.rechargeStatusVC == RechargeStatusVC_fail) {
        
        [self.lookSquareBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        self.lookSquareBtn.layer.borderColor = HEX_RGB(0x999999).CGColor;
        self.iconImgView.image = [UIImage imageNamed:@"xk_coin_pay_fail"];
        self.stautsLabel.text = @"支付失败";

        [self.bgView addSubview:self.rePlayBtn];
    }
    
    [self addUIContains];
}

- (void)addUIContains {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(10 + NavigationAndStatue_Height);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(252*ScreenScale);
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
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.stautsLabel.mas_bottom).offset(10);
    }];
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.top.equalTo(self.stautsLabel.mas_bottom).offset(10);
    }];
    
    if (self.rechargeStatusVC == RechargeStatusVC_success) {
        
        [self.lookSquareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake(98, 30));
            make.centerX.equalTo(self.bgView);
        }];
        
    } else if (self.rechargeStatusVC == RechargeStatusVC_fail) {
        
        [self.lookSquareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
            make.left.equalTo(self.bgView.mas_left).offset(45);
            make.size.mas_equalTo(CGSizeMake(98, 30));
        }];
        
        [self.rePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
            make.right.equalTo(self.bgView.mas_right).offset(-45);
            make.size.mas_equalTo(CGSizeMake(98, 30));
        }];
    }
    
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
    }
    return _iconImgView;
}


- (UILabel *)stautsLabel {
    if(!_stautsLabel) {
        _stautsLabel = [[UILabel alloc] init];
        _stautsLabel.textAlignment = NSTextAlignmentCenter;
        _stautsLabel.font = [UIFont fontWithName:XK_PingFangSC_Medium size:17];
        _stautsLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _stautsLabel;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = UIColorFromRGB(0x222222);
        _tipLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];

        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"您可去 钱包-晓可币 中查看余额"];
        [attString addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14], NSForegroundColorAttributeName:XKMainTypeColor} range:NSMakeRange(4, 6)];
        _tipLabel.attributedText = attString;
    }
    return _tipLabel;
}

- (UIButton *)tipBtn {
    if(!_tipBtn) {
        _tipBtn = [[UIButton alloc] init];
        [_tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}

- (UIButton *)lookSquareBtn {
    
    if(!_lookSquareBtn) {
        _lookSquareBtn = [[UIButton alloc] init];
        _lookSquareBtn.layer.cornerRadius = 5.f;
        _lookSquareBtn.layer.borderWidth = 1.f;
        [_lookSquareBtn setTitle:@"逛逛广场" forState:UIControlStateNormal];
        [_lookSquareBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _lookSquareBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];

        _lookSquareBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _lookSquareBtn.layer.masksToBounds = YES;
        [_lookSquareBtn addTarget:self action:@selector(lookSquareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookSquareBtn;
}

- (UIButton *)rePlayBtn {
    
    if(!_rePlayBtn) {
        _rePlayBtn = [[UIButton alloc] init];
        _rePlayBtn.layer.cornerRadius = 5.f;
        _rePlayBtn.layer.borderWidth = 1.f;
        _rePlayBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:13];
        [_rePlayBtn setTitle:@"重新支付" forState:UIControlStateNormal];
        [_rePlayBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];

        _rePlayBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _rePlayBtn.layer.masksToBounds = YES;
        [_rePlayBtn addTarget:self action:@selector(rePlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rePlayBtn;
}


@end







