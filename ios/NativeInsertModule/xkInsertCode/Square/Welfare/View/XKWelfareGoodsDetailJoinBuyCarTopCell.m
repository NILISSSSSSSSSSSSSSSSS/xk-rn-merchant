//
//  XKWelfareGoodsDetailJoinBuyCarTopCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailJoinBuyCarTopCell.h"
@interface XKWelfareGoodsDetailJoinBuyCarTopCell ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *orderNumberLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UIView *bottomLineView;
@end

@implementation XKWelfareGoodsDetailJoinBuyCarTopCell

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
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.orderNumberLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.bottomLineView];
}

- (void)addUIConstraint {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView);
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.nameLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom);
        make.left.right.equalTo(self.nameLabel);
    }];
    
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.timeLabel.mas_bottom);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderNumberLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 5.f;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.f];
        _nameLabel.numberOfLines = 2;
        _nameLabel.text = @"柏品 泰尼亚羊毛桑蚕丝混纺面料西装 男士商务西服套装 纯色套西";
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = UIColorFromRGB(0x777777);
        _priceLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.f];
        NSString *price = @"1067";
        NSString *priceStr = [NSString stringWithFormat:@"积分：%@",price];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(3, priceStr.length - 3)];
        _priceLabel.attributedText = attrString;
    }
    return _priceLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0x777777);
        _timeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.f];
        _timeLabel.text = @"时间：2018-7-20";
    }
    return _timeLabel;
}

- (UILabel *)orderNumberLabel {
    if (!_orderNumberLabel) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.textColor = UIColorFromRGB(0x777777);
        _orderNumberLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.f];
        _orderNumberLabel.text = @"订单号： 123456789";
    }
    return _orderNumberLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = UIColorFromRGB(0xEE6161);
        _statusLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.f];
        _statusLabel.text = @"待接单";
    }
    return _statusLabel;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomLineView;
}

@end
