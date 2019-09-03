//
//  XKMineFingerprintPaymentViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineFingerprintPaymentViewController.h"
#import "XKPayPasswordView.h"
#import "XKAlertView.h"
#import "XKVerifyPhoneNumberViewController.h"
#import "XKAlertUtil.h"
#import "XKChangePhonenumViewController.h"

static const CGFloat kMineFingerprintPaymentViewControllerPayPasswordSuperViewHeight = 138.0;

@interface XKMineFingerprintPaymentViewController () <XKPayPasswordViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *describePartOneLabel;
@property (nonatomic, strong) UILabel *describePartTwoLabel;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, strong) UIView *payPasswordContainerView;
@property (nonatomic, strong) XKPayPasswordView *payPasswordView;

@end

@implementation XKMineFingerprintPaymentViewController

- (void)dealloc {
    
    if (self.state == XKMineFingerprintPaymentViewControllerStateNotAvailable) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XKPayPasswordViewDelegate

// 支付密码输入完毕
- (void)payPasswordView:(XKPayPasswordView *)payPasswordView didClickConfirmButton:(UIBarButtonItem *)sender inputString:(NSString *)inputString {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [payPasswordView stopInputPayPassword];
        NSString *url;
        if (self.type == XKMineFingerprintPaymentViewControllerTypeTouchId) {
            url = GetOpenFingerPayUrl;
        } else {
            url = GetOpenFaceRecognitionUrl;
        }
        NSDictionary *params = @{@"textPassword": inputString};
        [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:params success:^(id responseObject) {
            
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            NSString *serverCheckCode;
            NSString *faceRecognitionKey = dataDict[@"faceRecognitionKey"];
            NSString *fingerprintKey = dataDict[@"fingerprintKey"];
            NSString *userId = dataDict[@"userId"];
            if (faceRecognitionKey && [faceRecognitionKey isKindOfClass:[NSString class]]) {
                if (faceRecognitionKey.length != 0) {
                    serverCheckCode = faceRecognitionKey;
                }
            }
            if (fingerprintKey && [fingerprintKey isKindOfClass:[NSString class]]) {
                if (fingerprintKey.length != 0) {
                    serverCheckCode = fingerprintKey;
                }
            }
            
            if ([[XKDataBase instance] existsTable:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable]) {
                if ([[XKDataBase instance] exists:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId]) {
                    [[XKDataBase instance] update:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId value:serverCheckCode];
                } else {
                    [[XKDataBase instance] insert:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId value:serverCheckCode];
                }
            } else {
                if ([[XKDataBase instance] createTable:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable]) {
                    [[XKDataBase instance] insert:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId value:serverCheckCode];
                }
            }
            
            [XKHudView showErrorMessage:@"开通成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *viewControllerArr = self.navigationController.viewControllers;
                [self.navigationController popToViewController:viewControllerArr[2] animated:YES];
            });
        } failure:^(XKHttpErrror *error) {
            [XKHudView showErrorMessage:error.message];
        }];
    });
}

#pragma mark - events

