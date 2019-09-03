//
//  XKTransactionDetailTimeChooseView.m
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTransactionDetailTimeChooseView.h"
#import "XKTimeSeparateHelper.h"

@interface XKTransactionDetailTimeChooseView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView       *toolView;
@property (nonatomic, strong) UIView       *lineView;

@property (nonatomic, strong) UIButton     *cancelBtn;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UIButton     *sureBtn;
@property (nonatomic, strong) UIView       *changeView;
@property (nonatomic, strong) UILabel      *changeLabel;
@property (nonatomic, strong) UIImageView  *changeImgView;

@property (nonatomic, strong) UIView       *monthChooseContentView;
@property (nonatomic, strong) UIView       *monthChooseLineView;
@property (nonatomic, strong) UILabel      *monthChooseDateLabel;

@property (nonatomic, strong) UIView       *dayChooseContentView;
@property (nonatomic, strong) UIView       *dayChooseLeftLineView;
@property (nonatomic, strong) UIButton     *dayChooseDateLeftBtn;
@property (nonatomic, strong) UILabel      *dayChooseDateMiddleLabel;
@property (nonatomic, strong) UIView       *dayChooseRightLineView;
@property (nonatomic, strong) UIButton      *dayChooseDateRightBtn;


@property (nonatomic, strong) UIButton     *deleteBtn;
@property (nonatomic, strong) UIDatePicker *datePick;
@property (nonatomic, strong) UIPickerView *datePickView;
@property (nonatomic, copy  ) NSArray      *datePickViewMonthArr;
@property (nonatomic, copy  ) NSArray      *datePickViewYearArr;

@end


@implementation XKTransactionDetailTimeChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}



- (void)addCustomSubviews {
    self.datePickViewMonthArr = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月",@"11月", @"12月"];
    self.datePickViewYearArr = @[@"2022年", @"2021年", @"2020年", @"2019年", @"2018年", @"2017年", @"2016年", @"2015年"];


    [self addSubview:self.toolView];
    [self.toolView addSubview:self.cancelBtn];
    [self.toolView addSubview:self.titleLabel];
    [self.toolView addSubview:self.sureBtn];
    [self.toolView addSubview:self.lineView];
    
    [self addSubview:self.changeView];
    [self.changeView addSubview:self.changeLabel];
    [self.changeView addSubview:self.changeImgView];
    
    [self addSubview:self.monthChooseContentView];
    [self.monthChooseContentView addSubview:self.monthChooseDateLabel];
    [self.monthChooseContentView addSubview:self.monthChooseLineView];
    
    [self addSubview:self.dayChooseContentView];
    [self.dayChooseContentView addSubview:self.dayChooseDateLeftBtn];
    [self.dayChooseContentView addSubview:self.dayChooseLeftLineView];
    [self.dayChooseContentView addSubview:self.dayChooseDateMiddleLabel];
    [self.dayChooseContentView addSubview:self.dayChooseDateRightBtn];
    [self.dayChooseContentView addSubview:self.dayChooseRightLineView];
    
    [self addSubview:self.deleteBtn];
    [self addSubview:self.datePick];
    [self addSubview:self.datePickView];
    

}

- (void)addUIConstraint {
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@46);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.toolView);
        make.width.equalTo(@80);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.toolView);
        make.width.equalTo(@80);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.toolView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.toolView);
        make.height.equalTo(@1);
    }];

    [self.changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView.mas_bottom).offset(14);
        make.left.equalTo(self).offset(25);
        make.width.equalTo(@100);
        make.height.equalTo(@24);
    }];
    
    [self.changeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.changeView).offset(-10);
        make.width.height.equalTo(@14);
        make.centerY.equalTo(self.changeView);
    }];
    
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.changeView).offset(10);
        make.top.bottom.equalTo(self.changeView);
        make.right.equalTo(self.changeImgView.mas_left);
    }];
    
    [self.monthChooseContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(self.changeView.mas_bottom);
        make.height.equalTo(@47);
    }];
    
    [self.monthChooseLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.monthChooseContentView);
        make.height.equalTo(@1);
    }];
    
    [self.monthChooseDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.monthChooseContentView);
    }];
    
    
    [self.dayChooseContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(self.changeView.mas_bottom);
        make.height.equalTo(@47);
    }];
    
    [self.dayChooseDateMiddleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.dayChooseContentView);
        make.width.equalTo(@45);
        make.centerX.equalTo(self.dayChooseContentView);
    }];
    
    [self.dayChooseLeftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.dayChooseContentView);
        make.right.equalTo(self.dayChooseDateMiddleLabel.mas_left);
        make.height.equalTo(@1);
    }];
    
    [self.dayChooseDateLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.dayChooseContentView);
        make.right.equalTo(self.dayChooseDateMiddleLabel.mas_left);
        make.height.equalTo(@45);
    }];
    
    
    [self.dayChooseRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.dayChooseContentView);
        make.left.equalTo(self.dayChooseDateMiddleLabel.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.dayChooseDateRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.dayChooseContentView);
        make.left.equalTo(self.dayChooseDateMiddleLabel.mas_right);
        make.height.equalTo(@45);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthChooseContentView.mas_bottom).offset(15);
        make.right.equalTo(self).offset(-25);
        make.height.width.equalTo(@25);
    }];
    
    [self.datePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(self.deleteBtn.mas_bottom).offset(10);
    }];
    
    [self.datePickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(self.deleteBtn.mas_bottom).offset(10);
    }];
    
}


