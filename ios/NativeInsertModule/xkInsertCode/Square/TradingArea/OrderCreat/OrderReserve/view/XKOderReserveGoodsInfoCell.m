//
//  XKOderReserveGoodsInfoCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOderReserveGoodsInfoCell.h"
#import "XKTradingAreaGoodsInfoModel.h"


@interface XKOderReserveGoodsInfoCell ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;
@property (nonatomic, strong) UILabel           *totalPriceLabel;
@property (nonatomic, strong) UIView            *lineView1;

@property (nonatomic, strong) UILabel           *timeNameLabel;
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) UIView            *lineView2;

@property (nonatomic, strong) UILabel            *numNameLabel;
@property (nonatomic, strong) UIView             *chooseView;
@property (nonatomic, strong) XKHotspotButton    *addBtn;
@property (nonatomic, strong) UILabel            *numLabel;
@property (nonatomic, strong) XKHotspotButton    *reduceBtn;
@property (nonatomic, strong) UIView             *lineView3;


@property (nonatomic, strong) UILabel            *numNameLabel34;
@property (nonatomic, strong) UIView             *chooseView34;
@property (nonatomic, strong) XKHotspotButton    *addBtn34;
@property (nonatomic, strong) UILabel            *numLabel34;
@property (nonatomic, strong) XKHotspotButton    *reduceBtn34;
@property (nonatomic, strong) UIView             *lineView34;

@property (nonatomic, strong) UILabel           *seatLable;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UIView            *lineView4;

@property (nonatomic, strong) UILabel            *tipLabel;
@property (nonatomic, strong) UITextView         *textView;


@end

@implementation XKOderReserveGoodsInfoCell

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
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLabel];
    [self.contentView addSubview:self.totalPriceLabel];
    [self.contentView addSubview:self.lineView1];

    [self.contentView addSubview:self.timeNameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineView2];
    
    [self.contentView addSubview:self.numNameLabel];
    [self.contentView addSubview:self.chooseView];
    [self.chooseView addSubview:self.reduceBtn];
    [self.chooseView addSubview:self.numLabel];
    [self.chooseView addSubview:self.addBtn];
    [self.contentView addSubview:self.lineView3];
    
    
    [self.contentView addSubview:self.numNameLabel34];
    [self.contentView addSubview:self.chooseView34];
    [self.chooseView34 addSubview:self.reduceBtn34];
    [self.chooseView34 addSubview:self.numLabel34];
    [self.chooseView34 addSubview:self.addBtn34];
    [self.contentView addSubview:self.lineView34];
    
    [self.contentView addSubview:self.seatLable];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView4];

    
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.textView];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);

    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.lessThanOrEqualTo(self.totalPriceLabel).offset(-15);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.decLabel);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.timeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeNameLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.timeNameLabel);
    }];
    
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeNameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.numNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.numNameLabel);
    }];
    
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseView);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.chooseView);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reduceBtn.mas_right);
        make.right.equalTo(self.addBtn.mas_left);
        make.centerY.equalTo(self.chooseView);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseView);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.chooseView);
    }];
    
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numNameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.numNameLabel34 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.chooseView34 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.numNameLabel34);
    }];
    
    [self.reduceBtn34 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseView34);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.chooseView34);
    }];
    [self.numLabel34 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reduceBtn34.mas_right);
        make.right.equalTo(self.addBtn34.mas_left);
        make.centerY.equalTo(self.chooseView34);
    }];
    
    [self.addBtn34 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseView34);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.chooseView34);
    }];
    
    
    [self.lineView34 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numNameLabel34.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.seatLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView34.mas_bottom);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@43);
        make.width.equalTo(@100);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seatLable.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.seatLable);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seatLable.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView4.mas_bottom).offset(15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_top).offset(-6);
        make.left.equalTo(self.tipLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@66);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}


#pragma mark - Events

