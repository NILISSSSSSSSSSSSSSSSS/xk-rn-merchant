//
//  XKTransactionDetailViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTransactionDetailViewController.h"

@interface XKTransactionDetailViewController ()

@property (nonatomic, strong) UIView      *headerView;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UILabel     *priceLabel;
@property (nonatomic, strong) UILabel     *payStatusLabel;

@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) UILabel     *goodsLabel;
@property (nonatomic, strong) UILabel     *goodsDecLabel;
@property (nonatomic, strong) UILabel     *classLabel;
@property (nonatomic, strong) UILabel     *classDecLabel;
@property (nonatomic, strong) UIView      *lineView;

@property (nonatomic, strong) UILabel     *creatTimeLabel;
@property (nonatomic, strong) UILabel     *creatTimeDecLabel;
@property (nonatomic, strong) UILabel     *orderLabel;
@property (nonatomic, strong) UILabel     *orderDecLabel;
@property (nonatomic, strong) UILabel     *storeNumLabel;
@property (nonatomic, strong) UILabel     *storeNumDecLabel;

@end

@implementation XKTransactionDetailViewController


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

#pragma mark - Private Metheods

- (void)cofigNavigationBar {
    [self setNavTitle:@"账单明细" WithColor:[UIColor whiteColor]];
}

- (void)configUI {
    
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.headerImgView];
    [self.headerView addSubview:self.priceLabel];
    [self.headerView addSubview:self.payStatusLabel];
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.goodsLabel];
    [self.contentView addSubview:self.goodsDecLabel];
    [self.contentView addSubview:self.classLabel];
    [self.contentView addSubview:self.classDecLabel];
    [self.contentView addSubview:self.lineView];

    [self.contentView addSubview:self.creatTimeLabel];
    [self.contentView addSubview:self.creatTimeDecLabel];
    [self.contentView addSubview:self.orderLabel];
    [self.contentView addSubview:self.orderDecLabel];
    [self.contentView addSubview:self.storeNumLabel];
    [self.contentView addSubview:self.storeNumDecLabel];
    

    [self layoutaSubViews];
    
}

- (void)layoutaSubViews {
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavigationAndStatue_Height-1));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.headerView);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(13);
        make.centerX.equalTo(self.headerView);
    }];
    
    [self.payStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom);
        make.centerX.equalTo(self.headerView);
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@160);
    }];
    
    [self.goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@100);
    }];
    [self.goodsDecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.goodsLabel.mas_right).offset(10);
        make.centerY.equalTo(self.goodsLabel);
    }];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsLabel.mas_bottom).offset(2);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@100);
    }];
    [self.classDecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.classLabel.mas_right).offset(10);
        make.centerY.equalTo(self.classLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.classDecLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.lineView).offset(15);
        make.width.equalTo(@100);
    }];
    [self.creatTimeDecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.creatTimeLabel.mas_right).offset(10);
        make.centerY.equalTo(self.creatTimeLabel);
    }];
    
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.creatTimeLabel.mas_bottom).offset(2);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@100);
    }];
    [self.orderDecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.orderLabel.mas_right).offset(10);
        make.centerY.equalTo(self.orderLabel);
    }];
    
    [self.storeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderLabel.mas_bottom).offset(2);
        make.left.equalTo(self.contentView).offset(15);
        make.width.equalTo(@100);
    }];
    [self.storeNumDecLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.storeNumLabel.mas_right).offset(10);
        make.centerY.equalTo(self.storeNumLabel);
    }];
}


#pragma mark - Custom Delegates

#pragma mark - Getters and Setters



- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (UIImageView *)headerImgView {
    
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"xk_icon_transcationDetil_back"];
    }
    return _headerImgView;
}


- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEX_RGB(0xFFF26C);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:26];
        _priceLabel.text = @"-200";
    }
    return _priceLabel;
}

- (UILabel *)payStatusLabel {
    if (!_payStatusLabel) {
        _payStatusLabel = [[UILabel alloc] init];
        _payStatusLabel.textColor = HEX_RGB(0xFFFFFF);
        _payStatusLabel.textAlignment = NSTextAlignmentCenter;
        _payStatusLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _payStatusLabel.text = @"支付成功";
    }
    return _payStatusLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}


