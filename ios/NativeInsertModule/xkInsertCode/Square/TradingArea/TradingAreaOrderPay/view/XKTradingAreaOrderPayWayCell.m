//
//  XKTradingAreaOrderPayWayCell.m
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderPayWayCell.h"
#import "XKCommonStarView.h"

#define alipaySelectBtnTag      101
#define weixinPaySelectBtnTag   102
#define componPaySelectBtnTag   103

@interface XKTradingAreaOrderPayWayCell ()

@property (nonatomic, strong) UILabel           *payWayLabel;
@property (nonatomic, strong) UIView            *line1;

@property (nonatomic, strong) UIView            *alipayView;
@property (nonatomic, strong) UIImageView       *alipayImgView;
@property (nonatomic, strong) UILabel           *alipayLabel;
@property (nonatomic, strong) UIView            *line2;

@property (nonatomic, strong) UIView            *weixinPayView;
@property (nonatomic, strong) UIImageView       *weixinPayImgView;
@property (nonatomic, strong) UILabel           *weixinPayLabel;
@property (nonatomic, strong) UIView            *line3;

@property (nonatomic, strong) UIView            *componPayView;
@property (nonatomic, strong) UIImageView       *componPayImgView;
@property (nonatomic, strong) UILabel           *componPayLabel;


@property (nonatomic, strong) UIButton    *alipaySelectBtn;
@property (nonatomic, strong) UIButton    *weiXinSelectBtn;
@property (nonatomic, strong) UIButton    *componSelectBtn;


@end

@implementation XKTradingAreaOrderPayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.payWayLabel];
    [self.contentView addSubview:self.line1];
    
    [self.contentView addSubview:self.alipayView];
    [self.alipayView addSubview:self.alipayImgView];
    [self.alipayView addSubview:self.alipayLabel];
    [self.alipayView addSubview:self.alipaySelectBtn];

    [self.contentView addSubview:self.line2];

    [self.contentView addSubview:self.weixinPayView];
    [self.weixinPayView addSubview:self.weixinPayImgView];
    [self.weixinPayView addSubview:self.weixinPayLabel];
    [self.weixinPayView addSubview:self.weiXinSelectBtn];

    [self.contentView addSubview:self.line3];
    
    [self.contentView addSubview:self.componPayView];
    [self.componPayView addSubview:self.componPayImgView];
    [self.componPayView addSubview:self.componPayLabel];
    [self.componPayView addSubview:self.componSelectBtn];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@43);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payWayLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.line1.mas_bottom);
        make.height.equalTo(@43);
    }];
    
    [self.alipayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipayView).offset(15);
        make.centerY.equalTo(self.alipayView);
        make.height.width.equalTo(@20);
    }];
    [self.alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alipayImgView.mas_right).offset(5);
        make.centerY.equalTo(self.alipayImgView);
    }];
    [self.alipaySelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.alipayView);
        make.centerY.equalTo(self.alipayView);
        make.height.width.equalTo(@43);
    }];
    
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alipayView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.weixinPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.line2.mas_bottom);
        make.height.equalTo(@43);
    }];
    [self.weixinPayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weixinPayView).offset(15);
        make.centerY.equalTo(self.weixinPayView);
        make.height.width.equalTo(@20);
    }];
    [self.weixinPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weixinPayImgView.mas_right).offset(5);
        make.centerY.equalTo(self.weixinPayImgView);
    }];
    [self.weiXinSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.weixinPayView);
        make.centerY.equalTo(self.weixinPayView);
        make.height.width.equalTo(@43);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weixinPayView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.componPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.line3.mas_bottom);
        make.height.equalTo(@43);
    }];
    [self.componPayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.componPayView).offset(15);
        make.centerY.equalTo(self.componPayView);
        make.height.width.equalTo(@20);
    }];
    [self.componPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.componPayImgView.mas_right).offset(5);
        make.centerY.equalTo(self.componPayImgView);
    }];
    [self.componSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.componPayView);
        make.centerY.equalTo(self.componPayView);
        make.height.width.equalTo(@43);
    }];

}


#pragma mark - Events