- (void)cancelBtnClicked:(UIButton *)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}


- (void)sureBtnClicked:(UIButton *)sender {
    if (self.sureBlock) {
        self.sureBlock(self.monthChooseDateLabel.text, self.dayChooseDateLeftBtn.titleLabel.text, self.dayChooseDateRightBtn.titleLabel.text, self.monthChooseContentView.hidden ? 1 : 0);
    }
    
}


- (void)changeTimeWay:(UITapGestureRecognizer *)tap {
    
    if (self.monthChooseContentView.hidden) {//按月
        self.monthChooseContentView.hidden = NO;
        self.dayChooseContentView.hidden = YES;
        self.datePickView.hidden = NO;
        self.datePick.hidden = YES;
        self.changeLabel.text = @"按月选择";
    
        
    } else {                                //按日
        self.monthChooseContentView.hidden = YES;
        self.dayChooseContentView.hidden = NO;
        self.datePickView.hidden = YES;
        self.datePick.hidden = NO;
        self.datePick.datePickerMode = UIDatePickerModeDate;
        self.changeLabel.text = @"按日选择";
    }
}

- (void)changeTimeButtonClicked:(UIButton *)sender {
    
    if (sender == self.dayChooseDateLeftBtn) {
        self.dayChooseDateLeftBtn.selected = YES;
        self.dayChooseDateRightBtn.selected = NO;
        self.dayChooseLeftLineView.backgroundColor = XKMainTypeColor;
        self.dayChooseRightLineView.backgroundColor = HEX_RGB(0x999999);
    } else {
        self.dayChooseDateLeftBtn.selected = NO;
        self.dayChooseDateRightBtn.selected = YES;
        self.dayChooseLeftLineView.backgroundColor = HEX_RGB(0x999999);
        self.dayChooseRightLineView.backgroundColor = XKMainTypeColor;
    }
}



- (void)deleteBtnClicked:(UIButton *)sender {
    
    if (!self.monthChooseContentView.hidden) {//按月
        self.monthChooseDateLabel.text = @"";
    } else {                                //按日
        if (sender == self.dayChooseDateLeftBtn) {
            [self.dayChooseDateLeftBtn setTitle:@"" forState:UIControlStateNormal];
        } else {
            [self.dayChooseDateRightBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }
}


#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.datePickViewYearArr.count;
    }
    return self.datePickViewMonthArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.datePickViewYearArr[row];
    }
    return self.datePickViewMonthArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *str = self.monthChooseDateLabel.text;
    if (component == 0) {
        str = [NSString stringWithFormat:@"%@-%@",  [self.datePickViewYearArr[row] substringWithRange:NSMakeRange(0, [self.datePickViewYearArr[row] length] - 1)], [str componentsSeparatedByString:@"-"].lastObject];
    } else {
        str = [NSString stringWithFormat:@"%@-%@", [str componentsSeparatedByString:@"-"].firstObject, [self.datePickViewMonthArr[row] substringWithRange:NSMakeRange(0, [self.datePickViewMonthArr[row] length] - 1)]];
    }
    self.monthChooseDateLabel.text = str;
}

#pragma mark - getter && setter


- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
    }
    return _toolView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _cancelBtn;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择时间";
        _titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _titleLabel.textColor = HEX_RGB(0x222222);
    }
    return _titleLabel;
}


- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _sureBtn;
}

- (UIView *)changeView {
    if (!_changeView) {
        _changeView = [[UIView alloc] init];
        _changeView.backgroundColor = HEX_RGB(0xCCCCCC);
        _changeView.layer.masksToBounds = YES;
        _changeView.layer.cornerRadius = 12;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTimeWay:)];
        [_changeView addGestureRecognizer:tap];
    }
    return _changeView;
}

- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.text = @"按月选择";
        _changeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _changeLabel.textColor = HEX_RGB(0x222222);
        _changeLabel.userInteractionEnabled = YES;
    }
    return _changeLabel;
}

