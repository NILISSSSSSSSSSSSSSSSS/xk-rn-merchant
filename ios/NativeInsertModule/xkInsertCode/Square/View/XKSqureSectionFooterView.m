//
//  XKSqureSectionFooterView.m
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureSectionFooterView.h"


@interface XKSqureSectionFooterView ()

@property (nonatomic, strong) UIButton   *footerButton;
@property (nonatomic, strong) UIView     *lineView;

@end

@implementation XKSqureSectionFooterView


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
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.footerButton];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backView);
        make.height.equalTo(@1);
    }];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView).insets(UIEdgeInsetsMake(1, 0, 0, 0));
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (UIButton *)footerButton {
    
    if (!_footerButton) {
        _footerButton = [[UIButton alloc] init];
        [_footerButton setBackgroundColor:[UIColor whiteColor]];
        [_footerButton addTarget:self action:@selector(footerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}

- (void)setFooterViewWithTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font {
    if (title) {
        [self.footerButton setTitleColor:color forState:UIControlStateNormal];
        [self.footerButton setTitle:title forState:UIControlStateNormal];
        self.footerButton.titleLabel.font = font;
    } else {
        [self.footerButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)setFooterViewImg:(UIImage *)img {
    [self.footerButton setImage:img forState:UIControlStateNormal];
}


- (void)setFooterButtonTag:(NSInteger)tag {
    self.footerButton.tag = tag;
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

#pragma mark - Events

- (void)footerButtonClicked:(UIButton *)sender {
    if (self.footerViewBlock) {
        self.footerViewBlock(sender);
    }
}


@end






