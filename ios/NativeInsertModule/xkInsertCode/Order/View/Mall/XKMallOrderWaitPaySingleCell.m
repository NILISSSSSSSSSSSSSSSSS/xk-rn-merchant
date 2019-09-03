//
//  XKMainOrderWatiPayCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderWaitPaySingleCell.h"

@interface XKMallOrderWaitPaySingleCell ()
@property (nonatomic, strong)UIButton *choseBtn;
@property (nonatomic, strong)UIImageView *arrowImgView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *priceLabel;

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIButton *moreBtn;
@property (nonatomic, strong)UIButton *payBtn;

@property (nonatomic, strong)MallOrderListDataItem *item;
@end

@implementation XKMallOrderWaitPaySingleCell

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
    
    [self.bgContainView addSubview:self.choseBtn];
    [self.bgContainView addSubview:self.arrowImgView];
    [self.bgContainView addSubview:self.statusLabel];
    [self.bgContainView addSubview:self.topLineView];
    
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.typeLabel];
    [self.bgContainView addSubview:self.priceLabel];
    
    [self.bgContainView addSubview:self.bottomLineView];
    [self.bgContainView addSubview:self.moreBtn];
    [self.bgContainView addSubview:self.payBtn];
}

- (void)bindData:(MallOrderListDataItem *)item {
    _item = item;
    MallOrderListObj *obj = item.goods.firstObject;
    self.choseBtn.selected = item.isChose;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:obj.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = obj.goodsName;
    self.typeLabel.text = [NSString stringWithFormat:@"规格参数：%@  x%zd",obj.goodsShowAttr,obj.num];
    NSString *price = @(obj.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格： ¥%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0x101010)
                       range:NSMakeRange(4, priceStr.length - 4)];
    self.priceLabel.attributedText = attrString;
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(10);
        make.top.equalTo(self.bgContainView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choseBtn.mas_right).offset(10);
        make.centerY.equalTo(self.choseBtn);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.centerY.equalTo(self.choseBtn);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgContainView.mas_top).offset(30);
        make.left.right.equalTo(self.bgContainView);
        make.height.mas_equalTo(1);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.top.equalTo(self.topLineView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgContainView);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.bottomLineView.mas_top).offset(-15);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.priceLabel.mas_top);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 22));
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(10);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
    }];
    
    
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.payBtn);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    

}
#pragma mark event
- (void)choseBtnClick:(UIButton *)sender {
    if(self.choseBtnBlock) {
        sender.selected = !sender.selected;
        self.choseBtnBlock(sender,_item.index);
    }
}

- (void)moreBtnClick:(UIButton *)sender {
    if(self.moreBtnBlock) {
        self.moreBtnBlock(sender,_item.index);
    }
}

- (void)payBtnClick:(UIButton *)sender {
    if(self.payBtnBlock) {
        self.payBtnBlock(sender,_item.index);
    }
}

#pragma mark lazy
- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setTitle:@"晓可商城" forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_choseBtn setTitle:@"晓可商城" forState:UIControlStateSelected];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
         [_choseBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        _choseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _choseBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
}

- (UIImageView *)arrowImgView {
    if(!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImgView.image = [UIImage imageNamed:@"xk_btn_order_grayArrow"];
    }
    return _arrowImgView;
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _statusLabel.textColor = UIColorFromRGB(0xee6161);
        _statusLabel.text = @"等待买家付款";
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _topLineView;
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
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if(!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        [_typeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _typeLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _typeLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _priceLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _priceLabel;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomLineView;
}

- (UIButton *)payBtn {
    if(!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        [_payBtn setTitle:@"去付款" forState:0];
        _payBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_payBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _payBtn.layer.cornerRadius = 10.f;
        _payBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _payBtn.layer.borderWidth = 1.f;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn setBackgroundColor:[UIColor whiteColor]];
        [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (UIButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"更多" forState:0];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _moreBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_moreBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_moreBtn setBackgroundColor:[UIColor whiteColor]];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
@end
