//
//  XKTradingAreaOrderSeviceRefundCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaOrderSeviceRefundCell.h"
#import "XKTradingAreaOrderDetaiModel.h"

@interface XKTradingAreaOrderSeviceRefundCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UIButton          *moreBtn;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) YYLabel           *decLabel;
@property (nonatomic, strong) UIView            *backView;

@end

@implementation XKTradingAreaOrderSeviceRefundCell

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
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.moreBtn];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.decLabel];
}


- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView).offset(15);
        make.right.equalTo(self.moreBtn.mas_left).offset(-10);
        make.height.equalTo(@14);
    }];
    
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-10);
        make.centerY.equalTo(self.nameLabel);
        make.height.with.equalTo(@16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.backView);
        make.height.equalTo(@1);
    }];

    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.bottom.equalTo(self.backView).offset(-15);
    }];
}


- (void)lookDetailBtnCliked:(UIButton *)sender {
    
    if (self.lookDetailBlock) {
        self.lookDetailBlock();
    }
}

- (void)setValueWithModel:(OrderItems *)model shopName:(NSString *)shopName {
    
    self.nameLabel.text = shopName;
    self.moreBtn.selected = model.isSelected;
    CGFloat totalPrice = 0;
    CGFloat waitPrice = 0;
    CGFloat payedPrice = 0;
    
    totalPrice = model.platformShopPrice.floatValue;
    if ([model.payStatus isEqualToString:@"SUCCESS_PAY"]) {
        payedPrice = model.platformShopPrice.floatValue;
    } else {
        waitPrice = model.platformShopPrice.floatValue;
    }
    for (PurchasesItem *item in model.purchases) {
        totalPrice += item.platformShopPrice.floatValue;
        if ([item.payStatus isEqualToString:@"SUCCESS_PAY"]) {
            payedPrice += item.platformShopPrice.floatValue;
        } else {
            waitPrice += item.platformShopPrice.floatValue;
        }
    }
    

    _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    _decLabel.textColor = HEX_RGB(0x555555);
    NSMutableAttributedString *attStr = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(10);
        
        if (model.seatName) {
            confer.text([NSString stringWithFormat:@"席位：%@", model.seatName]).textColor(HEX_RGB(0x555555)).font(XKRegularFont(14));
            confer.text(@"\n");
            //        confer.text(@"今天（90-0）13:00 - 17:00 共5小时");
            //        confer.text(@"\n");
        }
        confer.text(@"套餐数量：1").textColor(HEX_RGB(0x555555)).font(XKRegularFont(14));
        confer.text(@"\n");
        confer.text(@"订单总额：").textColor(HEX_RGB(0x555555)).font(XKRegularFont(14));
        confer.text([NSString stringWithFormat:@"￥%.2f", totalPrice]).textColor(HEX_RGB(0xee6161)).font(XKRegularFont(14));
        confer.text(@"\n");
        confer.text(@"已支付：").textColor(HEX_RGB(0x555555)).font(XKRegularFont(14));
        confer.text([NSString stringWithFormat:@"￥%.2f", payedPrice]).textColor(HEX_RGB(0xee6161)).font(XKRegularFont(14));
        confer.text(@"\n");
        confer.text(@"未支付：").textColor(HEX_RGB(0x555555)).font(XKRegularFont(14));
        confer.text([NSString stringWithFormat:@"￥%.2f", waitPrice]).textColor(HEX_RGB(0xee6161)).font(XKRegularFont(14));
        if (model.purchases.count) {
            confer.text(@"\n");
            confer.text([NSString stringWithFormat:@"加购商品数：%d件", (int)model.purchases.count]).textColor(HEX_RGB(0x555555)).font(XKRegularFont(14));
            confer.text(@"  查看详情").textColor(XKMainTypeColor).font(XKRegularFont(14));
        }
    }].mutableCopy;
    NSRange range = [attStr.string rangeOfString:@"  查看详情"];
    
    if (range.location) {
        [attStr yy_setTextHighlightRange:range color:XKMainTypeColor backgroundColor:XKMainTypeColor userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            if (self.lookDetailBlock) {
                self.lookDetailBlock();
            }
        } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        }];
    }
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH-50, MAXFLOAT) text:attStr];
    self.decLabel.attributedText = attStr;
    [self.decLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(layout.textBoundingSize.height));
    }];
}

#pragma mark - Setter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5.0;
    }
    return _backView;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
        [_moreBtn setImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
    }
    return _moreBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"沉沉的的说法叫师傅";
    }
    return _nameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (YYLabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[YYLabel alloc] init];
        _decLabel.numberOfLines = 0;
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _decLabel.textColor = HEX_RGB(0x555555);
        _decLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _decLabel;
}

@end
