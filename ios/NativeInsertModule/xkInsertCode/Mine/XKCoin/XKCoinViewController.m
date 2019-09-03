//
//  XKCoinViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCoinViewController.h"
#import "XKQRCodeScanViewController.h"
#import "XKCoinRechaargeViewController.h"
#import "XKTransactionDetailListViewController.h"

@interface XKCoinViewController ()

@end

@implementation XKCoinViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self cofigNavigationBar];

    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Events

- (void)detailBtnClicked {
    XKTransactionDetailListViewController *vc = [[XKTransactionDetailListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rechargeBtnClicked:(UIButton *)sender {
    
    XKCoinRechaargeViewController *vc = [[XKCoinRechaargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scanRechargeBtnClicked:(UIButton *)sender {
    XKQRCodeScanViewController *vc = [[XKQRCodeScanViewController alloc] init];
    vc.vcType = QRCodeScanVCType_Recharge;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private Metheods

- (void)cofigNavigationBar {
    [self setNavTitle:@"晓可币" WithColor:[UIColor whiteColor]];
    
    UIButton *detailBtn = [[UIButton alloc] init];
    [detailBtn addTarget:self action:@selector(detailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn setTitle:@"账单明细" forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    [detailBtn setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateNormal];
    [self setNaviCustomView:detailBtn withframe:CGRectMake(SCREEN_WIDTH - 88, 0, 68, 40)];
}

- (void)configUI {
    
    UIView *coinView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height-1, SCREEN_WIDTH, 186*ScreenScale)];
    [self.view addSubview:coinView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:coinView.bounds];
    imgView.image = [UIImage imageNamed:@"xk_iocn_coinBackimg"];
    [coinView addSubview:imgView];
    
    UILabel *coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"15000个"];
    [attString addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:26], NSForegroundColorAttributeName:HEX_RGB(0xFFF26C)} range:NSMakeRange(0, attString.length - 1)];
    [attString addAttributes:@{NSFontAttributeName:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17], NSForegroundColorAttributeName:HEX_RGB(0xFFF26C)} range:NSMakeRange(attString.length - 1, 1)];
    coinLabel.attributedText = attString;
    [coinView addSubview:coinLabel];
    
    
    UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100 / 2, CGRectGetMaxY(coinLabel.frame), 100, 20)];
    [iconBtn setTitle:@"晓可币" forState:UIControlStateNormal];
    [iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    iconBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
    [iconBtn setImage:[UIImage imageNamed:@"xk_iocn_coin"] forState:UIControlStateNormal];
    [coinView addSubview:iconBtn];
    
    
    UIButton *rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(coinView.frame) + 20, SCREEN_WIDTH - 20, 44)];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rechargeBtn.layer.masksToBounds = YES;
    rechargeBtn.layer.cornerRadius = 5;
    rechargeBtn.backgroundColor = HEX_RGB(0x4A90FA);
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [self.view addSubview:rechargeBtn];
    
    
    UIButton *scanRechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(rechargeBtn.frame) + 20, SCREEN_WIDTH - 20, 44)];
    [scanRechargeBtn addTarget:self action:@selector(scanRechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    scanRechargeBtn.layer.masksToBounds = YES;
    scanRechargeBtn.layer.cornerRadius = 5;
    scanRechargeBtn.layer.borderWidth = 1;
    scanRechargeBtn.layer.borderColor = HEX_RGB(0x4A90FA).CGColor;
    scanRechargeBtn.backgroundColor = [UIColor whiteColor];
    [scanRechargeBtn setTitle:@"扫码充值" forState:UIControlStateNormal];
    [scanRechargeBtn setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];
    scanRechargeBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [self.view addSubview:scanRechargeBtn];
    
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSoure

#pragma mark - Custom Delegates

#pragma mark - Getters and Setters



@end
