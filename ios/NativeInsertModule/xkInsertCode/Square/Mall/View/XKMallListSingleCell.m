//
//  XKMallListSingleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallListSingleCell.h"

@interface XKMallListSingleCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *sellLabel;
@property (nonatomic, strong)UIView *lineView;
@end

@implementation XKMallListSingleCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6;
        
    }
    return self;
}

- (void)addCustomSuviews {
    [self.contentView addSubview:self.bgContainView];
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.priceLabel];
    [self.bgContainView addSubview:self.sellLabel];
    [self.bgContainView addSubview:self.lineView];
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(10);
        make.top.equalTo(self.bgContainView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.bgContainView.mas_right).offset(-20);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.bgContainView.mas_bottom).offset(-10);
    }];
    
    [self.sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.right.equalTo(self.nameLabel.mas_right);
        make.left.equalTo(self.priceLabel.mas_right).offset(15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgContainView);
        make.height.mas_equalTo(1);
    }];
}

- (void)bindData:(MallGoodsListItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;
    self.
    self.sellLabel.text = [NSString stringWithFormat:@"月销量:%zd",item.saleQ];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%zd",item.price / 100];
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]];
        _priceLabel.textColor = UIColorFromRGB(0xee6161);
    }
    return _priceLabel;
}

- (UILabel *)sellLabel {
    if(!_sellLabel) {
        _sellLabel = [[UILabel alloc] init];
        [_sellLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _sellLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _sellLabel;
}

- (UIView *)lineView {
    if(!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}
@end
