//
//  XKMainOrderAfterSaleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderAfterSaleCell.h"
@interface XKMallOrderAfterSaleCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UIButton *exitTipBtn;
@property (nonatomic, strong)UIButton *exitProgressBtn;
@property (nonatomic, strong)UIButton *buyAgainBtn;
@end

@implementation XKMallOrderAfterSaleCell

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
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.exitTipBtn];
    [self.contentView addSubview:self.exitProgressBtn];
    [self.contentView addSubview:self.buyAgainBtn];
}

- (void)addUIConstraint {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.contentView.mas_right).offset(-75);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
    }];
    
    [self.exitTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.buyAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.exitProgressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.bottom.equalTo(self.buyAgainBtn);
        make.right.equalTo(self.buyAgainBtn.mas_left).offset(-10);
    }];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 3.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12]];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _timeLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _timeLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _priceLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _priceLabel;
}

- (UIButton *)exitProgressBtn {
    if(!_exitProgressBtn) {
        _exitProgressBtn = [[UIButton alloc] init];
        [_exitProgressBtn setTitle:@"退款进度" forState:0];
        _exitProgressBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        [_exitProgressBtn setTitleColor:[UIColor whiteColor] forState:0];
        _exitProgressBtn.layer.cornerRadius = 3.f;
        _exitProgressBtn.layer.masksToBounds = YES;
        [_exitProgressBtn setBackgroundColor:XKMainTypeColor];
    }
    return _exitProgressBtn;
}

- (UIButton *)buyAgainBtn {
    if(!_buyAgainBtn) {
        _buyAgainBtn = [[UIButton alloc] init];
        [_buyAgainBtn setTitle:@"再来一单" forState:0];
        _buyAgainBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        [_buyAgainBtn setTitleColor:[UIColor whiteColor] forState:0];
        _buyAgainBtn.layer.cornerRadius = 3.f;
        _buyAgainBtn.layer.masksToBounds = YES;
        [_buyAgainBtn setBackgroundColor:XKMainTypeColor];
    }
    return _buyAgainBtn;
}

- (UIButton *)exitTipBtn {
    if(!_exitTipBtn) {
        _exitTipBtn = [[UIButton alloc] init];
        [_exitTipBtn setTitle:@"已退款" forState:0];
        _exitTipBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10];
        [_exitTipBtn setTitleColor:[UIColor whiteColor] forState:0];
        _exitTipBtn.layer.cornerRadius = 3.f;
        _exitTipBtn.layer.masksToBounds = YES;
        _exitTipBtn.layer.borderWidth = 1.f;
        _exitTipBtn.layer.borderColor = XKMainTypeColor.CGColor;
        [_exitTipBtn setBackgroundColor:XKMainTypeColor];
    }
    return _exitTipBtn;
}



@end
