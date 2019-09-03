//
//  XKMallListDoubleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallListDoubleCell.h"
@interface XKMallListDoubleCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *sellLabel;
@end

@implementation XKMallListDoubleCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSuviews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.sellLabel];
}

- (void)bindData:(MallGoodsListItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;
    self.sellLabel.text = [NSString stringWithFormat:@"月销量:%zd",item.saleQ];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%zd",item.price / 100];
}

- (void)addUIConstraint {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(173);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.top.equalTo(self.iconImgView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel);
        make.right.equalTo(self.nameLabel.mas_right);
    }];
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
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
        _nameLabel.text = @"柏品 泰尼亚羊毛桑蚕丝混 纺面料西装 男士商务西服";
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17]];
        _priceLabel.textColor = UIColorFromRGB(0xee6161);
        _priceLabel.text = @"¥150";
    }
    return _priceLabel;
}

- (UILabel *)sellLabel {
    if(!_sellLabel) {
        _sellLabel = [[UILabel alloc] init];
        [_sellLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _sellLabel.textColor = UIColorFromRGB(0x999999);
        _sellLabel.text = @"月销量：1589";
    }
    return _sellLabel;
}
@end
