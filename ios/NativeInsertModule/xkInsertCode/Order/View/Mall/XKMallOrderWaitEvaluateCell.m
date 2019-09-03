//
//  XKMainOrderWaitEvaluateCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderWaitEvaluateCell.h"

@interface XKMallOrderWaitEvaluateCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UIButton *payBtn;
@end

@implementation XKMallOrderWaitEvaluateCell

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
    [self.contentView addSubview:self.payBtn];
    
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
        make.right.equalTo(self.contentView.mas_right).offset(9);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.right.equalTo(self.contentView.mas_right).offset(9);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 22));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
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
        _timeLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _timeLabel;
}

- (UIButton *)payBtn {
    if(!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        [_payBtn setTitle:@"去评价" forState:0];
        _payBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:0];
        _payBtn.layer.cornerRadius = 3.f;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn setBackgroundColor:XKMainTypeColor];
    }
    return _payBtn;
}

@end
