//
//  XKMallApplyAfterSaleListCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallApplyAfterSaleListCell.h"
@interface XKMallApplyAfterSaleListCell ()
@property (nonatomic, strong) UIButton *choseBtn;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) XKMallOrderDetailGoodsItem  *item;
@property (nonatomic, strong) MallOrderListObj  *obj;
@end

@implementation XKMallApplyAfterSaleListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.choseBtn];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.priceLabel];
}

- (void)bindDetailItem:(XKMallOrderDetailGoodsItem*)obj {
    _item = obj;
    self.choseBtn.selected = _item.isChose;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:_item.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = _item.goodsName;
    self.typeLabel.text = [NSString stringWithFormat:@"%@  x %zd",_item.goodsAttr,_item.goodsNum];
    NSString *price = @(_item.goodsPrice / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格： ¥%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0x101010)
                       range:NSMakeRange(4, priceStr.length - 4)];
    _priceLabel.attributedText = attrString;
}

- (void)bindListItem:(MallOrderListObj*)obj {
    _obj = obj;
    self.choseBtn.selected = obj.isChose;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:obj.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = obj.goodsName;
    self.typeLabel.text = [NSString stringWithFormat:@"%@  x %zd",obj.goodsShowAttr,obj.num];
    NSString *price = @(obj.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格： ¥%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0x101010)
                       range:NSMakeRange(4, priceStr.length - 4)];
    _priceLabel.attributedText = attrString;
}

- (void)addUIConstraint {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(40);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(40);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.priceLabel.mas_top);
    }];
}


- (void)choseBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    if(self.choseBtnBlock) {
        if (ws.obj) {
            self.choseBtnBlock(sender, ws.obj.index);
        } else {
              self.choseBtnBlock(sender, ws.item.index);
        }
      
    }
}
#pragma mark 懒加载
- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
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
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;

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
@end
