//
//  XKGamesWalletCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGamesWalletCollectionViewCell.h"


@interface XKGamesWalletCollectionViewCell ()


@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIButton    *yuEButton;
@property (nonatomic, strong) UIView      *lineView;


@end


@implementation XKGamesWalletCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.yuEButton];
    [self.contentView addSubview:self.lineView];
}


- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(@15);
        make.height.width.equalTo(@12);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.imgView);
    }];
    
    [self.yuEButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.imgView.mas_bottom).offset(3);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}



- (void)yuEButtonClicked:(UIButton *)sender {
    
    if (!sender.selected) {
        if (self.bindCoinBlock) {
            self.bindCoinBlock(sender);
        }
    }
}


#pragma mark - Setters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"晓可币";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    }
    
    return _nameLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor greenColor];
        
    }
    return _imgView;
}

- (UIButton *)yuEButton {
    
    if (!_yuEButton) {
        _yuEButton = [[UIButton alloc] init];
        _yuEButton.selected = NO;
        _yuEButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_yuEButton setTitleColor:HEX_RGB(0x555555) forState:UIControlStateSelected];
        [_yuEButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"余额：266"];
        [str addAttributes:@{NSForegroundColorAttributeName:HEX_RGB(0xEE6161)} range:NSMakeRange(3, str.length-3)];
        [_yuEButton setAttributedTitle:str forState:UIControlStateSelected];
        [_yuEButton setTitle:@"未绑定" forState:UIControlStateNormal];
    
        [_yuEButton addTarget:self action:@selector(yuEButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yuEButton;
    
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}


@end
