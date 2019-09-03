//
//  XKCityHeaderView.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityHeaderView.h"
#import "XKChooseCountyButton.h"

@interface XKCityHeaderView ()
@property (nonatomic, strong) UILabel              *currentCityLabel;
@property (nonatomic, strong) XKChooseCountyButton *button;
@property (nonatomic, strong) UIView               *contentView;
@end

@implementation XKCityHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSearchBar];
        [self addLabels];
        [self addXKChooseCountyButton];
    }
    return self;
}

- (void)setCityName:(NSString *)cityName {
    self.currentCityLabel.text = cityName;
}

- (void)setModel:(DataItem *)model {
    self.currentCityLabel.text = model.name;
}
- (void)setButtonTitle:(NSString *)buttonTitle {
    self.button.title = buttonTitle;
}

- (void)addSearchBar {
    UIView *bigContentView = [[UIView alloc]init];
    bigContentView.backgroundColor = HEX_RGB(0xF6F6F6 );
    [self addSubview:bigContentView];
    
    [bigContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = HEX_RGB(0xFFFFFF);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [bigContentView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.top.equalTo(@10);
        make.bottom.equalTo(@(-10));
    }];
}

- (void)addLabels {
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.text = @"当前:";
    currentLabel.textAlignment = NSTextAlignmentLeft;
    currentLabel.textColor = [UIColor blackColor];
    currentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:currentLabel];
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.offset(21);
        make.left.equalTo(@5);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.currentCityLabel = [[UILabel alloc] init];
    _currentCityLabel.textColor  = [UIColor blackColor];
    _currentCityLabel.textAlignment = NSTextAlignmentLeft;
    _currentCityLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_currentCityLabel];
    [_currentCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.height.offset(21);
        make.left.equalTo(currentLabel.mas_right).offset(0);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)addXKChooseCountyButton {
    self.button = [[XKChooseCountyButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 75 - 20, self.contentView.frame.size.height/2 + 10, 75, 21)];
    [_button addTarget:self action:@selector(touchUpButtonEnevt:) forControlEvents:UIControlEventTouchUpInside];
    _button.imageName = @"xk_ic_login_down_arrow";
    _button.title = @"选择区县";
    _button.titleColor = HEX_RGB(0x999999);
    [self.contentView addSubview:_button];
}

- (void)backAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonSelected)]) {
        [self.delegate backButtonSelected];
    }
}
- (void)contentButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonSelected)]) {
        [self.delegate searchButtonSelected];
    }
}
- (void)touchUpButtonEnevt:(XKChooseCountyButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.imageName = @"xk_ic_login_up_arrow";
    }else {
        sender.imageName = @"xk_ic_login_down_arrow";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityNameWithSelected:)]) {
        [self.delegate cityNameWithSelected:sender.selected];
    }
}
@end