- (void)refreshValue:(BOOL)refresh {
    if (self.valueBlock) {
        self.valueBlock(self.numLabel.text.integerValue, self.numLabel34.text.integerValue, self.textView.text, refresh);
    }
}

- (void)addBtnClicekd:(UIButton *)sender {
    self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue + 1];
    if (self.numLabel.text.intValue >= 99) {
        self.numLabel.text = @"99";
    }

    [self refreshValue:YES];
}


- (void)reduceBtnClicked:(UIButton *)sender {
    
    if (self.numLabel.text.intValue <= 2) {
        self.numLabel.text = @"1";
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue - 1];
    }
    [self refreshValue:YES];
}


- (void)add34BtnClicekd:(UIButton *)sender {
    self.numLabel34.text = [NSString stringWithFormat:@"%d", self.numLabel34.text.intValue + 1];
    if (self.numLabel34.text.intValue >= 99) {
        self.numLabel34.text = @"99";
    }
    [self refreshValue:NO];
}


- (void)reduce34BtnClicked:(UIButton *)sender {
    
    if (self.numLabel34.text.intValue <= 2) {
        self.numLabel34.text = @"1";
    } else {
        self.numLabel34.text = [NSString stringWithFormat:@"%d", self.numLabel34.text.intValue - 1];
    }
    [self refreshValue:NO];
}


- (void)setValueWithModel:(GoodsSkuVOListItem *)model reserveTime:(NSString *)reserveTime num:(NSInteger)num peopleNum:(NSInteger)peopleNum seatName:(NSString *)seatNames {
    
    if (model.purchased) {
        self.seatLable.hidden = NO;
        self.textField.hidden = NO;
        self.lineView4.hidden = NO;
        [self.seatLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@43);
        }];
        [self.lineView4 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
        }];
    } else {
        
        self.seatLable.hidden = YES;
        self.textField.hidden = YES;
        self.lineView4.hidden = YES;
        [self.seatLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.lineView4 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    self.nameLabel.text = model.goodsName;
    self.decLabel.text = model.skuName;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.discountPrice.floatValue / 100.0];
    if (reserveTime.length >= 19) {
        self.timeLabel.text = [reserveTime substringToIndex:16];
    } else {
        self.timeLabel.text = reserveTime;
    }
    self.numLabel.text = [NSString stringWithFormat:@"%ld", num];
    self.numLabel34.text = [NSString stringWithFormat:@"%ld", peopleNum];

    self.textField.placeholder = [NSString stringWithFormat:@"请选择餐桌号(最多%ld个)", num];
    self.textField.text = seatNames;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >= 20) {
        self.textView.text = [textView.text substringToIndex:20];
        [XKHudView showWarnMessage:@"已超出最大字符长度"];
    }
    [self refreshValue:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView endEditing:YES];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.seatChooseBlock) {
        self.seatChooseBlock();
    }
    return NO;
}


#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"洗荤jo套餐+spa";
    }
    return _nameLabel;
}


- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLabel.textColor = HEX_RGB(0x555555);
        _decLabel.textAlignment = NSTextAlignmentLeft;
//        _decLabel.text = @"荤jo套餐，巴适得板（5小时）";
    }
    return _decLabel;
}

- (UILabel *)totalPriceLabel {
    
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _totalPriceLabel.textColor = HEX_RGB(0xEE6161);
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
//        _totalPriceLabel.text = @"￥988";
    }
    return _totalPriceLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView1;
}


- (UILabel *)timeNameLabel {
    if (!_timeNameLabel) {
        _timeNameLabel = [[UILabel alloc] init];
        _timeNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _timeNameLabel.textColor = HEX_RGB(0x222222);
        _timeNameLabel.textAlignment = NSTextAlignmentLeft;
        _timeNameLabel.text = @"时间";
    }
    return _timeNameLabel;
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _timeLabel.textColor = HEX_RGB(0x777777);
        _timeLabel.textAlignment = NSTextAlignmentRight;
//        _timeLabel.text = @"09-10 13:34:00前";
    }
    return _timeLabel;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}


