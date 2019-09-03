/*******************************************************************************
 # File        : XKCreateTagController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCreateTagController.h"

@interface XKCreateTagController ()
/**<##>*/
@property(nonatomic, strong) UITextField *nameTextField;
@end

@implementation XKCreateTagController

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
    [self setNavTitle:@"创建标签" WithColor:[UIColor whiteColor]];
    UIButton *newBtn = [[UIButton alloc] init];
    [newBtn setTitle:@"完成" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = XKRegularFont(17);
    [newBtn setFrame:CGRectMake(0, 0, XKViewSize(35), 25)];
    [newBtn addTarget:self action:@selector(newClick) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:newBtn withframe:newBtn.bounds];
    
    [self createNameViewToView];
}

- (UIView *)createNameViewToView {
    UIView *nameView = [UIView new];
    nameView.backgroundColor = [UIColor whiteColor];
    nameView.layer.cornerRadius = 6;
    nameView.layer.masksToBounds = YES;
    [self.containView addSubview:nameView];
    
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView.mas_top).offset(10);
        make.left.equalTo(self.containView.mas_left).offset(10);
        make.right.equalTo(self.containView.mas_right).offset(-10);
        make.height.equalTo(@50);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"标签名称";
    label.textColor = HEX_RGB(51);
    label.font = XKRegularFont(14);
    [nameView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView);
        make.left.equalTo(nameView.mas_left).offset(18);
        make.width.mas_equalTo(XKViewSize(62));
    }];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.placeholder = @"例如家人、朋友";
    self.nameTextField.font = XKRegularFont(15);
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    [self.nameTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [nameView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(20);
        make.top.bottom.equalTo(nameView);
        make.right.equalTo(nameView.mas_right).offset(-10);
    }];
    return nameView;
}

- (void)textChange:(UITextField *)textField {
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
}


- (void)newClick {
    [self.view endEditing:YES];
    if (![self.nameTextField.text isExist]) {
        [XKHudView showTipMessage:@"请输入标签名" to:self.containView animated:YES];
        return;
    }
    [XKHudView showLoadingTo:self.containView animated:YES];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"groupName"] = self.nameTextField.text;
    params[@"groupType"] = @"label";
    NSMutableArray *ids = @[].mutableCopy;
    for (XKContactModel *usr in self.userArray) {
        [ids addObject:usr.userId];
    }
    params[@"userIds"] = ids;
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/xkGroupCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        NSDictionary *dataDic = [responseObject xk_jsonToDic];
        XKFriendGroupModel *model  = [XKFriendGroupModel new];
        model.groupName = dataDic[@"groupName"];
        model.groupId = dataDic[@"id"];
        EXECUTE_BLOCK(self.successBlock,model);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.containView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
    }];
}


@end
