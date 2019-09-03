//
//  XKWelfareOrderWaitOpendDetailAddressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderWaitOpendDetailAddressCell.h"
@interface XKWelfareOrderWaitOpendDetailAddressCell ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@end

@implementation XKWelfareOrderWaitOpendDetailAddressCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.addressLabel];
}

- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model {
    self.nameLabel.text = [NSString stringWithFormat:@"收货人: %@",model.userName];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话: %@",model.userPhone];
    self.addressLabel.text = [NSString stringWithFormat:@"地址: %@",model.userAddress];
    NSString *address = [NSString stringWithFormat:@"地址：%@",model.userAddress];
    CGFloat addressH = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.height;
    [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40 + addressH)];
}

- (void)addUIConstraint {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(12);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(65);
        make.top.equalTo(self.nameLabel.mas_top);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]];
        _nameLabel.textColor = UIColorFromRGB(0x555555);
 
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
