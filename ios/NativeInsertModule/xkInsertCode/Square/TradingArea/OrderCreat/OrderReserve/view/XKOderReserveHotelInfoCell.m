//
//  XKOderReserveHotelInfoCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOderReserveHotelInfoCell.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKServiceBookTimeChooseView.h"
#import "XKCommonSheetView.h"


@interface XKOderReserveHotelInfoCell ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;
@property (nonatomic, strong) UIView            *lineView1;

@property (nonatomic, strong) UILabel           *inTimeLabel;
@property (nonatomic, strong) UIButton          *inTimeBtn;
@property (nonatomic, strong) UIView            *lineView2;

@property (nonatomic, strong) UILabel           *outTimeLabel;
@property (nonatomic, strong) UIButton          *outTimeBtn;
@property (nonatomic, strong) UIView            *lineView3;
/*
@property (nonatomic, strong) UILabel            *userNameLabel;
@property (nonatomic, strong) UITextField        *textField;
@property (nonatomic, strong) UIView             *lineView4;*/

@property (nonatomic, strong) UILabel            *numNameLabel;
@property (nonatomic, strong) UIView             *chooseView;
@property (nonatomic, strong) XKHotspotButton    *addBtn;
@property (nonatomic, strong) UILabel            *numLabel;
@property (nonatomic, strong) XKHotspotButton    *reduceBtn;
@property (nonatomic, strong) UIView             *lineView5;

@property (nonatomic, strong) UILabel            *numNameLabel34;
@property (nonatomic, strong) UIView             *chooseView34;
@property (nonatomic, strong) XKHotspotButton    *addBtn34;
@property (nonatomic, strong) UILabel            *numLabel34;
@property (nonatomic, strong) XKHotspotButton    *reduceBtn34;
@property (nonatomic, strong) UIView             *lineView34;

@property (nonatomic, strong) UILabel            *tipLabel;
@property (nonatomic, strong) UITextView         *textView;


@property (nonatomic, strong) XKCommonSheetView            *chooseTimeSheetView;
@property (nonatomic, strong) XKServiceBookTimeChooseView  *timeChooseView;


@end

@implementation XKOderReserveHotelInfoCell

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
    [self.contentView addSubview:self.lineView1];

    [self.contentView addSubview:self.inTimeLabel];
    [self.contentView addSubview:self.inTimeBtn];
    [self.contentView addSubview:self.lineView2];
    
    [self.contentView addSubview:self.outTimeLabel];
    [self.contentView addSubview:self.outTimeBtn];
    [self.contentView addSubview:self.lineView3];
    /*
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView4];*/

    [self.contentView addSubview:self.numNameLabel];
    [self.contentView addSubview:self.chooseView];
    [self.chooseView addSubview:self.reduceBtn];
    [self.chooseView addSubview:self.numLabel];
    [self.chooseView addSubview:self.addBtn];
    
    [self.contentView addSubview:self.lineView5];
    [self.contentView addSubview:self.numNameLabel34];
    [self.contentView addSubview:self.chooseView34];
    [self.chooseView34 addSubview:self.reduceBtn34];
    [self.chooseView34 addSubview:self.numLabel34];
    [self.chooseView34 addSubview:self.addBtn34];
    [self.contentView addSubview:self.lineView34];
    
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
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    [self.inTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.inTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.inTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.inTimeLabel);
    }];
    
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inTimeLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    
    
    [self.outTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView2.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.outTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.inTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.outTimeLabel);
    }];
    
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.outTimeLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    /*
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.userNameLabel);
    }];
    
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];*/
    
    
    [self.numNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView3.mas_bottom).offset(15);
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
    

    [self.lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numNameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.numNameLabel34 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView5.mas_bottom).offset(15);
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
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView34.mas_bottom).offset(15);
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
        NSString *startDateStr = nil;
        NSString *endDateStr = nil;
        if (![self.inTimeBtn.titleLabel.text isEqualToString:@"请选择时间"]) {
            startDateStr = self.inTimeBtn.titleLabel.text;
        }
        if (![self.outTimeBtn.titleLabel.text isEqualToString:@"请选择时间"]) {
            endDateStr = self.outTimeBtn.titleLabel.text;
        }
        self.valueBlock(startDateStr, endDateStr, self.numLabel.text.integerValue, self.numLabel34.text.integerValue, self.textView.text, refresh);
    }
}


