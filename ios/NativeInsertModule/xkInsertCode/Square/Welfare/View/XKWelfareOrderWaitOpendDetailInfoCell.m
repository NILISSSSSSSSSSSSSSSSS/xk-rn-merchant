//
//  XKWelfareOrderWaitOpendDetailInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderWaitOpendDetailInfoCell.h"
@interface XKWelfareOrderWaitOpendDetailInfoCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *infoLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UIView *segmengView;
@end

@implementation XKWelfareOrderWaitOpendDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {

    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.segmengView];
}

- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.mainUrl] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = model.goodsName;
    self.infoLabel.text = [NSString stringWithFormat:@"规格参数:%@ x %zd",model.showSkuName ?:@"",model.myStake];

    NSString *priceStr = [NSString stringWithFormat:@"代金券:%@",model.price];
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttrString addAttribute:NSForegroundColorAttributeName
                           value:XKMainRedColor
                           range:NSMakeRange(4, priceStr.length - 4)];
    _priceLabel.attributedText = priceAttrString;
}

- (void)addUIConstraint {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-2);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.bottom.equalTo(self.iconImgView.mas_bottom);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark 懒加载

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 5.f;
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
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;

    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if(!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _infoLabel.textColor = UIColorFromRGB(0x555555);

    }
    return _infoLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _priceLabel.textColor = UIColorFromRGB(0x555555);
        
    }
    return _priceLabel;
}

- (UIView *)segmengView {
    if(!_segmengView) {
        _segmengView = [[UIView alloc] init];
        _segmengView.backgroundColor = XKSeparatorLineColor;
    }
    return _segmengView;
}

@end