- (UILabel *)numNameLabel {
    if (!_numNameLabel) {
        _numNameLabel = [[UILabel alloc] init];
        _numNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _numNameLabel.textColor = HEX_RGB(0x222222);
        _numNameLabel.textAlignment = NSTextAlignmentLeft;
        _numNameLabel.text = @"套餐数量";
    }
    return _numNameLabel;
}


- (UIView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[UIView alloc] init];
        _chooseView.backgroundColor = [UIColor whiteColor];
    }
    return _chooseView;
}

- (XKHotspotButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[XKHotspotButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.text = @"1";
        _numLabel.textColor = HEX_RGB(0x222222);
        _numLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _numLabel;
}

- (XKHotspotButton *)reduceBtn {
    if (!_reduceBtn) {
        _reduceBtn = [[XKHotspotButton alloc] init];
        [_reduceBtn setImage:[UIImage imageNamed:@"xk_btn_TradingArea_reduce"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}



- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView3;
}

- (UILabel *)numNameLabel34 {
    if (!_numNameLabel34) {
        _numNameLabel34 = [[UILabel alloc] init];
        _numNameLabel34.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _numNameLabel34.textColor = HEX_RGB(0x222222);
        _numNameLabel34.textAlignment = NSTextAlignmentLeft;
        _numNameLabel34.text = @"人数";
    }
    return _numNameLabel34;
}


- (UIView *)chooseView34 {
    if (!_chooseView34) {
        _chooseView34 = [[UIView alloc] init];
        _chooseView34.backgroundColor = [UIColor whiteColor];
    }
    return _chooseView34;
}

- (XKHotspotButton *)addBtn34 {
    if (!_addBtn34) {
        _addBtn34 = [[XKHotspotButton alloc] init];
        [_addBtn34 setImage:[UIImage imageNamed:@"xk_btn_TradingArea_add"] forState:UIControlStateNormal];
        [_addBtn34 addTarget:self action:@selector(add34BtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn34;
}


- (UILabel *)numLabel34 {
    if (!_numLabel34) {
        _numLabel34 = [[UILabel alloc] init];
        _numLabel34.textAlignment = NSTextAlignmentCenter;
        _numLabel34.text = @"1";
        _numLabel34.textColor = HEX_RGB(0x222222);
        _numLabel34.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _numLabel34;
}

- (XKHotspotButton *)reduceBtn34 {
    if (!_reduceBtn34) {
        _reduceBtn34 = [[XKHotspotButton alloc] init];
        [_reduceBtn34 setImage:[UIImage imageNamed:@"xk_btn_TradingArea_reduce"] forState:UIControlStateNormal];
        [_reduceBtn34 addTarget:self action:@selector(reduce34BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn34;
}



- (UIView *)lineView34 {
    if (!_lineView34) {
        _lineView34 = [[UIView alloc] init];
        _lineView34.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView34;
}



- (UILabel *)seatLable {
    if (!_seatLable) {
        _seatLable = [[UILabel alloc] init];
        _seatLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _seatLable.textColor = HEX_RGB(0x222222);
        _seatLable.textAlignment = NSTextAlignmentLeft;
        _seatLable.text = @"餐桌号";
    }
    return _seatLable;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
//        _textField.placeholder = @"请选择席位";
        [_textField setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.delegate = self;
        _textField.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _textField.textColor = HEX_RGB(0x555555);
        _textField.returnKeyType = UIReturnKeyDone;
        
    }
    return _textField;
}

- (UIView *)lineView4 {
    if (!_lineView4) {
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView4;
}


- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _tipLabel.textColor = HEX_RGB(0x222222);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.text = @"备注：";
    }
    return _tipLabel;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.placeholder = @"您可以填写您的需求，商家会尽量为您安排";
        [_textView setValue:HEX_RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        _textView.delegate = self;
        _textView.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _textView.textColor = HEX_RGB(0x555555);
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}



@end








