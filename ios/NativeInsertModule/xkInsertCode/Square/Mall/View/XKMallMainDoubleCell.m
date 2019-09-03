//
//  XKMallMainDoubleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallMainDoubleCell.h"
#import "UIView+XKCornerBorder.h"
@interface XKMallMainDoubleCell ()

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel  *typeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sellLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation XKMallMainDoubleCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
        self.contentView.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
        self.contentView.layer.borderWidth = 1.f;
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.masksToBounds = YES;

    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.sellLabel];
}

- (void)bindData:(MallGoodsListItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;
    self.typeLabel.text = [NSString stringWithFormat:@"产品规格：%@",item.skuName];
    self.sellLabel.text = [NSString stringWithFormat:@"月销量：%zd",item.saleQ];
    NSString *price = @(item.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格：%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xEE6161)
                       range:NSMakeRange(3, priceStr.length - 3)];
    self.priceLabel.attributedText = attrString;
}

- (void)addUIConstraint {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(155);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.top.equalTo(self.iconImgView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(2);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.sellLabel.mas_bottom).offset(2);
    }];
    

}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.image = kDefaultPlaceHolderImg;
        _iconImgView.clipsToBounds = YES;

    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XKRegularFont(14);
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
        _nameLabel.text = @"柏品 泰尼亚羊毛桑蚕丝混 纺面料西装 男士商务西服";
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if(!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = XKRegularFont(12);
        _typeLabel.textColor = UIColorFromRGB(0x777777);
        _typeLabel.text = @"产品规格：500ml+120ml";
    }
    return _typeLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = XKRegularFont(12);
        _priceLabel.textColor = UIColorFromRGB(0xee6161);
        _priceLabel.text = @"¥150";
    }
    return _priceLabel;
}

- (UILabel *)sellLabel {
    if(!_sellLabel) {
        _sellLabel = [[UILabel alloc] init];
        _sellLabel.font = XKRegularFont(12);
        _sellLabel.textColor = UIColorFromRGB(0x777777);
        _sellLabel.text = @"月销量：1589";
    }
    return _sellLabel;
}
@end