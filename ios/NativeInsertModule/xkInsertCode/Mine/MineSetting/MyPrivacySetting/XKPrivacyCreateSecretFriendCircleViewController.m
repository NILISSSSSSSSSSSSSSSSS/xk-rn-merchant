//
//  XKPrivacyCreateSecretFriendCircleViewController.m
//  XKSquare
//
//  Created by william on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPrivacyCreateSecretFriendCircleViewController.h"
#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"

@interface XKPrivacyCreateSecretFriendCircleViewController ()

@property (nonatomic,strong) UIView         *nicknameView;

@property (nonatomic,strong) UIView         *pwdView;

@property (nonatomic,strong) UIView         *confirmPwdView;

@property (nonatomic,strong) UITextField    *nickNameTextfield;

@property (nonatomic,strong) UITextField    *pwdTextField;

@property (nonatomic,strong) UITextField    *confirmTextField;

@property (nonatomic,strong) UIButton       *confirmButton;

@end

@implementation XKPrivacyCreateSecretFriendCircleViewController


#pragma mark – Life Cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initViews];
  [self viewLayout];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  CGRect nickNameTextfieldFrame = self.nicknameView.getWindowFrame;
  CGRect rect = CGRectMake(nickNameTextfieldFrame.origin.x, nickNameTextfieldFrame.origin.y, nickNameTextfieldFrame.size.width, nickNameTextfieldFrame.size.height * 3);
  [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKPrivacyCreateSecretFriendCircleViewController TransparentRectArr:@[[NSValue valueWithCGRect:rect]]];
}
#pragma mark – Private Methods

-(void)initViews{
  [self setNavTitle:@"新建密友圈" WithColor:[UIColor whiteColor]];
  [self.containView addSubview:self.nicknameView];
  [self.containView addSubview:self.pwdView];
  [self.containView addSubview:self.confirmPwdView];
  [self.containView addSubview:self.confirmButton];
}

-(void)viewLayout{
  [_nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.containView.mas_left).offset(10 * ScreenScale);
    make.right.mas_equalTo(self.containView.mas_right).offset(-10 * ScreenScale);
    make.top.mas_equalTo(self.navigationView.mas_bottom).offset(10 * ScreenScale);
    make.height.mas_equalTo(45 * ScreenScale);
  }];
  
  [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_nicknameView.mas_bottom);
    make.left.and.right.mas_equalTo(self->_nicknameView);
    make.height.mas_equalTo(45 * ScreenScale);
  }];
  
  [_confirmPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_pwdView.mas_bottom);
    make.left.and.right.mas_equalTo(self->_pwdView);
    make.height.mas_equalTo(45 * ScreenScale);
  }];
  
  [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_confirmPwdView.mas_bottom).offset(20 * ScreenScale);
    make.centerX.mas_equalTo(self.containView.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20 * ScreenScale, 44 * ScreenScale));
  }];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
-(UIView *)nicknameView{
  if (!_nicknameView) {
    _nicknameView = [BaseViewFactory viewWithFram:CGRectMake(0, 0, 0, 0) title:@"密友圈名称" textField:self.nickNameTextfield withLine:YES];
    _nicknameView.xk_openClip = YES;
    _nicknameView.xk_radius = 8 * ScreenScale;
    _nicknameView.xk_clipType = XKCornerClipTypeTopBoth;
  }
  return _nicknameView;
}

-(UIView *)pwdView{
  if (!_pwdView) {
    _pwdView = [BaseViewFactory viewWithFram:CGRectMake(0, 0, 0, 0) title:@"密码" textField:self.pwdTextField withLine:YES];
  }
  return _pwdView;
}

-(UIView *)confirmPwdView{
  if (!_confirmPwdView) {
    _confirmPwdView = [BaseViewFactory viewWithFram:CGRectMake(0, 0, 0, 0) title:@"确认密码" textField:self.confirmTextField withLine:NO];
    _confirmPwdView.xk_openClip = YES;
    _confirmPwdView.xk_radius = 8 * ScreenScale;
    _confirmPwdView.xk_clipType = XKCornerClipTypeBottomBoth;
  }
  return _confirmPwdView;
}

