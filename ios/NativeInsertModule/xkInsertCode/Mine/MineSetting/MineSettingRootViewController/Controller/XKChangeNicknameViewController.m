//
//  XKChangeNicknameViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKChangeNicknameViewController.h"

@interface XKChangeNicknameViewController ()<UITextFieldDelegate> {
    UIButton *_rightBtn;
}
@property (nonatomic, strong)UITextField *textField;
@end

@implementation XKChangeNicknameViewController
#pragma mark – Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _limitNum = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"修改昵称" WithColor:[UIColor whiteColor]];
    if (self.title.length != 0 ) {
        [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
    }
    [self setNavRightButton];
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark – Private Methods
- (void)setNavRightButton {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    if (self.rightBtnText) {
        [button setTitle:self.rightBtnText forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:RGBGRAY(220) forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [button addTarget:self action:@selector(rightNavAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self setRightView:button withframe:CGRectMake(0, 0, button.frame.size.width + 10.0, XKViewSize(25))];
    _rightBtn = button;
    if (self.grayIfNoChange) {
        _rightBtn.enabled = NO;
    }
}

- (void)initViews {
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 6;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10 * ScreenScale));
        make.top.equalTo(@(NavigationAndStatue_Height + 12));
        make.right.equalTo(@(-10 * ScreenScale));
        make.height.equalTo(@(48));
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.text = self.nickName;
    textField.delegate = self;
    textField.placeholder = self.placeHolder;
    textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(contentView);
        make.left.equalTo(@(20 * ScreenScale));
        make.right.equalTo(@(-20 * ScreenScale));
    }];
    self.textField = textField;
    
    if (self.useType == 0) {
        UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"2-10个字,可由中英文、数字、“_”组成" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor clearColor]];
        label.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(25 * ScreenScale));
            make.right.equalTo(@(-10 * ScreenScale));
            make.height.equalTo(@(17 * ScreenScale));
            make.top.equalTo(contentView.mas_bottom).offset(7 * ScreenScale);
        }];
    }
}
#pragma mark - Events
- (void)rightNavAction:(UIButton *)sender {
    [KEY_WINDOW endEditing:YES];
    if (self.useType == 0) {
        if (![self checkName:self.textField.text]) {
            [XKHudView showErrorMessage:@"您输入的昵称不符合要求，请重新输入"];
            return;
        }
    }
    if (self.block) {
        self.block(self.textField.text);
    }
    if (!self.forbidAutoPop) {
       [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setNicknameBlock:(nickNameBlock)block {
    self.block = block;
}
#pragma mark - Custom Delegates

#pragma mark – Getters and Setters

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    [self rightNavAction:nil];
    return YES;
}

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
    
    if (textField.text.length > _limitNum){
        textField.text = [textField.text substringToIndex:_limitNum];
        return ;
    }
    if (self.grayIfNoChange) {
        if ([self.nickName isEqualToString:textField.text]) {
            _rightBtn.enabled = NO;
        } else {
            _rightBtn.enabled = YES;
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        return YES;
    }
    if (textField == self.textField) {
        if (self.useType == 0) {
            return [self checkTrueName:string];
        }
    }
    return YES;
}

- (BOOL)checkTrueName:(NSString *)name {
    NSString *regx = @"[\u4e00-\u9fa5\u278b-\u2792a-zA-Z0-9_]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regx];
    BOOL isValid = [predicate evaluateWithObject:name];
    return isValid;
}
@end
