//
//  XKMyWinningRecordsHeader.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyWinningRecordsHeader.h"

@interface XKMyWinningRecordsHeader()

@property (nonatomic, strong) UIView *categoryView;

@property (nonatomic, strong) UIButton *categoryBtn;

@property (nonatomic, strong) UIImageView *btnImgView;

@property (nonatomic, strong) UIView *dateView;

@property (nonatomic, strong) UILabel *dateLab;

@property (nonatomic, strong) UIButton *dateBtn;

@end

@implementation XKMyWinningRecordsHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    
    self.categoryView = [[UIView alloc] init];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.categoryView];
    self.categoryView.xk_radius = 8;
    self.categoryView.xk_openClip = YES;
    self.categoryView.xk_clipType = XKCornerClipTypeTopBoth;
    
    self.categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.categoryBtn.titleLabel.font = XKRegularFont(14.0);
    [self.categoryBtn setTitle:@"分类" forState:UIControlStateNormal];
    [self.categoryBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
    [self.categoryView addSubview:self.categoryBtn];
    [self.categoryBtn addTarget:self action:@selector(categoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnImgView = [[UIImageView alloc] init];
    self.btnImgView.image = IMG_NAME(@"xk_bg_Mine_ConsumeCoupon_ButtonDown");
    [self.categoryView addSubview:self.btnImgView];
    
    self.dateView = [[UIView alloc] init];
    self.dateView.backgroundColor = HEX_RGBA(0xCFE1FC, 0.3);
    [self addSubview:self.dateView];
    
    self.dateLab = [[UILabel alloc] init];
    self.dateLab.text = @"本月";
    self.dateLab.font = XKRegularFont(14.0);
    self.dateLab.textColor = HEX_RGB(0x222222);
    [self.dateView addSubview:self.dateLab];
    
    self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dateBtn setImage:IMG_NAME(@"xk_bg_Mine_ConsumeCoupon_Calendar") forState:UIControlStateNormal];
    [self.dateView addSubview:self.dateBtn];
    [self.dateBtn addTarget:self action:@selector(dateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)updateViews {
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0);
        make.leading.mas_equalTo(10.0);
        make.trailing.mas_equalTo(-10.0);
        make.height.mas_equalTo(44.0);
    }];
    
    [self.categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.categoryView);
        make.leading.mas_equalTo(14.0);
    }];
    
    [self.btnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.categoryView);
        make.left.mas_equalTo(self.categoryBtn.mas_right).offset(4.0);
        make.width.height.mas_equalTo(5.0);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.categoryView);
        make.height.mas_equalTo(44.0);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.dateView);
        make.leading.mas_equalTo(14.0);
        make.right.mas_equalTo(self.dateBtn.mas_left);
    }];
    
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dateView);
        make.trailing.mas_equalTo(-14.0);
        make.width.height.mas_equalTo(20.0);
    }];
}

#pragma mark - privite method

- (void)categoryBtnAction:(UIButton *) sender {
    if (self.categoryBtnBlock) {
        self.categoryBtnBlock(sender);
    }
}

- (void)dateBtnAction:(UIButton *) sender {
    if (self.dateBtnBlock) {
        self.dateBtnBlock(sender);
    }
}

#pragma mark - setter

- (void)setCurrentCategoryStr:(NSString *)currentCategoryStr {
    _currentCategoryStr = currentCategoryStr;
    [self.categoryBtn setTitle:_currentCategoryStr forState:UIControlStateNormal];
    [self updateViews];
}

- (void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    if (self.endDate) {
        self.dateLab.text = [NSString stringWithFormat:@"%@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:_startDate], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:_endDate]];
    } else {
        self.dateLab.text = [XKTimeSeparateHelper backYMStringByStrigulaSegmentWithDate:_startDate];
    }
}

- (void)setEndDate:(NSDate *)endDate {
    _endDate = endDate;
    if (self.startDate) {
        self.dateLab.text = [NSString stringWithFormat:@"%@至%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:_startDate], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:_endDate]];
    } else {
        self.dateLab.text = [XKTimeSeparateHelper backYMStringByStrigulaSegmentWithDate:_endDate];
    }
}

@end