-(UITextField *)nickNameTextfield{
  if (!_nickNameTextfield) {
    _nickNameTextfield = [BaseViewFactory textFieldWithFrame:CGRectMake(90 * ScreenScale, 0, 250 * ScreenScale, 45 * ScreenScale) font:XKRegularFont(12) placeholder:@"请输入密友圈名称" textColor:UIColorFromRGB(0x222222) placeholderColor:UIColorFromRGB(0x999999) delegate:nil];
    _nickNameTextfield.tag = 201;
    [_nickNameTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
  }
  return _nickNameTextfield;
}

-(UITextField *)pwdTextField{
  if (!_pwdTextField) {
    _pwdTextField = [BaseViewFactory textFieldWithFrame:CGRectMake(90 * ScreenScale, 0, 250 * ScreenScale, 45 * ScreenScale) font:XKRegularFont(12) placeholder:@"请输入密码（4~8位字符，不包含特殊符号）" textColor:UIColorFromRGB(0x222222) placeholderColor:UIColorFromRGB(0x999999) delegate:nil];
    _pwdTextField.tag = 202;
    [_pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _pwdTextField.secureTextEntry = YES;
  }
  return _pwdTextField;
}

-(UITextField *)confirmTextField{
  if (!_confirmPwdView) {
    _confirmTextField = [BaseViewFactory textFieldWithFrame:CGRectMake(90 * ScreenScale, 0, 250 * ScreenScale, 45 * ScreenScale) font:XKRegularFont(12) placeholder:@"请再次输入密码" textColor:UIColorFromRGB(0x222222) placeholderColor:UIColorFromRGB(0x999999) delegate:nil];
    _confirmTextField.tag = 203;
    [_confirmTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _confirmTextField.secureTextEntry = YES;
  }
  return _confirmTextField;
}

-(UIButton *)confirmButton{
  if (!_confirmButton) {
    _confirmButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20 * ScreenScale , 44 * ScreenScale) font:XKRegularFont(17) title:@"确定" titleColor:UIColorFromRGB(0xffffff) backColor:XKMainTypeColor];
    [_confirmButton cutCornerWithRadius:8*ScreenScale color:XKMainTypeColor lineWidth:0];
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _confirmButton;
}

#pragma mark - Events
-(void)confirmButtonClicked:(UIButton *)sender{
  [KEY_WINDOW endEditing:YES];
  if (_nickNameTextfield.text.length < 1) {
    [XKHudView showErrorMessage:@"请输入密友圈名称"];
    return;
  }
  if (_nickNameTextfield.text.length > 10) {
    [XKHudView showErrorMessage:@"密友圈名称不超过16个字"];
    return;
  }
  if (_pwdTextField.text.length == 0) {
    [XKHudView showErrorMessage:@"请输入密码"];
    return;
  }
  if (_pwdTextField.text.length < 4 || _pwdTextField.text.length > 8) {
    [XKHudView showErrorMessage:@"请输入密码（4-8位字符，不包含特殊符号）"];
    return;
  }
  NSString * regex = @"^[A-Za-z0-9]+$";
  NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
  BOOL isMatch = [pred evaluateWithObject:_pwdTextField.text];
  
  if (!isMatch) {
    [XKHudView showErrorMessage:@"请输入正确的4-8位字符，不包含特殊字符"];
    return;
  }
  
  if (_confirmTextField.text.length < 1) {
    [XKHudView showErrorMessage:@"请再次输入密码"];
    return;
  }
  if (![_pwdTextField.text isEqualToString:_confirmTextField.text]) {
    [XKHudView showErrorMessage:@"确认密码不一致，请重新输入"];
    return;
  }
  [XKAlertView showCommonAlertViewWithTitle:@"创建密友圈密码不可找回，请牢记密友圈密码，是否创建？" leftText:@"取消" rightText:@"确定" leftBlock:nil rightBlock:^{
    [XKHudView showLoadingTo:self.containView animated:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretName"] = [self.nickNameTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    params[@"secretPwd"] = self.pwdTextField.text;
    [HTTPClient getEncryptRequestWithURLString:@"im/ua/secretCircleCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
      [XKHudView hideHUDForView:self.containView animated:YES];
      [XKHudView showSuccessMessage:@"创建成功" to:self.containView time:1.5 animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
      }];
    } failure:^(XKHttpErrror *error) {
      [XKHudView hideHUDForView:self.containView animated:YES];
      [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
  }];
  
}

-(void)textFieldDidChange:(UITextField *)textField {
  if (textField.tag == 201) {
    if (textField.text.length > 10) {
      textField.text = [textField.text substringToIndex:10];
    }
  }
  else if (textField.tag ==202){
    if (textField.text.length > 8) {
      textField.text = [textField.text substringToIndex:8];
    }
  }
  else if (textField.tag == 203){
    if (textField.text.length > 8) {
      textField.text =  [textField.text substringToIndex:8];
    }
  }
  else{
    
  }
}
@end
