//
//  XKPayPasswordInputViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKPayPasswordInputViewController.h"
#import "HTTPClient.h"
#import "XKHudView.h"
#import "XKPayPasswordView.h"
#import <LocalAuthentication/LocalAuthentication.h>

static const CGFloat kPayPasswordInputViewControllerPayPasswordSuperViewHeight = 138.0;

@interface XKPayPasswordInputViewController () <XKPayPasswordViewDelegate>

@property (nonatomic, strong) UIView *payPasswordContainerView;
@property (nonatomic, strong) XKPayPasswordView *payPasswordView;
@property (nonatomic, assign) BOOL payPwdSetStatus;
@property (nonatomic, assign) BOOL fingerPwdSetStatus;
@property (nonatomic, assign) BOOL facePwdIsSetStatus;
@property (nonatomic, copy) NSString *serverCheckCode;
@property (nonatomic, assign) XKPayPasswordInputViewControllerVerificationType type;

@end

@implementation XKPayPasswordInputViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serverCheckCode = @"";
    
    // 获取密码开通状态
    [XKHudView showLoadingTo:self.view animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetPaySecurityStatusUrl timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
    
        [XKHudView hideHUDForView:self.view animated:YES];
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

        self.facePwdIsSetStatus = NO;
        self.fingerPwdSetStatus = NO;
        self.payPwdSetStatus = [dict[@"textPwdIsSet"] boolValue];
        
        // 判断本地数据库是否已存储服务器校验码
        NSString *userId = [XKUserInfo getCurrentUserId];
        if ([[XKDataBase instance] existsTable:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable]) {
            if ([[XKDataBase instance] exists:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId]) {
                self.serverCheckCode = [[XKDataBase instance] select:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId];
                if (self.serverCheckCode && self.serverCheckCode.length > 0) {
                    self.facePwdIsSetStatus = YES;
                }
            }
        }
        
        // 生物识别支付
        if (self.facePwdIsSetStatus == YES) {
            [self opinionBiologicalRecognition];
            return;
        }
        
        // 支付密码支付
        if (self.payPwdSetStatus) {
            [self showInputPayPasswordView];
            return;
        }
        
        // 未设置支付密码
        [self showPayPasswordSettingUpView];
        
    } failure:^(XKHttpErrror *error) {
        
        [XKHudView hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            [XKHudView showErrorMessage:error.message];
        }];
    }];
}

#pragma mark - product method

+ (XKPayPasswordInputViewController *)showPayPasswordInputViewController:(UIViewController *)viewController {
    
    XKPayPasswordInputViewController *payPasswordInputViewController = [XKPayPasswordInputViewController new];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        payPasswordInputViewController.modalPresentationStyle = UIModalPresentationCustom;
        [viewController presentViewController:payPasswordInputViewController animated:NO completion:nil];
    }
    return payPasswordInputViewController;
}

#pragma mark - XKPayPasswordViewDelegate

// 支付密码校验
- (void)payPasswordView:(XKPayPasswordView *)payPasswordView didClickConfirmButton:(UIBarButtonItem *)sender inputString:(NSString *)inputString {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [payPasswordView stopInputPayPassword];
        NSDictionary *params = @{@"textPassword": inputString};
        [HTTPClient postEncryptRequestWithURLString:GetPaySecurityVerifyUrl timeoutInterval:20.0 parameters:params success:^(id responseObject) {
            
            [self dismissViewControllerAnimated:NO completion:^{
                [XKHudView showInfoMessage:@"验证成功"];
                [self.payPasswordView stopInputPayPassword];
                [self.delegate payPasswordView:self verificationType:self.type isPass:YES severCheckKey:@"" inputPassword:inputString];
            }];
        } failure:^(XKHttpErrror *error) {
            
            [self dismissViewControllerAnimated:NO completion:^{
                [XKHudView showErrorMessage:error.message];
                [self.payPasswordView stopInputPayPassword];
                [self.delegate payPasswordView:self verificationType:self.type isPass:NO severCheckKey:@"" inputPassword:inputString];
            }];
        }];
    });
}

#pragma mark - events

