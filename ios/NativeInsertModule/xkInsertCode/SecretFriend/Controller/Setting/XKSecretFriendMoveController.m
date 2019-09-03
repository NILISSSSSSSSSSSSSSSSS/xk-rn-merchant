/*******************************************************************************
 # File        : XKSecretFriendMoveController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretFriendMoveController.h"
#import "XKRelationUserCacheManager.h"
@interface XKSecretFriendMoveController () <UITextFieldDelegate>
/**<##>*/
@property(nonatomic, strong) UITextField *textField;

@end

@implementation XKSecretFriendMoveController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createUI {
    self.navStyle = BaseNavWhiteStyle;
    [self setNavTitle:@"密友迁移" WithColor:[UIColor whiteColor]];
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 6;
    [self.containView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(@( 12));
        make.right.equalTo(@(-10));
        make.height.equalTo(@(45));
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.delegate = self;
    textField.placeholder = @"请输入已有账号";
    textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(@(20 * ScreenScale));
        make.right.equalTo(@(-20 * ScreenScale));
    }];
    self.textField = textField;
    
    UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"迁移密友会连同聊天记录一并迁入至以上输入的密友账号" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor clearColor]];
    label.adjustsFontSizeToFitWidth = YES;
    [self.containView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25 * ScreenScale));
        make.right.equalTo(@(-10 * ScreenScale));
        make.height.equalTo(@(17 * ScreenScale));
        make.top.equalTo(contentView.mas_bottom).offset(8);
    }];
    // 创建按钮
    UIButton *transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    transferBtn.backgroundColor = XKMainTypeColor;
    [transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    transferBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:17];
    transferBtn.layer.cornerRadius = 8;
    transferBtn.layer.masksToBounds = YES;
    [transferBtn setTitle:@"确认迁移" forState:UIControlStateNormal];
    [transferBtn addTarget:self action:@selector(clickdTransfer) forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:transferBtn];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(10);
        make.right.equalTo(self.containView.mas_right).offset(-10);
        make.top.equalTo(label.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)clickdTransfer {
  if (self.textField.text.length == 0) {
    [XKHudView showWarnMessage:@"请输入账号"];
    return;
  }
  [XKHudView showLoadingTo:self.containView animated:YES];
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"userId"] = [XKUserInfo getCurrentUserId];
  params[@"rid"] = self.userId;
  params[@"secretPwd"] = self.textField.text;
  [XKHudView showLoadingTo:self.containView animated:YES];
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretFriendTransfer/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    [XKHudView hideHUDForView:self.containView];
    [XKHudView showSuccessMessage:@"已迁移成功" to:self.containView time:1 animated:YES completion:^{
      [[NSNotificationCenter defaultCenter] postNotificationName:XKSecretFriendListInfoChangeNoti object:nil];
      [XKRelationUserCacheManager refreshTotal];
      
      [NSObject popToVCFromCurrentStackTargetVCClass:NSClassFromString(@"XKSecretFriendRootViewController")];
    }];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.containView];
    [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
  }];
}

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
