//
//  XKCoinRechaargeViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCoinRechaargeViewController.h"
#import "XKQRCodeScanViewController.h"
#import "XKCoinRechargeStatusViewController.h"
#import "XKPayCenter.h"
#import <AlipaySDK/AlipaySDK.h>

#define alipaySelectBtnTag      101
#define weixinPaySelectBtnTag   102
#define yinLianPaySelectBtnTag  103

@interface XKCoinRechaargeViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UIButton    *alipaySelectBtn;
@property (nonatomic, strong) UIButton    *weiXinSelectBtn;
@property (nonatomic, strong) UIButton    *yinLianSelectBtn;


@end

@implementation XKCoinRechaargeViewController


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

- (void)paySelectBtnClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
    }
    if (sender.tag == alipaySelectBtnTag) {
        self.weiXinSelectBtn.selected = NO;
        self.yinLianSelectBtn.selected = NO;
    } else if (sender.tag == weixinPaySelectBtnTag) {
        self.alipaySelectBtn.selected = NO;
        self.yinLianSelectBtn.selected = NO;
    } else if (sender.tag == yinLianPaySelectBtnTag) {
        self.alipaySelectBtn.selected = NO;
        self.weiXinSelectBtn.selected = NO;
    }
}

- (void)chargeBtnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.textfield.text.length == 0 || self.textfield.text.integerValue < 1) {
        [XKHudView showErrorMessage:@"请输入正确的金额"];
        return;
    }
    if (self.alipaySelectBtn.selected) {
        [[XKPayCenter sharedPayCenter] AliPayWithOrderString:@"temp" succeedBlock:^{
            XKCoinRechargeStatusViewController *vc = [[XKCoinRechargeStatusViewController alloc] init];
            vc.rechargeStatusVC = RechargeStatusVC_fail;
            [self.navigationController pushViewController:vc animated:YES];
        } failedBlock:^(NSString *reason) {
            [XKHudView showErrorMessage:reason];
        }];
    } else if (self.weiXinSelectBtn.selected) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"partnerId"] = @"10000100";
        dic[@"prepayId"] = @"1101000000140415649af9fc314aa427";
        dic[@"package"] = @"Sign=WXPay";
        dic[@"nonceStr"] = @"a462b76e7436e98e0ed6e13c64b4fd1c";
        dic[@"timeStamp"] = @"1397527777";
        dic[@"package"] = @"1397527777";
        dic[@"sign"] = @"582282D72DD2B03AD892830965F428CB16E7A256";
        
        [[XKPayCenter sharedPayCenter] WeChatPayWithPayPara:dic succeedBlock:^{
            XKCoinRechargeStatusViewController *vc = [[XKCoinRechargeStatusViewController alloc] init];
            vc.rechargeStatusVC = RechargeStatusVC_fail;
            [self.navigationController pushViewController:vc animated:YES];
        } failedBlock:^(NSString *reason) {
            [XKHudView showErrorMessage:reason];
        }];
    }
//    XKCoinRechargeStatusViewController *vc = [[XKCoinRechargeStatusViewController alloc] init];
//    vc.rechargeStatusVC = RechargeStatusVC_fail;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private Metheods

- (void)cofigNavigationBar {
    [self setNavTitle:@"晓可币充值" WithColor:[UIColor whiteColor]];
}

