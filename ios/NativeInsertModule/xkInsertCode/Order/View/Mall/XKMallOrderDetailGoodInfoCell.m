//
//  XKMallOrderDetailGoodInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailGoodInfoCell.h"
#import "UIView+XKCornerRadius.h"
@interface XKMallOrderDetailGoodInfoCell ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation XKMallOrderDetailGoodInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 6;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailGoodsItem *)model {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = model.goodsName;
    self.typeLabel.text = [NSString stringWithFormat:@"规格参数：%@ x %zd",model.goodsAttr,model.goodsNum];
    NSString *price = @(model.goodsPrice / 100).stringValue;
    
    NSString *priceStr = [NSString stringWithFormat:@"价格： ¥%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(4, priceStr.length - 4)];
    [attrString addAttribute:NSFontAttributeName
                       value:XKRegularFont(12)
                       range:NSMakeRange(4, priceStr.length - 4)];
    self.priceLabel.attributedText = attrString;
    
    if ([model.itemStatus isEqualToString:@"DURING_APPLY"]) {
        self.statusLabel.text = @"申请退款中";
    } else  if ([model.itemStatus isEqualToString:@"REFUNDED"]) {
        self.statusLabel.text = @"已退款";
    } else  if ([model.itemStatus isEqualToString:@"REFUSED"]) {
        self.statusLabel.text = @"拒绝退款";
    }
}

- (void)bindItem:(XKMallBuyCarItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.goodsName;
    self.typeLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.typeLabel.text = [NSString stringWithFormat:@"规格：%@ x %zd",item.goodsAttr, item.quantity];
    NSString *price = @(item.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格：%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(3, priceStr.length - 3)];
    self.priceLabel.attributedText = attrString;
}

- (void)addUIConstraint {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.width.mas_equalTo(70);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.priceLabel.mas_top);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.lineView.mas_top).offset(-15);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_right);
        make.bottom.equalTo(self.priceLabel.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark lazy
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
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if(!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        [_typeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _typeLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _typeLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _priceLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _priceLabel;
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _statusLabel.textColor = XKMainTypeColor;
    }
    return _statusLabel;
}

- (UIView *)lineView {
    if(!_lineView) {
        _lineView  = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

@end
