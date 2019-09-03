//
//  XKMineEditPayPasswordViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineEditPayPasswordViewController.h"
#import "XKPayPasswordView.h"
#import "XKVerifyPhoneNumberViewController.h"
#import "XKAlertUtil.h"
#import "XKChangePhonenumViewController.h"

@interface XKMineEditPayPasswordViewController () <XKPayPasswordViewDelegate>

@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) XKPayPasswordView *payPasswordView;
@property (nonatomic, strong) UIButton *forgotButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSString *inputPayPassword;

@end

@implementation XKMineEditPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.payPasswordView startInputPayPassword];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XKPayPasswordViewDelegate

/** 输入密码回调 */
- (void)payPasswordView:(XKPayPasswordView *)payPasswordView inputPasswordString:(NSString *)inputString {
    self.inputPayPassword = inputString;
}

/** 点击键盘【完成】按钮回调 */
- (void)payPasswordView:(XKPayPasswordView *)payPasswordView didClickConfirmButton:(UIButton *)sender inputString:(NSString *)inputString {
    [self clickConfirmButton:sender];
}

#pragma mark - private methods

- (void)initializeViews {
    
    switch (self.state) {
        case XKMineEditPayPasswordViewControllerStateSetPayPassword: {
            [self setNavTitle:@"设置支付密码" WithColor:[UIColor whiteColor]];
            self.describeLabel.text = @"请设置您的支付密码";
            self.confirmButton.hidden = YES;
            self.forgotButton.hidden = YES;
            break;
        }
        case XKMineEditPayPasswordViewControllerStateVerifyPayPassword: {
            [self setNavTitle:@"修改支付密码" WithColor:[UIColor whiteColor]];
            self.describeLabel.text = @"请输入您当前的支付密码";
            self.confirmButton.hidden = YES;
            self.forgotButton.hidden = NO;
            break;
        }
        case XKMineEditPayPasswordViewControllerStateChangePayPassword: {
            [self setNavTitle:@"修改支付密码" WithColor:[UIColor whiteColor]];
            self.describeLabel.text = @"请设置新的支付密码";
            self.confirmButton.hidden = YES;
            self.forgotButton.hidden = YES;
            break;
        }
        case XKMineEditPayPasswordViewControllerStateConfirmPayPassword: {
            [self setNavTitle:@"设置支付密码" WithColor:[UIColor whiteColor]];
            self.describeLabel.text = @"请再次输入";
            self.confirmButton.hidden = NO;
            self.forgotButton.hidden = YES;
            break;
        }
    }

    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(28);
        make.left.equalTo(self.view.mas_left).offset(18);
    }];
    
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payPasswordView.mas_bottom).offset(10);
        make.trailing.equalTo(self.payPasswordView.mas_trailing);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payPasswordView.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - events


/** 点击【忘记密码】 */
- (void)clickForgotButton:(UIButton *)sender {
    
    // 验证绑定手机号
    NSString *phoneNum = [XKUserInfo currentUser].phone;
    if (!phoneNum || phoneNum.length == 0) {
        // 未绑定手机号
        [XKAlertUtil presentAlertViewWithTitle:nil message:@"您还未绑定手机号，是否立即绑定" cancelTitle:@"取消" defaultTitle:@"去绑定" distinct:NO cancel:^{
            return;
        } confirm:^{
            XKChangePhonenumViewController *changePhoncenumViewController = [XKChangePhonenumViewController new];
            changePhoncenumViewController.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
            [self.navigationController pushViewController:changePhoncenumViewController animated:YES];
        }];
    } else {
        // 已绑定手机号
        XKVerifyPhoneNumberViewController *verifyPhoneNumberViewController = [XKVerifyPhoneNumberViewController new];
        verifyPhoneNumberViewController.state = XKVerifyPhoneNumberViewControllerStateChangePayPassword;
        verifyPhoneNumberViewController.phoneNum = phoneNum;
        [self.navigationController pushViewController:verifyPhoneNumberViewController animated:YES];
    }
}

/** 点击【保存】 */
- (void)clickConfirmButton:(UIButton *)sender {

    switch (self.state) {
        // 跳转确认新密码
        case XKMineEditPayPasswordViewControllerStateSetPayPassword:
        case XKMineEditPayPasswordViewControllerStateChangePayPassword: {
            XKMineEditPayPasswordViewController *editPayPasswordViewController = [XKMineEditPayPasswordViewController new];
            editPayPasswordViewController.state = XKMineEditPayPasswordViewControllerStateConfirmPayPassword;
            editPayPasswordViewController.lastStapInputPasswordString = self.inputPayPassword;
            [self.navigationController pushViewController:editPayPasswordViewController animated:YES];
            break;
        }
            
        // 校验支付密码
        case XKMineEditPayPasswordViewControllerStateVerifyPayPassword: {
            NSDictionary *params = @{@"textPassword": self.inputPayPassword};
            [HTTPClient postEncryptRequestWithURLString:GetPaySecurityVerifyUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
                
                // 校验通过
                XKMineEditPayPasswordViewController *editPayPasswordViewController = [XKMineEditPayPasswordViewController new];
                editPayPasswordViewController.state = XKMineEditPayPasswordViewControllerStateChangePayPassword;
                [self.navigationController pushViewController:editPayPasswordViewController animated:YES];
                
            } failure:^(XKHttpErrror *error) {
                [XKHudView showErrorMessage:error.message];
            }];
            break;
        }
            
        // 设置支付密码
        case XKMineEditPayPasswordViewControllerStateConfirmPayPassword: {
            if (self.lastStapInputPasswordString && ![self.lastStapInputPasswordString isEqualToString:@""]) {
                if (![self.lastStapInputPasswordString isEqualToString:self.inputPayPassword]) {
                    [XKHudView showErrorMessage:@"两次输入的支付密码不一致"];
                    return;
                }
            }
            NSDictionary *params = @{@"textPassword": self.inputPayPassword};
            [HTTPClient postEncryptRequestWithURLString:GetSetPaySecurityUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
                [XKHudView showErrorMessage:@"设置成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
                    UIViewController *targetViewController = [self.navigationController.viewControllers objectAtIndex:index - 3];
                    [self.navigationController popToViewController:targetViewController animated:YES];
                });
            } failure:^(XKHttpErrror *error) {
                [XKHudView showErrorMessage:error.message];
            }];
            break;
        }
    }
}

#pragma mark - setter and getter

- (UILabel *)describeLabel {
    
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.textColor = [UIColor lightGrayColor];
        _describeLabel.numberOfLines = 0;
        _describeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [self.view addSubview:_describeLabel];
    }
    return _describeLabel;
}

- (XKPayPasswordView *)payPasswordView {
    
    if (!_payPasswordView) {
        _payPasswordView = [XKPayPasswordView addPayPasswordViewToView:self.view];
        _payPasswordView.delegate = self;
    }
    return _payPasswordView;
}


- (UIButton *)forgotButton {
    
    if (!_forgotButton) {
        _forgotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgotButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _forgotButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [_forgotButton addTarget:self action:@selector(clickForgotButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgotButton];
    }
    return _forgotButton;
}

- (UIButton *)confirmButton {
    
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"保 存" forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.backgroundColor = XKMainTypeColor;
        [_confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
