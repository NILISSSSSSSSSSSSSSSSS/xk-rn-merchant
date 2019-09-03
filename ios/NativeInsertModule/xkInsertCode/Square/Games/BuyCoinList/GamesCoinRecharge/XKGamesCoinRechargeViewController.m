//
//  XKGamesCoinRechargeViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGamesCoinRechargeViewController.h"

@interface XKGamesCoinRechargeViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton    *deleteBtn;
@property (nonatomic, strong) UITextField *rechargeTextfield;
@property (nonatomic, strong) UITextField *numTextfield;
@property (nonatomic, strong) UILabel     *xkCoinLabel;
@property (nonatomic, strong) UILabel     *xkCoinTotalLabel;




@end

@implementation XKGamesCoinRechargeViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    
    [self cofigNavigationBar];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Events

- (void)sureBtnClicked:(UIButton *)sender {

    XKCommonAlertView *alertView = [[XKCommonAlertView alloc] initWithTitle:@"充值成功" message:@"是否绑定账户？" leftButton:@"取消" rightButton:@"确定" leftBlock:^{
        
    } rightBlock:^{
        
        
    } textAlignment:NSTextAlignmentCenter];
    
    [alertView show];
}

- (void)deleteBtnClicked:(UIButton *)sender {
    
    
}

#pragma mark - Private Metheods

- (void)cofigNavigationBar {
    [self setNavTitle:[NSString stringWithFormat:@"%@充值", self.titleName] WithColor:[UIColor whiteColor]];
}

- (void)configUI {
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"xk_icon_gmeCoinRechargeBackImg"];
    [self.view addSubview:imgView];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:@"xk_icon_gameCoin_xkCoinBig"];
    [imgView addSubview:iconImgView];
    
    
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = [UIColor whiteColor];
    [imgView addSubview:leftLineView];

    
    UIView *rightLineView = [[UIView alloc] init];
    rightLineView.backgroundColor = [UIColor whiteColor];
    [imgView addSubview:rightLineView];

    
    UILabel *coinNameLabel = [[UILabel alloc] init];
    coinNameLabel.text = self.titleName;
    coinNameLabel.textColor = [UIColor whiteColor];
    coinNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    [imgView addSubview:coinNameLabel];
    
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"未绑定";
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [imgView addSubview:amountLabel];
    
    
    
    UIView *chargeCoinView = [[UIView alloc] init];
    chargeCoinView.layer.masksToBounds = YES;
    chargeCoinView.layer.cornerRadius = 5;
    chargeCoinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chargeCoinView];
    
    
    UILabel *chargeCoinLabel = [[UILabel alloc] init];
    chargeCoinLabel.text = @"充值账号：";
    chargeCoinLabel.textColor = HEX_RGB(0x222222);
    chargeCoinLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [chargeCoinView addSubview:chargeCoinLabel];
    
    [chargeCoinView addSubview:self.rechargeTextfield];
    [chargeCoinView addSubview:self.deleteBtn];

    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = XKSeparatorLineColor;
    [chargeCoinView addSubview:line];
    
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"输入数量：";
    numLabel.textColor = HEX_RGB(0x222222);
    numLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [self.view addSubview:numLabel];
    
    [self.view addSubview:self.numTextfield];
    
    
    [self.view addSubview:self.xkCoinLabel];
    [self.view addSubview:self.xkCoinTotalLabel];
    
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5;
    sureBtn.backgroundColor = HEX_RGB(0x4A90FA);
    [sureBtn setTitle:@"确认买单" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [self.view addSubview:sureBtn];
    
    
    
    //约束
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(162*ScreenScale));
    }];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView).offset(10);
        make.height.with.equalTo(@(70*ScreenScale));
        make.centerX.equalTo(imgView);
    }];
    
    [coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset(8);
        make.centerX.equalTo(imgView);
    }];
    
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(coinNameLabel.mas_left).offset(-5);
        make.centerY.equalTo(coinNameLabel);
        make.height.equalTo(@1);
        make.width.equalTo(@15);

    }];
    
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coinNameLabel.mas_right).offset(5);
        make.centerY.equalTo(coinNameLabel);
        make.height.equalTo(@1);
        make.width.equalTo(@15);
    }];
    
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinNameLabel.mas_bottom).offset(8);
        make.centerX.equalTo(imgView);
    }];
    
    
    [chargeCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(imgView.mas_bottom).offset(10);
        make.height.equalTo(@101);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chargeCoinView.mas_top).offset(50);
        make.left.right.equalTo(chargeCoinView);
        make.height.equalTo(@1);
    }];
    
    [chargeCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(chargeCoinView).offset(10);
        make.top.equalTo(chargeCoinView);
        make.bottom.equalTo(line.mas_top);
//        make.width.equalTo(@70);

    }];
    
    [self.rechargeTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chargeCoinLabel.mas_right);
//        make.right.equalTo(chargeCoinView).offset(-50);
        make.centerY.equalTo(chargeCoinLabel);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(chargeCoinView).offset(-10);
        make.height.with.equalTo(@30);
        make.centerY.equalTo(chargeCoinLabel);
    }];
    
    
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(chargeCoinView).offset(10);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(chargeCoinView);
//        make.width.equalTo(@70);
    }];
    
    [self.numTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLabel.mas_right);
//        make.right.equalTo(chargeCoinView).offset(-10);
        make.centerY.equalTo(numLabel);
    }];
    
    
    [self.xkCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(chargeCoinView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(20);
        
    }];
    
    [self.xkCoinTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.xkCoinLabel);
    }];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xkCoinLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@44);
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"搜索。。。%@", textField.text);
    
    if (textField.text.length) {
        //请求网络
        
        
    }
    return YES;
}
#pragma mark - Custom Delegates

#pragma mark - Getters and Setters

- (UITextField *)rechargeTextfield {
    if (!_rechargeTextfield) {
        _rechargeTextfield = [[UITextField alloc] init];
        _rechargeTextfield.placeholder = @"请输入充值的账号";
        _rechargeTextfield.textAlignment = NSTextAlignmentLeft;
        _rechargeTextfield.delegate = self;
        _rechargeTextfield.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _rechargeTextfield.textColor = HEX_RGB(0x555555);
        _rechargeTextfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _rechargeTextfield;
    
}

- (UITextField *)numTextfield {
    if (!_numTextfield) {
        _numTextfield = [[UITextField alloc] init];
        _numTextfield.placeholder = @"请输入充值的金额";
        _numTextfield.textAlignment = NSTextAlignmentLeft;
        _numTextfield.delegate = self;
        _numTextfield.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _numTextfield.textColor = HEX_RGB(0x555555);
        _numTextfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _numTextfield;
    
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_delete"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_right"] forState:UIControlStateSelected];
    }
    return _deleteBtn;
}

- (UILabel *)xkCoinLabel {
    if (!_xkCoinLabel) {
        
        _xkCoinLabel = [[UILabel alloc] init];
        _xkCoinLabel.textColor = HEX_RGB(0xEE6161);
        _xkCoinLabel.textAlignment = NSTextAlignmentLeft;
        _xkCoinLabel.text = @"晓可币：88";
        _xkCoinLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _xkCoinLabel;
}

- (UILabel *)xkCoinTotalLabel {
    if (!_xkCoinTotalLabel) {
        _xkCoinTotalLabel = [[UILabel alloc] init];
        _xkCoinTotalLabel.textColor = HEX_RGB(0x777777);
        _xkCoinTotalLabel.textAlignment = NSTextAlignmentLeft;
        _xkCoinTotalLabel.text = @"充值后余额：288";
        _xkCoinTotalLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _xkCoinTotalLabel;
}

@end
