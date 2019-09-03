//
//  XKPayForMallViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPayForMallViewController.h"
#import "XKPayPasswordView.h"
#import "XKMallOrderPayResultViewController.h"
@interface XKPayForMallViewController ()<XKPayPasswordViewDelegate>
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) XKPayPasswordView *payPasswordView;
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) XKCustomNavBar *navBar;
@end

@implementation XKPayForMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.payPasswordView startInputPayPassword];
}

- (void)handleData {
    [super handleData];

}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"支付" andRightButtonImageTitle:@""];
    
    [self.view addSubview:_navBar];
    [self.view addSubview:self.titlelabel];
    [self.view addSubview:self.priceLabel];
    [self.view addSubview:self.payPasswordView];
    [self.view addSubview:self.tipLabel];
    
    [self addUIConstraint];
}

- (void)addUIConstraint {
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(35 + kIphoneXNavi(64));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titlelabel.mas_bottom).offset(5);
    }];
    
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(55);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.payPasswordView.mas_bottom).offset(10);
    }];
}

#pragma mark  代理
- (void)payPasswordView:(XKPayPasswordView *)payPasswordView didClickConfirmButton:(UIBarButtonItem *)sender inputString:(NSString *)inputString {
    if (self.payResult) {
        self.payResult(YES);
    }
}

#pragma lazy
- (UILabel *)titlelabel {
    if(!_titlelabel) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.textColor = UIColorFromRGB(0x222222);
        _titlelabel.font = XKRegularFont(17);
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.text = @"支付金额";
    }
    return _titlelabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = UIColorFromRGB(0xee6161);
        _priceLabel.font = XKMediumFont(24);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.text = @"¥8880.00";
    }
    return _priceLabel;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = UIColorFromRGB(0x777777);
        _tipLabel.font = XKRegularFont(14);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"输入支付密码";
    }
    return _tipLabel;
}

- (XKPayPasswordView *)payPasswordView {
    
    if (!_payPasswordView) {
        _payPasswordView = [XKPayPasswordView addPayPasswordViewToView:self.view];
        _payPasswordView.delegate = self;
    }
    return _payPasswordView;
}


@end
