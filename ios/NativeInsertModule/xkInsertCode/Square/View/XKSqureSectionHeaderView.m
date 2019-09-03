//
//  XKSqureSectionHeaderView.m
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureSectionHeaderView.h"


@interface XKSqureSectionHeaderView ()

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation XKSqureSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {

    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}

#pragma mark - Private


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView setNeedsLayout];
    [self.backView layoutIfNeeded];
}

- (void)initViews {
    
//    [self.backView cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    [self addSubview:self.backView];
    [self.backView addSubview:self.leftLineView];
    [self.backView addSubview:self.rightLineView];
    [self.backView addSubview:self.nameLabel];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(13);
        make.bottom.equalTo(self.backView).offset(-8);
        make.centerX.equalTo(self.backView);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel.mas_left).offset(-5);
        make.width.equalTo(@15);
        make.height.equalTo(@2);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.width.height.equalTo(self.leftLineView);
    }];
    
}

#pragma mark - Setter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = HEX_RGB(0x4A90FA);
        _leftLineView.layer.masksToBounds = YES;
        _leftLineView.layer.cornerRadius = 1;
    }
    return _leftLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = HEX_RGB(0x4A90FA);
        _rightLineView.layer.masksToBounds = YES;
        _rightLineView.layer.cornerRadius = 1;
    }
    return _rightLineView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}


- (void)setTitleName:(NSString *)name {
    
    self.nameLabel.text = name;
    
}


@end






