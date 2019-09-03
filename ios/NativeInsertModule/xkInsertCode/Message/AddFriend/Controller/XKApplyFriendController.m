/*******************************************************************************
 # File        : XKApplyFriendController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/26
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKApplyFriendController.h"
#import "XKInputTextView.h"
#import <IQKeyboardManager.h>

@interface XKApplyFriendController () {
  
}

@property(nonatomic, strong) XKInputTextView *textView;
@property(nonatomic, strong) UITextField *remarkTextField;

@property(nonatomic, copy) NSString *applyInfo;
@property(nonatomic, copy) NSString *remarkInfo;

@end

@implementation XKApplyFriendController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  
}

#pragma mark - 初始化界面
- (void)createUI {
  __weak typeof(self) weakSelf = self;
  self.navigationView.hidden = NO;
  self.navStyle = self.isSecret ? BaseNavWhiteStyle:BaseNavBlueStyle;
  if (self.isSecret) {
    [self setNavTitle:@"申请密友" WithColor:[UIColor whiteColor]];
  } else {
    [self setNavTitle:@"申请好友" WithColor:[UIColor whiteColor]];
  }
  self.view.backgroundColor = HEX_RGB(0xEEEEEE);
  
  _textView = [[XKInputTextView alloc] init];
  _textView.placeholderText = @"填写发送给对方的验证内容，等待对方验证";
  _textView.limitNumber = 200;
  _textView.countLabel.hidden = YES;
  [_textView setTextDidChangeBlock:^(NSString *text) {
    weakSelf.applyInfo = text;
  }];
  [self.containView addSubview:_textView];
  _textView.backgroundColor = [UIColor whiteColor];
  _textView.layer.cornerRadius = 5;
  _textView.clipsToBounds = YES;
  [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.navigationView.mas_bottom).offset(15);
    make.left.equalTo(self.containView.mas_left).offset(15);
    make.right.equalTo(self.containView.mas_right).offset(-15);
    make.height.equalTo(@150);
  }];
  
  UIView *remarkView = [[UIView alloc] init];
  [self.containView addSubview:remarkView];
  remarkView.backgroundColor = [UIColor whiteColor];
  remarkView.layer.cornerRadius = 5;
  remarkView.clipsToBounds = YES;
  [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.textView.mas_bottom).offset(15);
    make.width.equalTo(self.textView);
    make.left.equalTo(self.textView);
    make.height.equalTo(@40);
  }];
  
  _remarkTextField = [[UITextField alloc] init];
  _remarkTextField.placeholder = @"设置备注";
  [_remarkTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
  _remarkTextField.font = XKRegularFont(14);
  _remarkTextField.textColor = RGBGRAY(102);
  [remarkView addSubview:_remarkTextField];
  [_remarkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(remarkView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
  }];
  
  UIButton *btn = [[UIButton alloc] init];
  btn.backgroundColor = XKMainTypeColor;
  btn.layer.masksToBounds = YES;
  btn.layer.cornerRadius = 5;
  [btn setTitle:@"发送验证申请" forState:UIControlStateNormal];
  [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
  btn.titleLabel.font = XKRegularFont(18);
  [self.containView addSubview:btn];
  [btn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(remarkView.mas_bottom).offset(20);
    make.width.equalTo(self.textView);
    make.left.equalTo(self.textView);
    make.height.equalTo(@45);
  }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)send:(UIButton *)btn {
  [KEY_WINDOW endEditing:YES];
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = self.applyId;
  params[@"validateMsg"] = _applyInfo;
  params[@"remark"] = _remarkInfo;
  if (self.isSecret) {
    params[@"secretId"] = self.secretId;
  }
  
  [XKHudView showLoadingTo:self.containView animated:YES];
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/friendsApply/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    [XKHudView hideHUDForView:self.containView];
    [XKHudView showTipMessage:@"已成功发送验证申请！" to:self.containView time:2 animated:YES completion:^{
      [self.navigationController popViewControllerAnimated:YES];
    }];
    EXECUTE_BLOCK(self.applyComplete);
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.containView];
    [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
  }];
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------
- (void)textFieldChange:(UITextField *)textField {
  NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
  if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 有高亮选择的字 则不搜索
    if (position) {
      return;
    }
  }
  if (textField.text.length > 20) {
    textField.text = [textField.text substringToIndex:20];
  }
  _remarkInfo = textField.text;
}

#pragma mark --------------------------- setter&getter -------------------------


@end