// 重写父类返回按钮点击方法
- (void)backBtnClick {
    
    // 已开通状态点击返回，返回密码状态页
    if (self.state == XKMineFingerprintPaymentViewControllerStateOpened) {
        NSArray *viewControllerArr = self.navigationController.viewControllers;
        [self.navigationController popToViewController:viewControllerArr[2] animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 点击开通TouchID / FaceID支付
- (void)clickConfirmButton:(UIButton *)sender {
    
    [self initializepayPasswordContainerView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.payPasswordView startInputPayPassword];
//    });
}

// 点击关闭TouchID / FaceID支付
- (void)clickCloseFingerPayButton:(UIButton *)sender {
    
    NSString *url;
    if (self.type == XKMineFingerprintPaymentViewControllerTypeTouchId) {
        url = GetCloseFingerPayUrl;
    } else {
        url = GetCloseFaceRecognitionUrl;
    }
    
    NSString *describeString;
    if (self.type == XKMineFingerprintPaymentViewControllerTypeTouchId) {
        describeString = @"是否要关闭指纹支付";
    } else {
        describeString = @"是否要关闭Face ID支付";
    }

    NSString *messageString;
    if (self.type == XKMineFingerprintPaymentViewControllerTypeTouchId) {
        messageString = @"指纹支付功能已关闭";
    } else {
        messageString = @"Face ID支付功能已关闭";
    }

    [XKAlertView showCommonAlertViewWithTitle:describeString rightText:@"确定" rightBlock:^{
        [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
            [XKHudView showSuccessMessage:messageString];
            
            // 删除数据库 serverCheckCode
            if ([[XKDataBase instance] existsTable:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable]) {
                if ([[XKDataBase instance] exists:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:[XKUserInfo getCurrentUserId]]) {
                    [[XKDataBase instance] deleteValueForTable:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:[XKUserInfo getCurrentUserId]];
                }
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *viewControllerArr = self.navigationController.viewControllers;
                [self.navigationController popToViewController:viewControllerArr[2] animated:YES];
            });
        } failure:^(XKHttpErrror *error) {
            [XKHudView showErrorMessage:error.message];
        }];
    }];
}

// 点击忘记密码
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

// 关闭支付密码输入
- (void)closePayPasswordContainerView:(UIControl *)sender {
    [self.payPasswordView stopInputPayPassword];
}

#pragma mark - private mathods

- (void)initializeViews {
    
    if (self.type == XKMineFingerprintPaymentViewControllerTypeTouchId) {
        [self setNavTitle:@"指纹支付" WithColor:[UIColor whiteColor]];
    } else {
        [self setNavTitle:@"Face ID支付" WithColor:[UIColor whiteColor]];
    }
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.navigationView.mas_bottom).offset(48);
        make.width.and.height.mas_equalTo(110);
    }];
    [self.describePartOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.imageView.mas_bottom).offset(30);
    }];
    [self.describePartTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.describePartOneLabel.mas_bottom).offset(10);
    }];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.describePartTwoLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.height.mas_equalTo(44);
    }];
    
    if (self.state == XKMineFingerprintPaymentViewControllerStateNotAvailable) {
        if (self.type == XKMineFingerprintPaymentViewControllerTypeTouchId) {
            
            self.imageView.image = [UIImage imageNamed:@"xk_btn_account_password_finger"];
            self.describePartOneLabel.text = @"开通指纹支付 交易更便捷";
            self.describePartTwoLabel.text = @"开启后可通过验证系统指纹快速完成付款";
        } else {
            
            self.imageView.image = [UIImage imageNamed:@"xk_btn_account_password_faceID"];
            self.describePartOneLabel.text = @"开通Face ID支付 交易更便捷";
            self.describePartTwoLabel.text = @"开启后可通过验证系统Face ID信息快速完成付款";
        }
        
        [self.operationButton setTitle:@"同意开通" forState:UIControlStateNormal];
        [self.operationButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    } else {
        if (self.type == XKMineFingerprintPaymentViewControllerTypeTouchId) {
            
            self.describePartOneLabel.text = @"指纹支付已成功开通";
            self.describePartTwoLabel.text = @"您可通过验证系统指纹快速完成付款";
            [self.operationButton setTitle:@"关闭指纹支付" forState:UIControlStateNormal];
        } else {
            
            self.describePartOneLabel.text = @"Face ID支付已成功开通";
            self.describePartTwoLabel.text = @"您可通过验证系统Face ID信息快速完成付款";
            [self.operationButton setTitle:@"关闭Face ID支付" forState:UIControlStateNormal];
        }
        
        self.imageView.image = [UIImage imageNamed:@"xk_btn_account_password_finger_opened"];
        [self.operationButton addTarget:self action:@selector(clickCloseFingerPayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)initializepayPasswordContainerView {
    
    self.payPasswordContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.payPasswordContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.payPasswordContainerView];
    
    // payPasswordView 父视图
    UIView *payPasswordSuperView = [UIView new];
    payPasswordSuperView.backgroundColor = XKSeparatorLineColor;
    [self.payPasswordContainerView addSubview:payPasswordSuperView];
    [payPasswordSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kMineFingerprintPaymentViewControllerPayPasswordSuperViewHeight);
        make.left.equalTo(self.payPasswordContainerView.mas_left);
        make.right.equalTo(self.payPasswordContainerView.mas_right);
        make.bottom.equalTo(self.payPasswordContainerView.mas_bottom);
    }];
    
    // 标题
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"请输入支付密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [payPasswordSuperView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payPasswordSuperView.mas_top).offset(8);
        make.centerX.equalTo(payPasswordSuperView.mas_centerX);
    }];
    
    // 支付密码输入视图
    self.payPasswordView = [XKPayPasswordView addPayPasswordViewWithoutToolBarToView:payPasswordSuperView];
    self.payPasswordView.delegate = self;
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(payPasswordSuperView.mas_centerX);
        make.centerY.equalTo(payPasswordSuperView.mas_centerY);
    }];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"xk_btn_account_password_clear"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closePayPasswordContainerView:) forControlEvents:UIControlEventTouchUpInside];
    [payPasswordSuperView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_top);
        make.right.equalTo(self.payPasswordView.mas_right);
        make.width.and.height.mas_equalTo(18);
    }];
    
    // 忘记密码按钮
    UIButton *forgotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgotButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    forgotButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
    [forgotButton addTarget:self action:@selector(clickForgotButton:) forControlEvents:UIControlEventTouchUpInside];
    [payPasswordSuperView addSubview:forgotButton];
    [forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payPasswordView.mas_bottom).offset(5);
        make.right.equalTo(self.payPasswordView.mas_right);
    }];
    
    // 遮罩视图
    UIControl *maskViewControl = [UIControl new];
    maskViewControl.enabled = NO;   /** 屏蔽点击遮罩视图关闭弹窗 */
    maskViewControl.backgroundColor = [UIColor blackColor];
    maskViewControl.alpha = 0.5;
    [self.payPasswordContainerView addSubview:maskViewControl];
    [maskViewControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payPasswordContainerView.mas_left);
        make.right.equalTo(self.payPasswordContainerView.mas_right);
        make.top.equalTo(self.payPasswordContainerView.mas_top);
        make.bottom.equalTo(payPasswordSuperView.mas_top);
    }];
    [maskViewControl addTarget:self action:@selector(closePayPasswordContainerView:) forControlEvents:UIControlEventTouchUpInside];
}

