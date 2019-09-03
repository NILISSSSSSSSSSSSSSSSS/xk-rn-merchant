//
//  XKTradingAreaOrderPayCouponCell.m
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderPayCouponCell.h"
#import "XKTradingAreaOrderCouponModel.h"
#import "XKCommonStarView.h"

@interface XKTradingAreaOrderPayCouponCell ()

@property (nonatomic, strong) UILabel           *firstLabel;
@property (nonatomic, strong) UILabel           *firstPriceLabel;
@property (nonatomic, strong) UIView            *lineView1;

@property (nonatomic, strong) UILabel           *couponLabel;
@property (nonatomic, strong) UIButton          *chooseCouponBtn;
@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UIView            *lineView2;

@property (nonatomic, strong) UILabel           *totalPriceLabel;
@property (nonatomic, assign) CGFloat           totalPrice;


@end

@implementation XKTradingAreaOrderPayCouponCell

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
    
    [self.contentView addSubview:self.firstLabel];
    [self.contentView addSubview:self.firstPriceLabel];
    [self.contentView addSubview:self.lineView1];
    
    [self.contentView addSubview:self.couponLabel];
    [self.contentView addSubview:self.chooseCouponBtn];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.lineView2];
    
    [self.contentView addSubview:self.totalPriceLabel];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.firstPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLabel.mas_top);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.firstLabel.mas_right).offset(15);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstPriceLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView).offset(15);
      make.top.equalTo(self.lineView1.mas_bottom).offset(15);
      make.height.equalTo(@14);
      make.width.equalTo(@100);
    }];
     
    [self.chooseCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.greaterThanOrEqualTo(self.couponLabel.mas_right).offset(10);
      make.right.equalTo(self.imgView.mas_left).offset(-5);
      make.centerY.equalTo(self.couponLabel);
    }];
     
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.contentView).offset(-15);
      make.width.equalTo(@7);
      make.height.equalTo(@10);
      make.centerY.equalTo(self.couponLabel);
    }];
     
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.couponLabel.mas_bottom).offset(15);
      make.left.right.equalTo(self.contentView);
      make.height.equalTo(@1);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        make.right.bottom.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@20);
    }];
}


- (void)setValueWithModel:(XKTradingAreaOrderCouponModel *)model totalPrice:(CGFloat)totalPrice reducePrice:(CGFloat)reducePrice depositPrice:(CGFloat)depositPrice couponNum:(NSInteger)couponNum {
    self.chooseCouponBtn.userInteractionEnabled = YES;
    
    if (depositPrice) {
        self.firstLabel.hidden = NO;
        self.firstPriceLabel.hidden = NO;
        self.lineView1.hidden = NO;
        
        [self.firstPriceLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(5);
            confer.text([NSString stringWithFormat:@"-￥%.2f", depositPrice]).textColor(HEX_RGB(0xee6161)).font(XKRegularFont(17));
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"已支付定金￥%.2f，剩余定金￥%.2f", depositPrice, reducePrice]).textColor(HEX_RGB(0x999999)).font(XKRegularFont(12));
        }];
        
        [self.firstLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(15);
            make.height.equalTo(@14);
        }];
        [self.lineView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstPriceLabel.mas_bottom).offset(15);
        }];
        
    } else {
        
        self.firstLabel.hidden = YES;
        self.firstPriceLabel.hidden = YES;
        self.lineView1.hidden = YES;
        self.firstPriceLabel.text = nil;
        
        [self.firstLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(0);
            make.height.equalTo(@0);
        }];
        [self.lineView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstPriceLabel.mas_bottom).offset(0);
        }];
    }
    
    if (!model) {
        if (couponNum) {
            [self.chooseCouponBtn setTitle:[NSString stringWithFormat:@"%d张可用", (int)couponNum] forState:UIControlStateNormal];
            [self.chooseCouponBtn setTitleColor:HEX_RGB(0xee6161) forState:UIControlStateNormal];
        } else {
            [self.chooseCouponBtn setTitle:@"暂无可用" forState:UIControlStateNormal];
            [self.chooseCouponBtn setTitleColor:HEX_RGB(0x666666) forState:UIControlStateNormal];
            self.chooseCouponBtn.userInteractionEnabled = NO;
        }
    } else {
        NSString *str = [NSString stringWithFormat:@"(%@)-￥%.2f", model.cardName,reducePrice];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0x666666)} range:NSMakeRange(0, model.cardName.length + 2)];
        [self.chooseCouponBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
    [self.totalPriceLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(5);
        if (reducePrice) {
            confer.text(@"已优惠");
            confer.text([NSString stringWithFormat:@"￥%.2f", reducePrice]);
        }
        confer.text(@"   合计 ").textColor(HEX_RGB(0x555555)).font(XKRegularFont(14));
        confer.text([NSString stringWithFormat:@"￥%.2f", totalPrice - reducePrice]).textColor(HEX_RGB(0x222222)).font(XKMediumFont(17));
    }];
}


#pragma mark - Events

- (void)chooseCouponBtnClicked:(UIButton *)sender {
    
    if (self.chooseCouponBlock) {
        self.chooseCouponBlock();
    }
}

#pragma mark - Setter

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _firstLabel.textColor = HEX_RGB(0x222222);
        _firstLabel.textAlignment = NSTextAlignmentLeft;
        _firstLabel.text = @"定金抵扣";
    }
    return _firstLabel;
}


- (UILabel *)firstPriceLabel {
    
    if (!_firstPriceLabel) {
        _firstPriceLabel = [[UILabel alloc] init];
        _firstPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _firstPriceLabel.textColor = HEX_RGB(0xEE6161);
        _firstPriceLabel.textAlignment = NSTextAlignmentRight;
//        _firstPriceLabel.text = @"-￥20";
    }
    return _firstPriceLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView1;
}


- (UILabel *)couponLabel {
    if (!_couponLabel) {
        _couponLabel = [[UILabel alloc] init];
        _couponLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _couponLabel.textColor = HEX_RGB(0x222222);
        _couponLabel.textAlignment = NSTextAlignmentLeft;
        _couponLabel.text = @"优惠券/会员卡";
    }
    return _couponLabel;
}

- (UIButton *)chooseCouponBtn {
    if (!_chooseCouponBtn) {
        _chooseCouponBtn = [[UIButton alloc] init];
        _chooseCouponBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
//        [_chooseCouponBtn setTitle:@"选择优惠券" forState:UIControlStateNormal];
        [_chooseCouponBtn setTitleColor:HEX_RGB(0xEE6161) forState:UIControlStateNormal];
        [_chooseCouponBtn addTarget:self action:@selector(chooseCouponBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseCouponBtn;
}

-(UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"];
    }
    return _imgView;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}

- (UILabel *)totalPriceLabel {
    
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _totalPriceLabel.textColor = HEX_RGB(0xEE6161);
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
//        _totalPriceLabel.text = @"已优惠￥20  合计￥180";
    }
    return _totalPriceLabel;
}



@end

