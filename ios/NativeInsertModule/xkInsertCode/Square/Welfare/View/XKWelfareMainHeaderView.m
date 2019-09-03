//
//  XKWelfareMainHeaderView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareMainHeaderView.h"
@interface XKWelfareMainHeaderView ()
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIView    *leftView;
@property (nonatomic, strong) UIView    *rightView;
@property (nonatomic, strong) UIButton  *layoutBtn;

@end

@implementation XKWelfareMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addCustomSubviews];
        [self addUIConstain];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.layoutBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
}

- (void)addUIConstain {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(10);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(10,1));
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(10,1));
    }];
    
    [self.layoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)layoutBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
//    if (sender.selected) {
//           [_layoutBtn setImage:[UIImage imageNamed:@"xk_btn_mall_layout"] forState:0];
//    } else {
//           [_layoutBtn setImage:[UIImage imageNamed:@"xk_btn_mall_layout"] forState:0];
//    }
    if (self.layoutBlock) {
        self.layoutBlock(sender);
    }
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [UIView new];
        _leftView.backgroundColor = XKMainTypeColor;
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = XKMainTypeColor;
    }
    return _rightView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 20)];
        _titleLabel.font  =XKRegularFont(17);
        _titleLabel.textColor  = UIColorFromRGB(0x222222);
        _titleLabel.text = @"商品推荐";
    }
    return _titleLabel;
}

- (UIButton *)layoutBtn {
    if (!_layoutBtn) {
        _layoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45 - 20, 5, 30, 30)];
     
        [_layoutBtn setTitleColor:UIColorFromRGB(0x777777) forState:0];
        [_layoutBtn addTarget:self action:@selector(layoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _layoutBtn;
}


@end