- (UIImageView *)changeImgView {
    
    if (!_changeImgView) {
        _changeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xk_btn_coinDetail_changeWay"]];
    }
    return _changeImgView;
}


- (UIView *)monthChooseContentView {
    if (!_monthChooseContentView) {
        _monthChooseContentView = [[UIView alloc] init];
    }
    return _monthChooseContentView;
}

- (UILabel *)monthChooseDateLabel {
    if (!_monthChooseDateLabel) {
        _monthChooseDateLabel = [[UILabel alloc] init];
        _monthChooseDateLabel.textAlignment = NSTextAlignmentCenter;
        _monthChooseDateLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _monthChooseDateLabel.textColor = XKMainTypeColor;
        _monthChooseDateLabel.text = [XKTimeSeparateHelper backYMStringByStrigulaSegmentWithDate:[NSDate date]];
    }
    return _monthChooseDateLabel;
}

- (UIView *)monthChooseLineView {
    if (!_monthChooseLineView) {
        _monthChooseLineView = [[UIView alloc] init];
        _monthChooseLineView.backgroundColor = XKMainTypeColor;
    }
    return _monthChooseLineView;
}


- (UIView *)dayChooseContentView {
    if (!_dayChooseContentView) {
        _dayChooseContentView = [[UIView alloc] init];
        _dayChooseContentView.hidden = YES;
    }
    return _dayChooseContentView;
}

- (UIButton *)dayChooseDateLeftBtn {
    if (!_dayChooseDateLeftBtn) {
        _dayChooseDateLeftBtn = [[UIButton alloc] init];
        _dayChooseDateLeftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dayChooseDateLeftBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_dayChooseDateLeftBtn setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        [_dayChooseDateLeftBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        _dayChooseDateLeftBtn.selected = YES;
        [_dayChooseDateLeftBtn addTarget:self action:@selector(changeTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dayChooseDateLeftBtn;
}

- (UIView *)dayChooseLeftLineView {
    if (!_dayChooseLeftLineView) {
        _dayChooseLeftLineView = [[UIView alloc] init];
        _dayChooseLeftLineView.backgroundColor = XKMainTypeColor;
    }
    return _dayChooseLeftLineView;
}

- (UILabel *)dayChooseDateMiddleLabel {
    if (!_dayChooseDateMiddleLabel) {
        _dayChooseDateMiddleLabel = [[UILabel alloc] init];
        _dayChooseDateMiddleLabel.textAlignment = NSTextAlignmentCenter;
        _dayChooseDateMiddleLabel.text = @"至";
        _dayChooseDateMiddleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _dayChooseDateMiddleLabel.textColor = HEX_RGB(0x777777);
    }
    return _dayChooseDateMiddleLabel;
}

- (UIButton *)dayChooseDateRightBtn {
    if (!_dayChooseDateRightBtn) {
        _dayChooseDateRightBtn = [[UIButton alloc] init];
        _dayChooseDateRightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dayChooseDateRightBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_dayChooseDateRightBtn setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
        [_dayChooseDateRightBtn setTitleColor:XKMainTypeColor forState:UIControlStateSelected];
        _dayChooseDateRightBtn.selected = NO;
        [_dayChooseDateRightBtn addTarget:self action:@selector(changeTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _dayChooseDateRightBtn;
}

- (UIView *)dayChooseRightLineView {
    if (!_dayChooseRightLineView) {
        _dayChooseRightLineView = [[UIView alloc] init];
        _dayChooseRightLineView.backgroundColor = HEX_RGB(0x999999);
    }
    return _dayChooseRightLineView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"xk_btn_coinDeail_timeDelete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIPickerView *)datePickView {
    if (!_datePickView) {
        _datePickView = [[UIPickerView alloc] init];
        _datePickView.delegate = self;
        _datePickView.dataSource = self;
    }
    return _datePickView;
}


- (UIDatePicker *)datePick {
    if (!_datePick) {
        _datePick = [[UIDatePicker alloc] init];
        _datePick.datePickerMode = UIDatePickerModeDate;
        _datePick.maximumDate = [NSDate date];
        [_datePick addTarget:self action:@selector(datePickerChange:) forControlEvents:UIControlEventValueChanged];
        _datePick.hidden = YES;
    }
    return _datePick;
}

- (void)datePickerChange:(UIDatePicker *)paramPicker {
    if (self.dayChooseDateLeftBtn.selected) {
        [self.dayChooseDateLeftBtn setTitle:[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:paramPicker.date] forState:UIControlStateNormal];
    } else {
        [self.dayChooseDateRightBtn setTitle:[XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:paramPicker.date] forState:UIControlStateNormal];
    }
}
@end







