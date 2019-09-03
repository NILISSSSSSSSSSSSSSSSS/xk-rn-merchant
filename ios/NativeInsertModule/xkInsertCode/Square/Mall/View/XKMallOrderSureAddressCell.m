//
//  XKMallOrderSureAddressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderSureAddressCell.h"

@interface XKMallOrderSureAddressCell ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *addressLabel;
@end

@implementation XKMallOrderSureAddressCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        self.xk_openClip = YES;
        self.xk_radius = 6.f;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.addressLabel];
}

- (void)updateInfoWithAddressName:(NSString *)addressName  phone:(NSString *)phone userName:(NSString *)userName {
    self.nameLabel.text = userName;
    self.phoneLabel.text = phone;
    self.addressLabel.text = addressName;
}

- (void)addUIConstraint {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
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
@end
