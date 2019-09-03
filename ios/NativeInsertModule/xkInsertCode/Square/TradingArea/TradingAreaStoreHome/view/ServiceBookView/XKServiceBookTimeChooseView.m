//
//  XKServiceBookTimeChooseView.m
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKServiceBookTimeChooseView.h"
#import "XKTimeSeparateHelper.h"

@interface XKServiceBookTimeChooseView ()

@property (nonatomic, strong) UIView       *toolView;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UIButton     *sureBtn;

@property (nonatomic, strong) UIDatePicker *datePick;
@property (nonatomic, strong) UIView       *lineView;
@property (nonatomic, strong) UIButton     *cancelBtn;


@end


@implementation XKServiceBookTimeChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}



- (void)addCustomSubviews {
    
    [self addSubview:self.toolView];
//    [self.toolView addSubview:self.titleLabel];
    [self.toolView addSubview:self.sureBtn];
    [self addSubview:self.datePick];
    [self addSubview:self.lineView];
    [self addSubview:self.cancelBtn];
}

- (void)addUIConstraint {
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@46);
    }];
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(self.toolView);
//    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.toolView);
        make.width.equalTo(@80);
    }];
    
    
    [self.datePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView.mas_bottom).offset(10);
        make.left.right.equalTo(self);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.datePick.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.equalTo(@5);
    }];

    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.right.left.bottom.equalTo(self);
        make.height.equalTo(@50);
    }];

}


- (void)cancelBtnClicked:(UIButton *)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}


- (void)sureBtnClicked:(UIButton *)sender {
    NSDate *date = self.datePick.date;
    if (self.sureBlock) {
        self.sureBlock([XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithDate:date]);
    }
    
    if (self.timeBlock) {
        self.timeBlock([XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:date]);
    }
}

- (void)setCustomDatePickModel:(UIDatePickerMode)datePickerMode minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    
    if (datePickerMode) {
        self.datePick.datePickerMode = datePickerMode;
    }
    if (minDate) {
        self.datePick.minimumDate = minDate;
    }
    if (maxDate) {
        self.datePick.maximumDate = maxDate;
    }
}

#pragma mark - getter && setter


- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
    }
    return _toolView;
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


- (UIDatePicker *)datePick {
    if (!_datePick) {
        _datePick = [[UIDatePicker alloc] init];
        _datePick.datePickerMode = UIDatePickerModeDateAndTime;
        _datePick.minimumDate = [NSDate date];
    }
    return _datePick;
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
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _cancelBtn;
}

@end