- (void)configUI {
    
    UIView *chargeCoinView = [[UIView alloc] initWithFrame:CGRectMake(10, NavigationAndStatue_Height + 10, SCREEN_WIDTH - 20, 44)];
    chargeCoinView.layer.masksToBounds = YES;
    chargeCoinView.layer.cornerRadius = 5;
    chargeCoinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chargeCoinView];
    
    UILabel *chargeCoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, chargeCoinView.height)];
    chargeCoinLabel.text = @"充值金额";
    chargeCoinLabel.textColor = HEX_RGB(0x222222);
    chargeCoinLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [chargeCoinView addSubview:chargeCoinLabel];
    [chargeCoinView addSubview:self.textfield];
    
    
    
    UILabel *exchangeRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(chargeCoinView.frame), SCREEN_WIDTH - 34, 27)];
    exchangeRateLabel.textColor = XKMainTypeColor;
    exchangeRateLabel.textAlignment = NSTextAlignmentRight;
    exchangeRateLabel.text = @"兑换率：1晓可币=￥1.00";
    exchangeRateLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    [self.view addSubview:exchangeRateLabel];
    
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(exchangeRateLabel.frame), SCREEN_WIDTH - 20, 44.0 * 3)];
    payView.layer.masksToBounds = YES;
    payView.layer.cornerRadius = 5;
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    
    
    
    UILabel *payWayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 43)];
    payWayLabel.text = @"支付方式";
    payWayLabel.textColor = HEX_RGB(0x222222);
    payWayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [payView addSubview:payWayLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(payWayLabel.frame), payView.width, 1)];
    line1.backgroundColor = XKSeparatorLineColor;
    [payView addSubview:line1];
    
    
    
    
    UIView *alipayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), SCREEN_WIDTH - 20, 44)];
    UIImageView *alipayImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    alipayImgView.image = [UIImage imageNamed:@"xk_btn_order_pay_alipay"];
    [alipayView addSubview:alipayImgView];
    
    UILabel *alipayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(alipayImgView.frame)+5, 0, 80, 43)];
    alipayLabel.text = @"支付宝";
    alipayLabel.textColor = HEX_RGB(0x222222);
    alipayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [alipayView addSubview:alipayLabel];
    
    [alipayView addSubview:self.alipaySelectBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, payView.width, 1)];
    line2.backgroundColor = XKSeparatorLineColor;
    [alipayView addSubview:line2];
    [payView addSubview:alipayView];
    
    
    
    UIView *weixinPayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(alipayView.frame), SCREEN_WIDTH - 20, 44)];
    UIImageView *weixinPayImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    weixinPayImgView.image = [UIImage imageNamed:@"xk_btn_order_pay_wechat"];
    [weixinPayView addSubview:weixinPayImgView];
    
    UILabel *weixinPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weixinPayImgView.frame)+5, 0, 80, 43)];
    weixinPayLabel.text = @"微信";
    weixinPayLabel.textColor = HEX_RGB(0x222222);
    weixinPayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [weixinPayView addSubview:weixinPayLabel];
    
    [weixinPayView addSubview:self.weiXinSelectBtn];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, payView.width, 1)];
    line3.backgroundColor = XKSeparatorLineColor;
    [weixinPayView addSubview:line3];
    
    [payView addSubview:weixinPayView];

    
    
//    UIView *yinLianPayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weixinPayView.frame), SCREEN_WIDTH - 20, 44)];
//    UIImageView *yinLianPayImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
//    yinLianPayImgView.image = [UIImage imageNamed:@"xk_btn_order_pay_bank"];
//    [yinLianPayView addSubview:yinLianPayImgView];
//
//    UILabel *yinLianPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yinLianPayImgView.frame)+5, 0, 80, 43)];
//    yinLianPayLabel.text = @"银行卡";
//    yinLianPayLabel.textColor = HEX_RGB(0x222222);
//    yinLianPayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//    [yinLianPayView addSubview:yinLianPayLabel];
//
//    [yinLianPayView addSubview:self.yinLianSelectBtn];
//    [payView addSubview:yinLianPayView];

    
    UIButton *rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(payView.frame) + 20, SCREEN_WIDTH - 20, 44)];
    [rechargeBtn addTarget:self action:@selector(chargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = 5;
    rechargeBtn.backgroundColor = HEX_RGB(0x4A90FA);
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [self.view addSubview:rechargeBtn];
    
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

- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 150, 0, 135, 44)];
        _textfield.placeholder = @"请输入充值的金额";
        _textfield.textAlignment = NSTextAlignmentRight;
        _textfield.delegate = self;
        _textfield.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textfield.textColor = HEX_RGB(0x999999);
        _textfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textfield;
    
}

- (UIButton *)alipaySelectBtn {
    if (!_alipaySelectBtn) {
        _alipaySelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 43, 0, 43, 43)];
        _alipaySelectBtn.tag = alipaySelectBtnTag;
        _alipaySelectBtn.selected = YES;
        [_alipaySelectBtn addTarget:self action:@selector(paySelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_alipaySelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:UIControlStateNormal];
        [_alipaySelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _alipaySelectBtn;
}

- (UIButton *)weiXinSelectBtn {
    
    if (!_weiXinSelectBtn) {
        _weiXinSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 43, 0, 43, 43)];
        _weiXinSelectBtn.tag = weixinPaySelectBtnTag;
        [_weiXinSelectBtn addTarget:self action:@selector(paySelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_weiXinSelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:UIControlStateNormal];
        [_weiXinSelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _weiXinSelectBtn;
}

- (UIButton *)yinLianSelectBtn {
    
    if (!_yinLianSelectBtn) {
        _yinLianSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 43, 0, 43, 43)];
        _yinLianSelectBtn.tag = yinLianPaySelectBtnTag;
        [_yinLianSelectBtn addTarget:self action:@selector(paySelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_yinLianSelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:UIControlStateNormal];
        [_yinLianSelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _yinLianSelectBtn;
}


@end
