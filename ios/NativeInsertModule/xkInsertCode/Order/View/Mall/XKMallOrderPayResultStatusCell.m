//
//  XKMallOrderPayResultStatusCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderPayResultStatusCell.h"
@interface XKMallOrderPayResultStatusCell ()
@property (nonatomic, strong)UIImageView *statusImgView;
@property (nonatomic, strong)UILabel *statusLabel;

/**
 查看订单
 */
@property (nonatomic, strong)UIButton *orderBtn;

/**
 返回商城
 */
@property (nonatomic, strong)UIButton *backMallBtn;

/**
 返回广场
 */
@property (nonatomic, strong)UIButton *backGroundBtn;
@end

@implementation XKMallOrderPayResultStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.statusImgView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.orderBtn];
    [self.contentView addSubview:self.backMallBtn];
    [self.contentView addSubview:self.backGroundBtn];
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    if (status == 1) {
        self.statusImgView.image = [UIImage imageNamed:@"xk_ic_order_pay_finish"];
        [_backGroundBtn setTitle:@"返回广场" forState:0];
        [_backGroundBtn addTarget:self action:@selector(backGroundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_backGroundBtn setTitle:@"重新支付" forState:0];
        [_backGroundBtn addTarget:self action:@selector(payAgainst:) forControlEvents:UIControlEventTouchUpInside];
        self.statusImgView.image = [UIImage imageNamed:@"xk_ic_order_pay_faile"];
    }
}
- (void)addUIConstraint {
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(66, 66));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.statusImgView.mas_bottom).offset(15);
    }];
    
    CGFloat btnW = (SCREEN_WIDTH - 50 - 30 - 20)/3;
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(btnW, 30));
    }];
    
    [self.backGroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(btnW, 30));
    }];
    
    [self.backMallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderBtn.mas_right).offset(15);
        make.right.equalTo(self.backGroundBtn.mas_left).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark event
- (void)orderBtnClick:(UIButton *)sender {
    if (self.orderClickBlock) {
        self.orderClickBlock(sender);
    }
}

- (void)backMallBtnClick:(UIButton *)sender {
    if (self.mallClickBlock) {
        self.mallClickBlock(sender);
    }
}

- (void)backGroundBtnClick:(UIButton *)sender {
    if (self.groundClickBlock) {
        self.groundClickBlock(sender);
    }
}

- (void)pagAgainst:(UIButton *)sender {
    if (self.payAgainstBlock) {
        self.payAgainstBlock(sender);
    }
}
#pragma lazy
- (UIImageView *)statusImgView {
    if(!_statusImgView) {
        _statusImgView = [[UIImageView alloc] init];
        _statusImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusImgView;
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = XKFont(XK_PingFangSC_Medium, 17);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.text = @"支付成功";
        _statusLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _statusLabel;
}

- (UIButton *)orderBtn {
    if(!_orderBtn) {
        _orderBtn = [[UIButton alloc] init];
        _orderBtn.layer.borderWidth = 1.f;
        _orderBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _orderBtn.layer.cornerRadius = 4.f;
        _orderBtn.layer.masksToBounds = YES;
        [_orderBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        [_orderBtn setTitle:@"查看订单" forState:0];
        [_orderBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _orderBtn;
}

- (UIButton *)backMallBtn {
    if(!_backMallBtn) {
        _backMallBtn = [[UIButton alloc] init];
        _backMallBtn.layer.borderWidth = 1.f;
        _backMallBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _backMallBtn.layer.cornerRadius = 4.f;
        _backMallBtn.layer.masksToBounds = YES;
        [_backMallBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
        [_backMallBtn setTitle:@"返回商城" forState:0];
        [_backMallBtn addTarget:self action:@selector(backMallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _backMallBtn;
}

- (UIButton *)backGroundBtn {
    if(!_backGroundBtn) {
        _backGroundBtn = [[UIButton alloc] init];
        _backGroundBtn.layer.borderWidth = 1.f;
        _backGroundBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _backGroundBtn.layer.cornerRadius = 4.f;
        _backGroundBtn.layer.masksToBounds = YES;
        [_backGroundBtn setTitleColor:XKMainTypeColor forState:0];

    }
    return  _backGroundBtn;
}
@end
