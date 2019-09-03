////
////  XKResetLoginPasswordViewController.m
////  XKSquare
////
////  Created by Lin Li on 2018/9/3.
////  Copyright © 2018年 xk. All rights reserved.
////
//
#import "XKResetLoginPasswordViewController.h"
//#import "XKLoginNetworkMethod.h"
//#import "BaseTabBarConfig.h"
//#import "XKAlertUtil.h"
//#import "XKChangePhonenumViewController.h"
//
@interface XKResetLoginPasswordViewController () <UITextFieldDelegate>
//
//@property(nonatomic,strong) UITextField    *phoneTextField;
//@property(nonatomic,strong) UITextField    *verificationTextFiled;
//@property(nonatomic,strong) UIButton       *sendVerificationButton;
//@property(nonatomic,strong) UITextField    *passwordTextField;
//@property(nonatomic,strong) UILabel        *describeLabel;
//@property(nonatomic,strong) UIView         *lineView1;
//@property(nonatomic,strong) UIView         *lineView2;
//@property(nonatomic,strong) UIView         *lineView3;
//@property(nonatomic,strong) UIButton       *changePasswordButton;
//@property(nonatomic,strong) UIButton       *backButton;
//@property(nonatomic,strong) UIButton       *headerButton;
//@property(nonatomic,strong) UILabel        *headerLabel;
//
//@property(nonatomic,strong) UIView         *contentView;
//@property(nonatomic,strong) UIView         *changePasswordContentView;
//@property(nonatomic,strong) UIView         *superChangePasswordContentView;
//
@end
//
@implementation XKResetLoginPasswordViewController
//
//#pragma mark – Life Cycle
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self initViews];
//    [self layoutViews];
//    [self hideNavigation];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark – Private Methods
//
//- (void)initViews {
//    [self.view addSubview:self.contentView];
//    [self.contentView addSubview:self.backButton];
//    [self.contentView addSubview:self.superChangePasswordContentView];
//    [self.superChangePasswordContentView addSubview:self.changePasswordContentView];
//    [self.superChangePasswordContentView addSubview:self.headerButton];
//    [self.superChangePasswordContentView addSubview:self.headerLabel];
//    
//    [self.changePasswordContentView addSubview:self.phoneTextField];
//    [self.changePasswordContentView addSubview:self.verificationTextFiled];
//    [self.changePasswordContentView addSubview:self.sendVerificationButton];
//    [self.changePasswordContentView addSubview:self.passwordTextField];
//    [self.changePasswordContentView addSubview:self.changePasswordButton];
//    [self.changePasswordContentView addSubview:self.lineView1];
//    [self.changePasswordContentView addSubview:self.lineView2];
//    [self.changePasswordContentView addSubview:self.lineView3];
//    [self.changePasswordContentView addSubview:self.describeLabel];
//    
//    self.phoneTextField.text = self.phoneNum;
//}
//
//- (void)layoutViews {
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    [self.superChangePasswordContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(28 * ScreenScale);
//        make.right.mas_equalTo(-28 * ScreenScale);
//        make.top.mas_equalTo(134 * ScreenScale);
//        make.height.mas_equalTo(450 * ScreenScale);
//    }];
//    
//    [self.changePasswordContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.superChangePasswordContentView);
//    }];
//    
//    [self.headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.superChangePasswordContentView);
//        make.top.equalTo(@(-50 * ScreenScale));
//        make.width.equalTo(@(102));
//        make.height.equalTo(@(102));
//    }];
//    
//    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.superChangePasswordContentView);
//        make.top.equalTo(self.headerButton.mas_bottom).offset(5 * ScreenScale);
//        make.width.equalTo(@(150 * ScreenScale));
//        make.height.equalTo(@(20 * ScreenScale));
//    }];
//    
//    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@(40 * ScreenScale));
//        make.left.equalTo(@(26 * ScreenScale));
//        make.top.equalTo(@(33 * ScreenScale));
//    }];
//    
//    
//    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(25 * ScreenScale));
//        make.top.mas_equalTo(133.5 * ScreenScale);
//        make.right.equalTo(@(-25 * ScreenScale));
//        make.height.equalTo(@(20 * ScreenScale));
//    }];
//    
//    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(25 * ScreenScale));
//        make.top.equalTo(self.phoneTextField.mas_bottom).offset(3 * ScreenScale);
//        make.right.equalTo(@(-25 * ScreenScale));
//        make.height.equalTo(@(1));
//    }];
//    
//    [self.sendVerificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(@(-25 * ScreenScale));
//        make.top.equalTo(self.lineView1.mas_bottom).offset(35 * ScreenScale);
//        if (iPhone5) {
//            make.width.equalTo(@(80));
//        }else{
//            make.width.equalTo(@(80 * ScreenScale));
//        }
//        make.height.equalTo(@(20 * ScreenScale));
//    }];
//    
//    [self.verificationTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(25 * ScreenScale));
//        make.top.equalTo(self.lineView1.mas_bottom).offset(35 * ScreenScale);
//        make.right.equalTo(self.sendVerificationButton.mas_left);
//        make.height.equalTo(@(20 * ScreenScale));
//    }];
//    
//    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(25 * ScreenScale));
//        make.top.equalTo(self.verificationTextFiled.mas_bottom).offset(3 * ScreenScale);
//        make.right.equalTo(@(-25 * ScreenScale));
//        make.height.equalTo(@(1));
//    }];
//    
//    
//    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(25 * ScreenScale));
//        make.top.equalTo(self.lineView2.mas_bottom).offset(35 * ScreenScale);
//        make.right.equalTo(@(-25 * ScreenScale));
//        make.height.equalTo(@(20 * ScreenScale));
//    }];
//    
//    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(25 * ScreenScale));
//        make.top.equalTo(self.passwordTextField.mas_bottom).offset(3 * ScreenScale);
//        make.right.equalTo(@(-25 * ScreenScale));
//        make.height.equalTo(@(1));
//    }];
//    
//    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
//        make.left.equalTo(self.lineView3.mas_left);
//        make.right.equalTo(self.lineView3.mas_right);
//    }];
//    
//    [self.changePasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(25 * ScreenScale));
//        make.right.equalTo(@(-25 * ScreenScale));
//        make.height.equalTo(@(40));
//        make.bottom.mas_equalTo(-40 * ScreenScale);
//    }];
//    
//}
//#pragma mark - Events
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}
//- (void)backBtnAction:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
////-(void)passwordTextFieldChange:(UITextField *)textField {
////    if (textField.text.length > 20) {
////        textField.text = [textField.text substringToIndex:20];
////    }
////}
//
//// 密码输入
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    NSString *currentString;
//    if ([string isEqualToString:@""] || !string) {
//        currentString = [textField.text substringToIndex:[textField.text length] - 1];
//    } else if ([string isEqualToString:@" "]) {
//        return NO;
//    } else if ([string rangeOfString:@"^[\\u4E00-\\u9FEA]+$" options:NSRegularExpressionSearch].length > 0) {
//        return NO;
//    } else {
//        currentString = [textField.text stringByAppendingString:string];
//    }
//    return YES;
//}
//
//- (void)changePasswordAction:(UIButton *)sender {
////    if (![self checkMobile:self.phoneTextField.text]) {
////        [XKHudView showErrorMessage:@"请输入正确的手机号"];
////        return;
////    }
//    if (self.verificationTextFiled.text.length != 6) {
//        [XKHudView showErrorMessage:@"请输入正确的验证码"];
//        return;
//    }
////    if (![self checkPassword:self.passwordTextField.text]) {
////        [XKHudView showErrorMessage:@"请输入正确格式的密码！"];
////        return;
////    }
//    NSDictionary *parameters = @{@"code":self.verificationTextFiled.text,@"phone":[XKUserInfo currentUser].userRealPhoneNumber, @"password":[self.passwordTextField.text removeSpaceAndLineBreak]};
//    [XKHudView showLoadingTo:self.view animated:YES];
//    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserSetPassword/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
//        [XKHudView hideHUDForView:self.view animated:YES];
//        XKUserSynchronize;
//        [XKHudView showErrorMessage:@"重置登录密码成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSArray *viewControllerArr = self.navigationController.viewControllers;
//            [self.navigationController popToViewController:viewControllerArr[2] animated:YES];
//        });
//    } failure:^(XKHttpErrror *error) {
//        [XKHudView hideHUDForView:self.view animated:YES];
//        [XKHudView showErrorMessage:error.message];
//    }];
//}
//- (void)headerAction:(UIButton *)sender {
//    
//}
//- (void)sendVerificationAction:(UIButton *)sender {
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"phone"] = [XKUserInfo currentUser].userRealPhoneNumber;
//    parameters[@"bizType"] = SmsAuthBizTyperesetPassword;
//    [XKLoginNetworkMethod sendResetPwdAuthCodeParameters:parameters Block:^(id responseObject, BOOL isSuccess) {
//        [self countdown];
//        if (isSuccess) {
//            [XKHudView showSuccessMessage:@"发送成功"];
//        } else {
//            [XKHudView showErrorMessage:responseObject];
//        }
//    }];
//}
//- (void)phoneTextFieldChange:(UITextField *)sender {
//    if (sender.text.length > 11) {
//        sender.text = [sender.text substringToIndex:11];
//    }
//    [self resetButtonStatus];
//}
//
//- (void)verificationTextFieldChange:(UITextField *)sender {
//    if (sender.text.length > 6) {
//        sender.text = [sender.text substringToIndex:6];
//    }
//    [self resetButtonStatus];
//}
//
//- (void)resetButtonStatus {
//    if (self.phoneTextField.text.length == 11) {
//        self.sendVerificationButton.enabled = YES;
//        [self.sendVerificationButton setTitleColor:XKMainTypeColor forState:0];
//    }else{
//        self.sendVerificationButton.enabled = NO;
//        [self.sendVerificationButton setTitleColor:[UIColor grayColor] forState:0];
//    }
//    
//    if ([self.verificationTextFiled.text length] == 6 && [self.phoneTextField.text length] == 11) {
//        self.changePasswordButton.backgroundColor = XKMainTypeColor;
//        [self.changePasswordButton setTitleColor:[UIColor whiteColor] forState:0];
//        self.changePasswordButton.enabled = YES;
//    }else{
//        self.changePasswordButton.backgroundColor = [UIColor grayColor];
//        [self.changePasswordButton setTitleColor:[UIColor whiteColor] forState:0];
//        self.changePasswordButton.enabled = NO;
//    }
//}
//- (void)countdown {
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行一次
//    NSTimeInterval seconds = 60.f;
//    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds]; // 最后期限
//    
//    dispatch_source_set_event_handler(_timer, ^{
//        int interval = [endTime timeIntervalSinceNow];
//        if (interval > 0) { // 更新倒计时
//            NSString *timeStr = [NSString stringWithFormat:@"%d秒后重发", interval];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.sendVerificationButton.enabled = NO;
//                [self.sendVerificationButton setTitle:timeStr forState:UIControlStateNormal];
//            });
//        } else { // 倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.sendVerificationButton.enabled = YES;
//                [self.sendVerificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
//            });
//        }
//    });
//    dispatch_resume(_timer);
//}
//#pragma mark – Getters and Setters
//#pragma mark – Getters and Setters
//- (UIView *)contentView {
//    if (!_contentView) {
//        _contentView = [[UIView alloc]init];
//        _contentView.backgroundColor = [UIColor whiteColor];
//    }
//    return _contentView;
//}
//
//
//- (UIView *)superChangePasswordContentView {
//    if (!_superChangePasswordContentView) {
//        _superChangePasswordContentView = [[UIView alloc]init];
//        _superChangePasswordContentView.backgroundColor = [UIColor clearColor];
//        _superChangePasswordContentView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _superChangePasswordContentView.layer.shadowOffset = CGSizeMake(2, 2);
//        _superChangePasswordContentView.layer.shadowRadius = 10;
//        _superChangePasswordContentView.layer.shadowOpacity = 0.5;
//        _superChangePasswordContentView.clipsToBounds = NO;
//    }
//    return _superChangePasswordContentView;
//}
//
//- (UIView *)changePasswordContentView {
//    if (!_changePasswordContentView) {
//        _changePasswordContentView = [[UIView alloc]init];
//        _changePasswordContentView.backgroundColor = [UIColor whiteColor];
//        _changePasswordContentView.layer.masksToBounds = YES;
//        _changePasswordContentView.layer.cornerRadius = 10;
//    }
//    return _changePasswordContentView;
//}
//
//- (UITextField *)phoneTextField {
//    if (!_phoneTextField) {
//        _phoneTextField = [[UITextField alloc]init];
//        _phoneTextField.textColor = [UIColor lightGrayColor];
//        _phoneTextField.enabled = NO;
//        _phoneTextField.placeholder = @"请输入您的手机号";
//        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
//        _phoneTextField.tag = 100;
//        [_phoneTextField addTarget:self action:@selector(phoneTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
//        _phoneTextField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_phoneTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    }
//    return _phoneTextField;
//}
//
//- (UITextField *)verificationTextFiled {
//    if (!_verificationTextFiled) {
//        _verificationTextFiled = [[UITextField alloc]init];
//        _verificationTextFiled.textColor = HEX_RGB(0x464646);
//        _verificationTextFiled.placeholder = @"请输入验证码";
//        _verificationTextFiled.keyboardType = UIKeyboardTypeNumberPad;
//        _verificationTextFiled.tag = 101;
//        [_verificationTextFiled addTarget:self action:@selector(verificationTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
//        _verificationTextFiled.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_verificationTextFiled setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    }
//    return _verificationTextFiled;
//}
//
//- (UIButton *)sendVerificationButton {
//    if (!_sendVerificationButton) {
//        _sendVerificationButton = [[UIButton alloc]init];
//        [_sendVerificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
//        _sendVerificationButton.enabled = YES;
//        [_sendVerificationButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
//        _sendVerificationButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_sendVerificationButton addTarget:self action:@selector(sendVerificationAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _sendVerificationButton;
//}
//
//- (UITextField *)passwordTextField {
//    if (!_passwordTextField) {
//        _passwordTextField = [[UITextField alloc] init];
//        _passwordTextField.textColor = HEX_RGB(0x464646);
//        _passwordTextField.placeholder = @"请输入新的登录密码";
//        _passwordTextField.delegate = self;
////        [_passwordTextField addTarget:self action:@selector(passwordTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
//        _passwordTextField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_passwordTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    }
//    return _passwordTextField;
//}
//
//- (UILabel *)describeLabel {
//    if (!_describeLabel) {
//        _describeLabel = [UILabel new];
//        _describeLabel.numberOfLines = 2;
//        _describeLabel.textColor = [UIColor lightGrayColor];
//        _describeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        _describeLabel.text = @"密码可由6-20位大小写英文字母、数字、除空格外的特殊符号组成";
//    }
//    return _describeLabel;
//}
//
//- (UIView *)lineView1 {
//    if (!_lineView1) {
//        _lineView1 = [[UIView alloc]init];
//        _lineView1.backgroundColor = XKSeparatorLineColor;
//    }
//    return _lineView1;
//}
//
//- (UIView *)lineView2 {
//    if (!_lineView2) {
//        _lineView2 = [[UIView alloc]init];
//        _lineView2.backgroundColor = XKSeparatorLineColor;
//    }
//    return _lineView2;
//}
//
//- (UIView *)lineView3 {
//    if (!_lineView3) {
//        _lineView3 = [[UIView alloc]init];
//        _lineView3.backgroundColor = XKSeparatorLineColor;
//    }
//    return _lineView3;
//}
//
//- (UIButton *)changePasswordButton {
//    if (!_changePasswordButton) {
//        _changePasswordButton = [[UIButton alloc]init];
//        [_changePasswordButton setTitle:@"确 定" forState:UIControlStateNormal];
//        [_changePasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _changePasswordButton.backgroundColor = [UIColor grayColor];
//        _changePasswordButton.enabled = NO;
//        _changePasswordButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
//        _changePasswordButton.layer.masksToBounds = true;
//        _changePasswordButton.layer.cornerRadius = 20;
//        [_changePasswordButton addTarget:self action:@selector(changePasswordAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _changePasswordButton;
//}
//
//- (UIButton *)backButton {
//    if (!_backButton) {
//        _backButton = [[UIButton alloc]init];
//        [_backButton setImage:[UIImage imageNamed:@"xk_ic_login_back"] forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _backButton;
//}
//
//- (UIButton *)headerButton {
//    if (!_headerButton) {
//        _headerButton = [[UIButton alloc]init];
//        [_headerButton sd_setImageWithURL:[NSURL URLWithString:[XKUserInfo getCurrentUserAvatar]] forState:0 placeholderImage:[UIImage imageNamed:@"xk_ic_defult_head"]];
//        _headerButton.layer.masksToBounds = YES;
//        _headerButton.layer.cornerRadius = 51;
//        //        [_headerButton addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _headerButton;
//}
//
//- (UILabel *)headerLabel {
//    if (!_headerLabel) {
//        _headerLabel = [[UILabel alloc]init];
//        _headerLabel.text = [XKUserInfo getCurrentUserName];
//        _headerLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
//        _headerLabel.textColor = HEX_RGB(0x222222);
//        _headerLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _headerLabel;
//}
@end