// 点击忘记密码
- (void)clickForgotButton:(UIButton *)sender {
    
    // 验证绑定手机号
    NSString *phoneNum = [XKUserInfo currentUser].phone;
    if (!phoneNum || phoneNum.length == 0) {
        
        // 未绑定手机号
        [self.payPasswordView stopInputPayPassword];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还未绑定手机号，是否立即绑定" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.payPasswordView startInputPayPassword];
            return;
        }];
        [alert addAction:cancelAction];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"去绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:NO completion:^{
                
                [self.payPasswordView stopInputPayPassword];
                [self.delegate payPasswordView:self error:XKPayPasswordInputViewControllerErrorForgotPayPasswordNoPhoneNumber];
                //            XKChangePhonenumViewController *changePhoncenumViewController = [XKChangePhonenumViewController new];
                //            changePhoncenumViewController.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
                //            [self.navigationController pushViewController:changePhoncenumViewController animated:YES];
            }];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // 已绑定手机号
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            // 跳转绑定手机页
            [self.delegate payPasswordView:self error:XKPayPasswordInputViewControllerErrorForgotPayPassword];
        }];
//        XKVerifyPhoneNumberViewController *verifyPhoneNumberViewController = [XKVerifyPhoneNumberViewController new];
//        verifyPhoneNumberViewController.state = XKVerifyPhoneNumberViewControllerStateChangePayPassword;
//        verifyPhoneNumberViewController.phoneNum = phoneNum;
//        [self.navigationController pushViewController:verifyPhoneNumberViewController animated:YES];
    }
}

// 关闭支付密码输入
- (void)closePayPasswordContainerView:(UIControl *)sender {
    
    [self.payPasswordView stopInputPayPassword];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - private method

/*
 * 选择验证方式
 */
- (void)opinionBiologicalRecognition {
    
    // 系统支持，最低iOS 8.0
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        
        LAContext *context = [[LAContext alloc] init];
        context.localizedCancelTitle = @"取消";
        context.localizedFallbackTitle = @"使用密码";
        NSError *error;
        
        // LAPolicyDeviceOwnerAuthenticationWithBiometrics ，指纹授权使用， 当设备不具有Touch ID的功能，或者在系统设置中没有设置开启指纹，授权将会失败。当指纹验证3+2次都没有通过的时候指纹验证就会被锁定，就需要先进行数字密码的解锁才能继续使用指纹密码。
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            
            // 识别类型
            if (@available(iOS 11.0, *)) {
                
                // FaceID
                if (context.biometryType == LABiometryTypeFaceID) {
                    [self showFaceIdVerification:context error:error];
                }
                
                // TouchID
                else if (context.biometryType == LABiometryTypeTouchID) {
                    [self showTouchIdVerification:context error:error];
                }
            } else {
                
                // TouchID
                [self showTouchIdVerification:context error:error];
            }
            
            // LAPolicyDeviceOwnerAuthentication，指纹和数字密码的授权使用，当指纹可用且没有被锁定，授权后会进入指纹密码验证。不然的话会进入数字密码验证的页面。当系统数字密码没有设置不可用的时候，授权失败。如果数字密码输入不正确，连续6次输入数字密码都不正确后，会停用鉴定过一定的间隔后才能使用，间隔时间依次增长
        } else if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
            
            // 不通过手机密码进行支付
            if (self.payPwdSetStatus == YES) {
                [self showInputPayPasswordView];
            } else {
                [self showPayPasswordSettingUpView];
            }
        } else {
            
            // 不支持指纹支付
            if (self.payPwdSetStatus == YES) {
                [self showInputPayPasswordView];
            } else {
                [self showPayPasswordSettingUpView];
            }
        }
    } else {
        
        // 支付密码支付
        if (self.payPwdSetStatus == YES) {
            [self showInputPayPasswordView];
        } else {
            [self showPayPasswordSettingUpView];
        }
    }
}

/*
 * FaceID
 */
