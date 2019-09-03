//
//  XKTranscationDetailHeaderView.m
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTranscationDetailHeaderView.h"

@interface XKTranscationDetailHeaderView ()

@property (nonatomic, strong) UIView   *backView;
@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, strong) UILabel  *decLabel;
@property (nonatomic, strong) UIButton *chooseTimeBtn;
@property (nonatomic, strong) UIView   *lineView;


@end

@implementation XKTranscationDetailHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}


#pragma mark - Private


- (void)initViews {
    [self.backView cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 62) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    [self addSubview:self.backView];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.decLabel];
    [self.backView addSubview:self.chooseTimeBtn];
    [self.backView addSubview:self.lineView];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(12);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(3);
        make.left.equalTo(self.timeLabel.mas_left);
    }];
    
    [self.chooseTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel).offset(5);
        make.right.equalTo(self.backView).offset(-10);
        make.width.height.equalTo(@25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.backView);
        make.height.equalTo(@1);
    }];
}


- (void)chooseTimeBtnClicked:(UIButton *)sender {
    
    if (self.chooseTimeBlock) {
        self.chooseTimeBlock(sender, self.timeLabel.text);
    }
}

- (void)setTitleName:(NSString *)name {
    
    self.timeLabel.text = name;
}

#pragma mark - Setter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEX_RGB(0x555555);
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = @"本月";
    }
    return _timeLabel;
}

- (UILabel *)decLabel {
    
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.textColor = HEX_RGB(0x777777);
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        _decLabel.textAlignment = NSTextAlignmentLeft;
        _decLabel.text = @"支出:￥2221   收入:￥6786";
    }
    return _decLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (UIButton *)chooseTimeBtn {
    
    if (!_chooseTimeBtn) {
        _chooseTimeBtn = [[UIButton alloc] init];
        [_chooseTimeBtn setImage:[UIImage imageNamed:@"xk_btn_coinDetail_chooseTime"] forState:UIControlStateNormal];
        [_chooseTimeBtn addTarget:self action:@selector(chooseTimeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseTimeBtn;
}




@end

