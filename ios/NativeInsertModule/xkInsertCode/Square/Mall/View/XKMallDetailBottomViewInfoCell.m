//
//  XKMallDetailBottomViewInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallDetailBottomViewInfoCell.h"

@interface XKMallDetailBottomViewInfoCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@end

@implementation XKMallDetailBottomViewInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.typeLabel];
    
}

- (void)addUIConstraint {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.priceLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(2);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.priceLabel);
        make.top.equalTo(self.countLabel.mas_bottom).offset(2);
    }];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 5.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = @"测试测试测试测试测试";
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14]];
        _priceLabel.textColor = UIColorFromRGB(0xee6161);
        _priceLabel.text = @"¥480";
    }
    return _priceLabel;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _countLabel.textColor = UIColorFromRGB(0x777777);
        _countLabel.text = @"库存：2397件";
    }
    return _countLabel;
}

- (UILabel *)typeLabel {
    if(!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        [_typeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _typeLabel.textColor = UIColorFromRGB(0x777777);
        _typeLabel.text = @"请选择规格";
    }
    return _typeLabel;
}

@end