- (void)showFaceIdVerification:(LAContext *)context error:(NSError *)error {
    
    self.type = XKPayPasswordInputViewControllerVerificationTypeFaceId;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"面容ID" reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
            // 识别成功，回到主线程做后续操作
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:^{
                    [XKHudView showInfoMessage:@"验证成功"];
                    [self.delegate payPasswordView:self verificationType:self.type isPass:YES severCheckKey:self.serverCheckCode inputPassword:@""];
                }];
            });
        } else {
            
            // 识别失败
            [self dealWithFaceIdOrTouchIdError:error];
        }
    }];
}

/*
 * TouchID
 */
- (void)showTouchIdVerification:(LAContext *)context error:(NSError *)error {
    
    self.type = XKPayPasswordInputViewControllerVerificationTypeTouchId;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有的指纹进行支付" reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            
            // 识别成功，回到主线程做后续操作
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:^{
                    [XKHudView showInfoMessage:@"验证成功"];
                    [self.delegate payPasswordView:self verificationType:self.type isPass:YES severCheckKey:self.serverCheckCode inputPassword:@""];
                }];
            });
        } else {
            
            // 识别失败
            [self dealWithFaceIdOrTouchIdError:error];
        }
    }];
}

/*
 * FaceID / TouchID 识别失败
 */
- (void)dealWithFaceIdOrTouchIdError:(NSError *)error {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 使用支付密码支付
        [self showInputPayPasswordView];
//        [XKHudView showErrorMessage:@"验证失败" to:self.view animated:YES];
    });
    
    switch (error.code) {
        case LAErrorSystemCancel: {
            // 系统取消授权，如其他APP切入
            break;
        }
        case LAErrorUserCancel: {
            // 用户取消验证Touch ID
            break;
        }
        case LAErrorAuthenticationFailed: {
            // 授权失败
            break;
        }
        case LAErrorPasscodeNotSet: {
            // 系统未设置密码
            break;
        }
        case LAErrorTouchIDNotAvailable: {
            // 设备Touch ID不可用，例如未打开
            break;
        }
        case LAErrorTouchIDNotEnrolled: {
            // 设备Touch ID不可用，用户未录入
            break;
        }
        case LAErrorUserFallback: {
            // 用户选择输入密码，切换主线程处理
            break;
        }
        default: {
            // 其他情况，切换主线程处理
            break;
        }
    }
}

/*
 * 展示支付密码输入视图
 */
- (void)showInputPayPasswordView {
    
    self.type = XKPayPasswordInputViewControllerVerificationTypePassword;
    if (self.payPasswordContainerView == nil) {
        
        self.payPasswordContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.payPasswordContainerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.payPasswordContainerView];
        
        // payPasswordView 父视图
        UIView *payPasswordSuperView = [UIView new];
        payPasswordSuperView.backgroundColor = XKSeparatorLineColor;
        [self.payPasswordContainerView addSubview:payPasswordSuperView];
        [payPasswordSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kPayPasswordInputViewControllerPayPasswordSuperViewHeight);
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
//        maskViewControl.enabled = NO;   /** 屏蔽点击遮罩视图关闭弹窗 */
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    [self.payPasswordView startInputPayPassword];
}

/*
 * 键盘弹出（支付密码）
 */
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

/*
 * 键盘回收（支付密码）
 */
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *keyboardUserInfo = [notification userInfo];
    CGFloat animationDuration = [keyboardUserInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [keyboardUserInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    
    CGRect tempRect = self.payPasswordContainerView.frame;
    tempRect.origin.y = SCREEN_HEIGHT + kPayPasswordInputViewControllerPayPasswordSuperViewHeight;
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        self.payPasswordContainerView.frame = tempRect;
    } completion:^(BOOL finished) {
        if (finished) {
//            [self.payPasswordContainerView removeFromSuperview];
//            self.payPasswordContainerView = nil;
        }
    }];
}

/*
 * 提示设置支付密码
 */
- (void)showPayPasswordSettingUpView {
    
    if (self.payPwdSetStatus == NO) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还未设置支付密码，无法进行支付操作！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:NO completion:nil];
            return;
        }];
        [alert addAction:cancelAction];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:NO completion:^{
                
                // 跳转账号安全页
                [self.delegate payPasswordView:self error:XKPayPasswordInputViewControllerErrorNoPayPassword];
            }];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
}

@end