- (void)chooseCouponBtnClicked:(UIButton *)sender {
    
//    if (self.chooseCouponBlock) {
//        self.chooseCouponBlock(@"123");
//    }
}



- (void)paySelectBtnClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = !sender.selected;
    }
    if (sender.tag == alipaySelectBtnTag) {
        self.weiXinSelectBtn.selected = NO;
        self.componSelectBtn.selected = NO;
    } else if (sender.tag == weixinPaySelectBtnTag) {
        self.alipaySelectBtn.selected = NO;
        self.componSelectBtn.selected = NO;
    } else if (sender.tag == componPaySelectBtnTag) {
        self.alipaySelectBtn.selected = NO;
        self.weiXinSelectBtn.selected = NO;
    }
}


#pragma mark - Setter

- (UILabel *)payWayLabel {
    if (!_payWayLabel) {
        _payWayLabel = [[UILabel alloc] init];
        _payWayLabel.text = @"支付方式";
        _payWayLabel.textColor = HEX_RGB(0x222222);
        _payWayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _payWayLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = XKSeparatorLineColor;
    }
    return _line1;
}

- (UIView *)alipayView {
    if (!_alipayView) {
        _alipayView = [[UIView alloc] init];
        _alipayView.backgroundColor = [UIColor whiteColor];
    }
    return _alipayView;
}

- (UIImageView *)alipayImgView {
    if (!_alipayImgView) {
        _alipayImgView = [[UIImageView alloc] init];
        _alipayImgView.image = [UIImage imageNamed:@"xk_btn_order_pay_alipay"];
    }
    return _alipayImgView;
}

- (UILabel *)alipayLabel {
    if (!_alipayLabel) {
        _alipayLabel = [[UILabel alloc] init];
        _alipayLabel.text = @"支付宝";
        _alipayLabel.textColor = HEX_RGB(0x222222);
        _alipayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _alipayLabel;
}
- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = XKSeparatorLineColor;
    }
    return _line2;
}



- (UIView *)weixinPayView {
    if (!_weixinPayView) {
        _weixinPayView = [[UIView alloc] init];
        _weixinPayView.backgroundColor = [UIColor whiteColor];
    }
    return _weixinPayView;
}

- (UIImageView *)weixinPayImgView {
    if (!_weixinPayImgView) {
        _weixinPayImgView = [[UIImageView alloc] init];
        _weixinPayImgView.image = [UIImage imageNamed:@"xk_btn_order_pay_wechat"];
    }
    return _weixinPayImgView;
}

- (UILabel *)weixinPayLabel {
    if (!_weixinPayLabel) {
        _weixinPayLabel = [[UILabel alloc] init];
        _weixinPayLabel.text = @"微信";
        _weixinPayLabel.textColor = HEX_RGB(0x222222);
        _weixinPayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _weixinPayLabel;
}

- (UIView *)line3 {
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = XKSeparatorLineColor;
    }
    return _line3;
}




- (UIView *)componPayView {
    if (!_componPayView) {
        _componPayView = [[UIView alloc] init];
        _componPayView.backgroundColor = [UIColor whiteColor];
    }
    return _componPayView;
}

- (UIImageView *)componPayImgView {
    if (!_componPayImgView) {
        _componPayImgView = [[UIImageView alloc] init];
        _componPayImgView.image = [UIImage imageNamed:@"xk_btn_order_pay_wechat"];
    }
    return _componPayImgView;
}

- (UILabel *)componPayLabel {
    if (!_componPayLabel) {
        _componPayLabel = [[UILabel alloc] init];
        _componPayLabel.text = @"消费券";
        _componPayLabel.textColor = HEX_RGB(0x222222);
        _componPayLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _componPayLabel;
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

- (UIButton *)componSelectBtn {
    
    if (!_componSelectBtn) {
        _componSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 43, 0, 43, 43)];
        _componSelectBtn.tag = componPaySelectBtnTag;
        [_componSelectBtn addTarget:self action:@selector(paySelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_componSelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:UIControlStateNormal];
        [_componSelectBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _componSelectBtn;
}


@end

