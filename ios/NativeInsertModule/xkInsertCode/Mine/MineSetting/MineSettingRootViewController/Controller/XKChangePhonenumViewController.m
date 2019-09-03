////
////  XKChangePhonenumViewController.m
////  XKSquare
////
////  Created by Lin Li on 2018/9/4.
////  Copyright © 2018年 xk. All rights reserved.
////
//
//#import "XKChangePhonenumViewController.h"
//#import "XKLoginNetworkMethod.h"
//#import "XKChangephoneNumSecViewController.h"
//

#import "XKChangePhonenumViewController.h"
@interface XKChangePhonenumViewController ()<UITextFieldDelegate>
//@property (nonatomic, strong)UITextField *phoneTextField;
//@property (nonatomic, strong)UITextField *codeTextField;
//@property (nonatomic, strong) UIButton       *sendVerificationButton;
//@property (nonatomic,strong) UIButton       *nextButton;

@end

@implementation XKChangePhonenumViewController

@end
//
//
//@interface XKChangePhonenumViewController ()<UITextFieldDelegate>
//@property (nonatomic, strong)UITextField *phoneTextField;
//@property (nonatomic, strong)UITextField *codeTextField;
//@property (nonatomic, strong) UIButton       *sendVerificationButton;
//@property (nonatomic,strong) UIButton       *nextButton;
//
//@end
//
//@implementation XKChangePhonenumViewController
//#pragma mark – Life Cycle
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    if (self.type == XKChangePhonenumViewControllerTypeChangePhoneNum) {
//        [self setNavTitle:@"修改手机号码" WithColor:[UIColor whiteColor]];
//    } else {
//        [self setNavTitle:@"绑定手机号码" WithColor:[UIColor whiteColor]];
//    }
//    [self initViews];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark – Private Methods
//- (void)setPhoneBlock:(phoneBlock)block {
//    self.block = block;
//}
//- (void)initViews {
//    UIView *contentView = [[UIView alloc]init];
//    contentView.backgroundColor = [UIColor whiteColor];
//    contentView.layer.masksToBounds = YES;
//    contentView.layer.cornerRadius = 6;
//    [self.view addSubview:contentView];
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(10 * ScreenScale));
//        make.top.equalTo(@(NavigationAndStatue_Height + 12));
//        make.right.equalTo(@(-10 * ScreenScale));
//        make.height.equalTo(@(100 * ScreenScale));
//    }];
//
//    UITextField *textField = [[UITextField alloc]init];
//    textField.placeholder = @"请输入新手机号码";
//    textField.keyboardType = UIKeyboardTypeNumberPad;
//    textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
//    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.delegate = self;
//    textField.tag = 1000;
//    textField.keyboardType = UIKeyboardTypeNumberPad;
//    [contentView addSubview:textField];
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentView);
//        make.height.equalTo(@(50 *ScreenScale));
//        make.left.equalTo(@(20 * ScreenScale));
//        make.right.equalTo(@(-20 * ScreenScale));
//    }];
//    self.phoneTextField = textField;
//    UIView *lineView = [[UIView alloc]init];
//    lineView.backgroundColor = XKSeparatorLineColor;
//    [contentView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(contentView);
//        make.height.equalTo(@0.5);
//        make.top.equalTo(self.phoneTextField.mas_bottom);
//    }];
//
//    UITextField *codeTextField = [[UITextField alloc]init];
//    codeTextField.placeholder = @"请输入验证码";
//    codeTextField.delegate = self;
//    codeTextField.tag = 1001;
//    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
//    codeTextField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13];
//    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [contentView addSubview:codeTextField];
//    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(contentView);
//        make.height.equalTo(@(50 *ScreenScale));
//        make.left.equalTo(@(20 * ScreenScale));
//        make.width.equalTo(@(200 * ScreenScale));
//    }];
//
//    self.codeTextField = codeTextField;
//    [contentView addSubview:self.sendVerificationButton];
//    [self.sendVerificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.codeTextField);
//        make.height.equalTo(@(30 * ScreenScale));
//        make.right.equalTo(@(-20 * ScreenScale));
//        make.width.equalTo(@(90 * ScreenScale));
//    }];
//
//    [self.view addSubview:self.nextButton];
//    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(10 * ScreenScale));
//        make.height.equalTo(@(40 * ScreenScale));
//        make.right.equalTo(@(-10 * ScreenScale));
//        make.top.equalTo(contentView.mas_bottom).offset(20 * ScreenScale);
//    }];
//
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
//#pragma mark - Events
////发送验证码
//- (void)sendVerificationAction:(UIButton *)sender {
//    if ([self checkMobile:self.phoneTextField.text]) {
//        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        parameters[@"phone"] = self.phoneTextField.text;
//        if (self.type == XKChangePhonenumViewControllerTypeChangePhoneNum) {
//            parameters[@"bizType"] = SmsAuthBizTyperesetPhone;
//        } else {
//            parameters[@"bizType"] = SmsAuthBizTypeBindPhone;
//        }
//        [HTTPClient postEncryptRequestWithURLString:GetResetPhoneAuthCodeSendUrl timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
//            [self countdown];
//            [XKHudView showSuccessMessage:@"发送成功"];
//        } failure:^(XKHttpErrror *error) {
//            [XKHudView showErrorMessage:error.message];
//        }];
//    }else{
//        [XKHudView showErrorMessage:@"请输入正确的手机号"];
//    }
//}
//
////验证按钮事件
//- (void)nextAction:(UIButton *)sender {
//
//    if (![self checkMobile:self.phoneTextField.text]) {
//        [XKHudView showErrorMessage:@"请输入正确的手机号"];
//        return;
//    }
//
//    NSString *url;
//    NSString *phone = self.phoneTextField.text;
//    NSString *code = self.codeTextField.text;
//
//    if (self.type == XKChangePhonenumViewControllerTypeChangePhoneNum) {
//        url = GetXkUserUpdatePhoneUrl;
//    } else {
//        url = GetXkUserBindPhoneUrl;
//    }
//
//    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:@{@"phone": phone,@"code": code} success:^(id responseObject) {
//
//        [XKUserInfo currentUser].userPhoneNumber = self.phoneTextField.text;
//        // 修改手机号
//        if (self.type == XKChangePhonenumViewControllerTypeChangePhoneNum) {
//            XKChangephoneNumSecViewController *vc = [[XKChangephoneNumSecViewController alloc]init];
//            vc.phone = self.phoneTextField.text;
//            [self.navigationController pushViewController:vc animated:true];
//
//        // 账号安全中首次绑定手机号
//        } else {
//            [XKHudView showErrorMessage:@"绑定成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSArray *viewControllerArr = self.navigationController.viewControllers;
//                [self.navigationController popToViewController:viewControllerArr[2] animated:YES];
//            });
//        }
//    } failure:^(XKHttpErrror *error) {
//        [XKHudView showErrorMessage:error.message];
//    }];
//
//
//
//}
//#pragma mark - Custom Delegates
//
//#pragma mark – Getters and Setters
//- (UIButton *)sendVerificationButton {
//    if (!_sendVerificationButton) {
//        _sendVerificationButton = [[UIButton alloc]init];
//        [_sendVerificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [_sendVerificationButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
//        _sendVerificationButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_sendVerificationButton addTarget:self action:@selector(sendVerificationAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _sendVerificationButton;
//}
//- (UIButton *)nextButton {
//    if (!_nextButton) {
//        _nextButton = [[UIButton alloc]init];
//        [_nextButton setTitle:@"验证" forState:UIControlStateNormal];
//        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _nextButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
//        _nextButton.layer.masksToBounds = true;
//        _nextButton.layer.cornerRadius = 10 * ScreenScale;
//        _nextButton.backgroundColor = HEX_RGB(0x4A90FA);
//        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _nextButton;
//}
//
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    if (textField.tag == 1000) {
//        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//        if (toBeString.length > 11){
//            textField.text = [toBeString substringToIndex:11];
//            return NO;
//
//        }
//
//    }else if (textField.tag == 1001){
//        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//        if (toBeString.length > 6){
//            textField.text = [toBeString substringToIndex:6];
//            return NO;
//        }
//    }
//
//    return YES;
//}
//
//@end
