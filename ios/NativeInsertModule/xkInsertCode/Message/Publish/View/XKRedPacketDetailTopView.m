//
//  XKRedPacketDetailTopView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedPacketDetailTopView.h"
@interface XKRedPacketDetailTopView ()

@property (nonatomic, strong) UIImageView  *bgImgView;
@property (nonatomic, strong) UIImageView  *headerImgView;
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *priceLabel;
@property (nonatomic, strong) UIButton     *detailBtn;
@property (nonatomic, strong) UILabel      *drawInfoLabel;
@end

@implementation XKRedPacketDetailTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.bgImgView];
    [self addSubview:self.headerImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.detailBtn];
    [self addSubview:self.drawInfoLabel];
}

- (void)addUIConstraint {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(135);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(95);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.headerImgView.mas_bottom).offset(10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.size.mas_equalTo(CGSizeMake(60, 15));
    }];
    
    [self.drawInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailBtn.mas_right);
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.detailBtn);
    }];
}

- (void)detailBtnClick:(UIButton *)sender {
    if (self.detailBlock) {
        self.detailBlock(sender);
    }
}
#pragma mark lazy
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.image = [UIImage imageNamed:@"xk_bg_IM_function_redPacketTop"];
    }
    return _bgImgView;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImgView.image = kDefaultHeadImg;
        _headerImgView.layer.cornerRadius = 40.f;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = XKRegularFont(14);
        _nameLabel.textColor = UIColorFromRGB(0x555555);
        _nameLabel.text = @"林小姐Msdus抢到红包";
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = UIColorFromRGB(0x222222);
        NSString *price = @(20.11).stringValue;
        NSString *priceStr = [NSString stringWithFormat:@"%@ 币",price];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
        
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(60)
                           range:NSMakeRange(0, priceStr.length - 1)];
        
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(14)
                           range:NSMakeRange(priceStr.length - 1, 1)];
        _priceLabel.attributedText = attrString;
    }
    return _priceLabel;
}

- (UIButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc] init];
        _detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_detailBtn setTitle:@"领取详情" forState:0];
        _detailBtn.titleLabel.font = XKRegularFont(12);
        [_detailBtn setTitleColor:XKMainTypeColor forState:0];
        [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBtn;
}

- (UILabel *)drawInfoLabel {
    if (!_drawInfoLabel) {
        _drawInfoLabel = [[UILabel alloc] init];
        _drawInfoLabel.font = XKRegularFont(12);
        _drawInfoLabel.textColor = UIColorFromRGB(0x999999);
        _drawInfoLabel.text = @"已领取4/20个，共28晓可币";
    }
    return _drawInfoLabel;
}
@end
