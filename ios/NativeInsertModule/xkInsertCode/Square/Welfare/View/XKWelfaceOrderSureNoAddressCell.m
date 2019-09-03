//
//  XKWelfaceOrderSureNoAddressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfaceOrderSureNoAddressCell.h"
@interface XKWelfaceOrderSureNoAddressCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UIImageView *arrImgView;
@end
@implementation XKWelfaceOrderSureNoAddressCell

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
    
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.tipLabel];
    [self.bgContainView addSubview:self.arrImgView];
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.top.equalTo(self.bgContainView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(5);
        make.top.equalTo(self.iconImgView.mas_top).offset(-3);
        make.right.equalTo(self.bgContainView.mas_right).offset(-70);
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
        _iconImgView.image = [UIImage imageNamed:@"xk_btn_welfare_location"];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}

- (UIImageView *)arrImgView {
    if(!_arrImgView) {
        _arrImgView = [[UIImageView alloc] init];
        _arrImgView.image = [UIImage imageNamed:@"xk_btn_order_grayArrow"];
        _arrImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrImgView;
}

- (UILabel *)tipLabel {
    if(!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _tipLabel.textColor = UIColorFromRGB(0x555555);
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = @"您还没有添加收货地址，请点击右侧按钮，添加一个收货地址";
    }
    return _tipLabel;
}
@end
