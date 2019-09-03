//
//  XKChatGiveGiftViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKChatGiveGiftViewCell.h"

@interface XKChatGiveGiftViewCell ()

@end

@implementation XKChatGiveGiftViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)selectedStatus:(BOOL)selected {
    if (selected) {
        self.layer.cornerRadius = 4.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColorFromRGB(0xFCE76C).CGColor;
    } else {
        self.layer.cornerRadius = 0.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)initializeViews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(55 * SCREEN_WIDTH / 375, 55 * SCREEN_WIDTH / 375));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.iconImgView.mas_bottom);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.image = kDefaultHeadImg;
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = XKRegularFont(12);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"晓可星";
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = XKRegularFont(10);
        _priceLabel.textColor = HEX_RGB(0x999999);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.text = @"228晓可币";
    }
    return _priceLabel;
}
@end
