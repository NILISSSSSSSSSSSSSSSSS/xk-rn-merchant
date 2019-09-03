//
//  XKWelfaceOrderSureAddressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfaceOrderSureAddressCell.h"

@interface XKWelfaceOrderSureAddressCell ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UIImageView *arrImgView;
@end

@implementation XKWelfaceOrderSureAddressCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6.f;
        self.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.phoneLabel];
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.addressLabel];
    [self.bgContainView addSubview:self.arrImgView];
}

- (void)updateInfoWithAddressName:(NSString *)addressName  phone:(NSString *)phone userName:(NSString *)userName {
    self.nameLabel.text = userName;
    self.phoneLabel.text = phone;
    self.addressLabel.text = addressName;
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.top.equalTo(self.bgContainView.mas_top).offset(10);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-50);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.bgContainView.mas_right).offset(-50);
    }];
    
    [self.arrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.centerY.equalTo(self.bgContainView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
      _iconImgView.image = [UIImage imageNamed:@"xk_btn_welfare_location"];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]];
        _nameLabel.textColor = UIColorFromRGB(0x555555);
        _nameLabel.text = @"收货人：小蘑菇";
    }
    return _nameLabel;
}

- (UILabel *)phoneLabel {
    if(!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        [_phoneLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]];
        _phoneLabel.textColor = UIColorFromRGB(0x555555);
        _phoneLabel.text = @"1823434124";
        _phoneLabel.textAlignment = NSTextAlignmentRight;
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]];
        _addressLabel.textColor = UIColorFromRGB(0x555555);
        _addressLabel.numberOfLines = 2;
        _addressLabel.text = @"地址：四川省成都市高新区环球中心B座四川省成都市高新区环球中心B座";
    }
    return _addressLabel;
}

- (UIImageView *)arrImgView {
    if(!_arrImgView) {
        _arrImgView = [[UIImageView alloc] init];
        _arrImgView.image = [UIImage imageNamed:@"xk_btn_order_grayArrow"];
        _arrImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrImgView;
}
@end
