//
//  XKSubscriptionHeaderView.m
//  XKSquare
//
//  Created by hupan on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSubscriptionHeaderView.h"

@interface XKSubscriptionHeaderView ()

@property (nonatomic, strong) UIView  *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *delButton;

@end

@implementation XKSubscriptionHeaderView


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
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.delButton];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView).insets(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)setIsShowDelButton:(BOOL)isShowDelButton {
    _isShowDelButton = isShowDelButton;
    if (_isShowDelButton) {
        _delButton.hidden = NO;
    }else{
        _delButton.hidden = YES;
    }
}
#pragma mark - Setter

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UIButton *)delButton {
    if (!_delButton) {
        _delButton = [[UIButton alloc]init];
        [_delButton setImage:[UIImage imageNamed:@"xk_btn_coinDeail_timeDelete"] forState:0];
        [_delButton addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}

- (void)delAction:(UIButton *)sender {
    if (self.delBlock) {
        self.delBlock(sender);
    }
}

- (void)cutCorner:(BOOL)cut {
    if (cut) {
        [self.backView cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    } else {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (void)setTitleName:(NSString *)name {
    
    self.nameLabel.text = name;
}

- (void)setTitleColor:(UIColor *)color font:(UIFont *)font {
    
    self.nameLabel.textColor = color;
    self.nameLabel.font = font;
}


@end