/** 键盘弹出 */
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *keyboardUserInfo = [notification userInfo];
    CGRect keyboardRect = [keyboardUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationDuration = [keyboardUserInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [keyboardUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    CGRect tempRect = self.payPasswordContainerView.frame;
    CGFloat keyboardHeight = keyboardRect.size.height;
    tempRect.origin.y = -keyboardHeight;
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        self.payPasswordContainerView.frame = tempRect;
    } completion:nil];
}

/** 键盘回收 */
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *keyboardUserInfo = [notification userInfo];
    CGFloat animationDuration = [keyboardUserInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [keyboardUserInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    
    CGRect tempRect = self.payPasswordContainerView.frame;
    tempRect.origin.y = SCREEN_HEIGHT + kMineFingerprintPaymentViewControllerPayPasswordSuperViewHeight;
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        self.payPasswordContainerView.frame = tempRect;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.payPasswordContainerView removeFromSuperview];
            self.payPasswordContainerView = nil;
        }
    }];
}

#pragma mark - setter and getter

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)describePartOneLabel {
    
    if (!_describePartOneLabel) {
        _describePartOneLabel = [UILabel new];
        _describePartOneLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:16.0];
        _describePartOneLabel.textColor = [UIColor darkTextColor];
        _describePartOneLabel.numberOfLines = 1;
        _describePartOneLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_describePartOneLabel];
    }
    return _describePartOneLabel;
}

- (UILabel *)describePartTwoLabel {
    
    if (!_describePartTwoLabel) {
        _describePartTwoLabel = [UILabel new];
        _describePartTwoLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
        _describePartTwoLabel.textColor = [UIColor lightGrayColor];
        _describePartTwoLabel.numberOfLines = 1;
        _describePartTwoLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_describePartTwoLabel];
    }
    return _describePartTwoLabel;
}

- (UIButton *)operationButton {
    
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.layer.cornerRadius = 5;
        _operationButton.layer.masksToBounds = YES;
        _operationButton.backgroundColor = XKMainTypeColor;
        [self.view addSubview:_operationButton];
    }
    return _operationButton;
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
