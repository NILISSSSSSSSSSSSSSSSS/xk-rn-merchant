//
//  XKWelfareOrderGoodDestoryViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderGoodDestoryViewController.h"
static NSInteger const MAX_LIMIT_NUMS = 200;
@interface XKWelfareOrderGoodDestoryViewController () <UITextViewDelegate>
@property (nonatomic, strong)UITextView *inputTv;
@property (nonatomic, strong)UIButton *sureBtn;
@property (nonatomic, strong)UILabel *tipLabel;
@end

@implementation XKWelfareOrderGoodDestoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    XKCustomNavBar *navBar =  [[XKCustomNavBar alloc] init];
    navBar.titleString = @"货物报损";
    [navBar customBaseNavigationBar];
    navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navBar];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.inputTv];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.tipLabel];
    [self addUIConstraint];
}

- (void)addUIConstraint {
    [self.inputTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.height.mas_equalTo(246 * ScreenScale);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.inputTv.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTv.mas_left).offset(15);
        make.top.equalTo(self.inputTv.mas_top).offset(15);
    }];
}

- (void)sureBtnClick:(UIButton *)sender {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    
    if(textView.text.length == 0) {
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.hidden = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.tipLabel.hidden = YES;
    return YES;
}
#pragma mark 懒加载
- (UITextView *)inputTv {
    if(!_inputTv) {
        _inputTv = [[UITextView alloc] init];
        _inputTv.delegate = self;
        _inputTv.backgroundColor = [UIColor whiteColor];
        _inputTv.layer.cornerRadius = 8.f;
        _inputTv.layer.masksToBounds = YES;
    }
    return _inputTv;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = UIColorFromRGB(0x999999);
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _tipLabel.text = @"损坏描述";
    }
    return _tipLabel;
}

- (UIButton *)sureBtn {
    if(!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确认收货" forState:0];
        _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_sureBtn setBackgroundColor:XKMainTypeColor];
        _sureBtn.layer.cornerRadius = 3.f;
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.layer.masksToBounds = YES;
    }
    return _sureBtn;
}

@end