- (void)addBtnClicekd:(UIButton *)sender {
    self.numLabel.text = [NSString stringWithFormat:@"%d", self.numLabel.text.intValue + 1];
    if (self.numLabel.text.intValue >= 99) {
        self.numLabel.text = @"99";
    }
    //加入购物车
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


- (void)inTimeBtnCiliked:(UIButton *)sender {
    self.inTimeBtn.selected = YES;
    self.outTimeBtn.selected = NO;
    
    [self.timeChooseView setCustomDatePickModel:UIDatePickerModeDate minDate:[NSDate date] maxDate:nil];
    [self.chooseTimeSheetView show];
}


- (void)outTimeBtnCiliked:(UIButton *)sender {
    
    self.inTimeBtn.selected = NO;
    self.outTimeBtn.selected = YES;
    
    NSDate *minDate = [XKTimeSeparateHelper backYMDDateByStrigulaSegmentWithTimeString:[XKTimeSeparateHelper backNewDateWithDays:1 fromTimeString:self.inTimeBtn.titleLabel.text]];
    [self.timeChooseView setCustomDatePickModel:UIDatePickerModeDate minDate:minDate maxDate:nil];
    [self.chooseTimeSheetView show];
}



- (void)timeSure:(NSString *)time {
    
    if (self.inTimeBtn.selected) {
        [self.inTimeBtn setTitle:time forState:UIControlStateNormal];
    } else {
        [self.outTimeBtn setTitle:time forState:UIControlStateNormal];
    }
    
    [self.chooseTimeSheetView dismiss];

    [self refreshValue:YES];
}

- (void)timeCance {
    self.inTimeBtn.selected = NO;
    self.outTimeBtn.selected = NO;
    [self.chooseTimeSheetView dismiss];
}




- (void)setValueWithModel:(GoodsSkuVOListItem *)model startDateStr:(NSString *)startDateStr endDateStr:(NSString *)endDateStr hoseNum:(NSInteger)num peopleNum:(NSInteger)peopleNum tipStr:(NSString *)tips {
    self.nameLabel.text = model.goodsName;
    self.decLabel.text = model.skuName;
    
    if (startDateStr.length) {
        [self.inTimeBtn setTitle:startDateStr forState:UIControlStateNormal];
    }
    if (endDateStr.length) {
        [self.outTimeBtn setTitle:endDateStr forState:UIControlStateNormal];
    }

    self.numLabel.text = [NSString stringWithFormat:@"%d", (int)num];
    self.numLabel34.text = [NSString stringWithFormat:@"%d", (int)peopleNum];
    self.textView.text = tips;
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

/*
#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self refreshValue:NO];
    [self.textField resignFirstResponder];
    return NO;
}*/



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



#pragma mark - Setter

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
//        _nameLabel.text = @"酒店大床房间";
    }
    return _nameLabel;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLabel.textColor = HEX_RGB(0x555555);
        _decLabel.textAlignment = NSTextAlignmentLeft;
//        _decLabel.text = @"wifi、独立卫生间、有床。。。。";
    }
    return _decLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView1;
}


- (UILabel *)inTimeLabel {
    if (!_inTimeLabel) {
        _inTimeLabel = [[UILabel alloc] init];
        _inTimeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _inTimeLabel.textColor = HEX_RGB(0x222222);
        _inTimeLabel.textAlignment = NSTextAlignmentLeft;
        _inTimeLabel.text = @"住店时间";
    }
    return _inTimeLabel;
}


- (UIButton *)inTimeBtn {
    if (!_inTimeBtn) {
        _inTimeBtn = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 200, 44) font:XKRegularFont(14) title:@"请选择时间" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_inTimeBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_inTimeBtn setImageAtRightAndTitleAtLeftWithSpace:5];
        [_inTimeBtn addTarget:self action:@selector(inTimeBtnCiliked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inTimeBtn;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}


- (UILabel *)outTimeLabel {
    if (!_outTimeLabel) {
        _outTimeLabel = [[UILabel alloc] init];
        _outTimeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _outTimeLabel.textColor = HEX_RGB(0x222222);
        _outTimeLabel.textAlignment = NSTextAlignmentLeft;
        _outTimeLabel.text = @"离店时间";
    }
    return _outTimeLabel;
}


- (UIButton *)outTimeBtn {
    if (!_outTimeBtn) {
        
        _outTimeBtn = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 200, 44) font:XKRegularFont(14) title:@"请选择时间" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_outTimeBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_outTimeBtn setImageAtRightAndTitleAtLeftWithSpace:5];
        [_outTimeBtn addTarget:self action:@selector(outTimeBtnCiliked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outTimeBtn;
}

- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView3;
}


/*
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _userNameLabel.textColor = HEX_RGB(0x222222);
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.text = @"入住人";
    }
    return _userNameLabel;
}


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.placeholder = @"请填写入住人姓名";
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
}*/


- (UILabel *)numNameLabel {
    if (!_numNameLabel) {
        _numNameLabel = [[UILabel alloc] init];
        _numNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _numNameLabel.textColor = HEX_RGB(0x222222);
        _numNameLabel.textAlignment = NSTextAlignmentLeft;
        _numNameLabel.text = @"房间数量";
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


- (XKServiceBookTimeChooseView *)timeChooseView {
    if (!_timeChooseView) {
        _timeChooseView = [[XKServiceBookTimeChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 315+kBottomSafeHeight)];
        XKWeakSelf(weakSelf);
        _timeChooseView.timeBlock = ^(NSString *time) {
            [weakSelf timeSure:time];
        };
        _timeChooseView.cancelBlock = ^{
            [weakSelf timeCance];
        };
    }
    return _timeChooseView;
}

- (XKCommonSheetView *)chooseTimeSheetView {
    
    if (!_chooseTimeSheetView) {
        _chooseTimeSheetView = [[XKCommonSheetView alloc] init];
        _chooseTimeSheetView.addBottomSafeHeight = YES;
        _chooseTimeSheetView.contentView = self.timeChooseView;
        [_chooseTimeSheetView addSubview:self.timeChooseView];
    }
    return _chooseTimeSheetView;
}


- (UIView *)lineView5 {
    if (!_lineView5) {
        _lineView5 = [[UIView alloc] init];
        _lineView5.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView5;
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