- (UILabel *)goodsLabel {
    if (!_goodsLabel) {
        _goodsLabel = [[UILabel alloc] init];
        _goodsLabel.textColor = HEX_RGB(0x555555);
        _goodsLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _goodsLabel.textAlignment = NSTextAlignmentLeft;
        _goodsLabel.text = @"商品说明:";
    }
    return _goodsLabel;
}


- (UILabel *)goodsDecLabel {
    if (!_goodsDecLabel) {
        _goodsDecLabel = [[UILabel alloc] init];
        _goodsDecLabel.textColor = HEX_RGB(0x555555);
        _goodsDecLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _goodsDecLabel.textAlignment = NSTextAlignmentRight;
        _goodsDecLabel.text = @"测试测试测试测试";
    }
    return _goodsDecLabel;
}


- (UILabel *)classLabel {
    if (!_classLabel) {
        _classLabel = [[UILabel alloc] init];
        _classLabel.textColor = HEX_RGB(0x555555);
        _classLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _classLabel.textAlignment = NSTextAlignmentLeft;
        _classLabel.text = @"账单分类:";
    }
    return _classLabel;
}


- (UILabel *)classDecLabel {
    if (!_classDecLabel) {
        _classDecLabel = [[UILabel alloc] init];
        _classDecLabel.textColor = HEX_RGB(0x555555);
        _classDecLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _classDecLabel.textAlignment = NSTextAlignmentRight;
        _classDecLabel.text = @"商圈购物";
    }
    return _classDecLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (UILabel *)creatTimeLabel {
    if (!_creatTimeLabel) {
        _creatTimeLabel = [[UILabel alloc] init];
        _creatTimeLabel.textColor = HEX_RGB(0x555555);
        _creatTimeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _creatTimeLabel.textAlignment = NSTextAlignmentLeft;
        _creatTimeLabel.text = @"创建时间:";
    }
    return _creatTimeLabel;
}

- (UILabel *)creatTimeDecLabel {
    if (!_creatTimeDecLabel) {
        _creatTimeDecLabel = [[UILabel alloc] init];
        _creatTimeDecLabel.textColor = HEX_RGB(0x555555);
        _creatTimeDecLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _creatTimeDecLabel.textAlignment = NSTextAlignmentRight;
        _creatTimeDecLabel.text = @"2018-09-12  12:38:32";
    }
    return _creatTimeDecLabel;
}


- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.textColor = HEX_RGB(0x555555);
        _orderLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _orderLabel.textAlignment = NSTextAlignmentLeft;
        _orderLabel.text = @"订单号:";
    }
    return _orderLabel;
}

- (UILabel *)orderDecLabel {
    if (!_orderDecLabel) {
        _orderDecLabel = [[UILabel alloc] init];
        _orderDecLabel.textColor = HEX_RGB(0x555555);
        _orderDecLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _orderDecLabel.textAlignment = NSTextAlignmentRight;
        _orderDecLabel.text = @"37839820349u29";
    }
    return _orderDecLabel;
}

- (UILabel *)storeNumLabel {
    if (!_storeNumLabel) {
        _storeNumLabel = [[UILabel alloc] init];
        _storeNumLabel.textColor = HEX_RGB(0x555555);
        _storeNumLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _storeNumLabel.textAlignment = NSTextAlignmentLeft;
        _storeNumLabel.text = @"商户订单号:";
    }
    return _storeNumLabel;
}

- (UILabel *)storeNumDecLabel {
    if (!_storeNumDecLabel) {
        _storeNumDecLabel = [[UILabel alloc] init];
        _storeNumDecLabel.textColor = HEX_RGB(0x555555);
        _storeNumDecLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _storeNumDecLabel.textAlignment = NSTextAlignmentRight;
        _storeNumDecLabel.text = @"e23333w39820349u29";
    }
    return _storeNumDecLabel;
}

@end










