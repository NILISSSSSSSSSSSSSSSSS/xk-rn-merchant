//
//  XKMallOrderAfterSaleSingleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderAfterSaleSingleCell.h"
@interface XKMallOrderAfterSaleSingleCell ()
@property (nonatomic, strong)UILabel *mallLabel;
@property (nonatomic, strong)UIImageView *arrowImgView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *priceLabel;

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIButton *tipBtn;

@property (nonatomic, strong)MallOrderListDataItem *item;
@end

@implementation XKMallOrderAfterSaleSingleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 175)];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.mallLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.topLineView];
    
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.priceLabel];
    
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.tipBtn];
}

- (void)bindData:(MallOrderListDataItem *)item {
    _item = item;
    MallOrderListObj *obj = item.goods.firstObject;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:obj.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = obj.goodsName;
    self.typeLabel.text = [NSString stringWithFormat:@"%@  x%zd",obj.goodsShowAttr,obj.num];
    NSString *price = @(obj.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格： ¥%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0x101010)
                       range:NSMakeRange(4, priceStr.length - 4)];
    self.priceLabel.attributedText = attrString;
     _tipBtn.hidden = NO;
    if ([item.refundStatus isEqualToString:@"APPLY"]) {
        _statusLabel.text = @"已申请";
        [_tipBtn setTitle:@"取消退货" forState:0];
    } else if ([item.refundStatus isEqualToString:@"REFUSED"]) {
        _statusLabel.text = @"未通过";
        [_tipBtn setTitle:@"再次申请" forState:0];
    } else if ([item.refundStatus isEqualToString:@"PRE_USER_SHIP"]) {
        _statusLabel.text = @"待用户发货";
        [_tipBtn setTitle:@"查看详情" forState:0];
    } else if ([item.refundStatus isEqualToString:@"PRE_PLAT_RECEIVE"]) {
        _statusLabel.text = @"待平台收货";
        [_tipBtn setTitle:@"查看详情" forState:0];
    } else if ([item.refundStatus isEqualToString:@"PRE_REFUND"]) {
        _statusLabel.text = @"待平台退款";
        [_tipBtn setTitle:@"查看详情" forState:0];
    } else if ([item.refundStatus isEqualToString:@"REFUNDING"]) {
        _statusLabel.text = @"退款中";
        [_tipBtn setTitle:@"查看详情" forState:0];
    } else if ([item.refundStatus isEqualToString:@"COMPLETE"]) {
        _statusLabel.text = @"退款完成";
        [_tipBtn setTitle:@"查看详情" forState:0];
    }
}

- (void)addUIConstraint {
    [self.mallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mallLabel.mas_right).offset(10);
        make.centerY.equalTo(self.mallLabel);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.mallLabel);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.topLineView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
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
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}

#pragma mark event
- (void)tipBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    if(self.cancelBtnBlock) {
        self.cancelBtnBlock(sender, ws.item.index);
    }
}

#pragma mark lazy
- (UILabel *)mallLabel {
    if(!_mallLabel) {
        _mallLabel = [[UILabel alloc] init];
        _mallLabel.text = @"晓可商城";
        _mallLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _mallLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _mallLabel;
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
        _statusLabel.text = @"等待买家评价";
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
        _nameLabel.text = @"三星（SAMSUNG)C27H711QE2k曲面27英寸完美高分显示器";
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if(!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        [_typeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _typeLabel.textColor = UIColorFromRGB(0x999999);
        _typeLabel.text = @"顶配未来战士系列   x1";
    }
    return _typeLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _priceLabel.textColor = UIColorFromRGB(0x999999);
        NSString *price = @"2799";
        NSString *priceStr = [NSString stringWithFormat:@"价格： ¥%@",price];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0x101010)
                           range:NSMakeRange(5, priceStr.length - 5)];
        _priceLabel.attributedText = attrString;
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

- (UIButton *)tipBtn {
    if(!_tipBtn) {
        _tipBtn = [[UIButton alloc] init];
        [_tipBtn setTitle:@"取消退货" forState:0];
        _tipBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_tipBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _tipBtn.layer.cornerRadius = 10.f;
        _tipBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _tipBtn.layer.borderWidth = 1.f;
        _tipBtn.layer.masksToBounds = YES;
        [_tipBtn setBackgroundColor:[UIColor whiteColor]];
        [_tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}

@end
