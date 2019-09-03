//
//  XKMallOrderWaitAcceptSingleCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderWaitAcceptSingleCell.h"
@interface XKMallOrderWaitAcceptSingleCell ()
@property (nonatomic, strong)UILabel *mallLabel;
@property (nonatomic, strong)UIImageView *arrowImgView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *priceLabel;

@property (nonatomic, strong)UIView *transportView;
@property (nonatomic, strong)UIButton *transportBtn;
@property (nonatomic, strong)UILabel *transportLabel;

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIButton *moreBtn;
@property (nonatomic, strong)UIButton *tipBtn;

@property (nonatomic, strong)MallOrderListDataItem *item;
@end

@implementation XKMallOrderWaitAcceptSingleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
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
    
    [self.contentView addSubview:self.transportView];
    [self.contentView addSubview:self.transportBtn];
    [self.contentView addSubview:self.transportLabel];
    
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.tipBtn];
}

- (void)bindData:(MallOrderListDataItem *)item {
    _item = item;
    MallOrderListObj *obj = item.goods.firstObject;
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
    NSMutableAttributedString *attrSt = [[NSMutableAttributedString alloc] initWithString:@""];

    NSInteger count = 0;
    if (item.logisticsInfos.count > 3) {
        count = 3;
    } else {
        count = item.logisticsInfos.count;
    }
    
    for (NSInteger i = 0; i < count; i ++) {
        XKOrderListTransportInfoItem *obj = item.logisticsInfos[i];
        NSString *time =  [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:obj.time];
        NSString *location = obj.location;
        NSString *info = [NSString stringWithFormat:@"%@ %@\n",time,location];
        UIColor *textColor = i == 0 ? UIColorFromRGB(0x222222) : UIColorFromRGB(0x999999);
        NSAttributedString *setpAttrStr = [[NSMutableAttributedString alloc] initWithString:info attributes:@{NSForegroundColorAttributeName:textColor}];
        [attrSt appendAttributedString:setpAttrStr];
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attrSt addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrSt length])];
    _transportLabel.attributedText = attrSt;
}

- (void)addUIConstraint {
    //topview
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
    
    [self.transportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.transportView.mas_left).offset(15);
        make.top.equalTo(self.transportView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];

    [self.transportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.transportView.mas_left).offset(15);
        make.right.equalTo(self.transportView.mas_right).offset(-10);
        make.top.equalTo(self.transportBtn.mas_bottom).offset(2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-50);
    }];
    
    [self.transportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(15);
        make.bottom.equalTo(self.transportLabel.mas_bottom).offset(10);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.transportView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.iconImgView.mas_bottom);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.priceLabel.mas_top);
    }];

    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 20));
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.tipBtn);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    
}
#pragma mark event

- (void)moreBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    if(self.moreBtnBlock) {
        self.moreBtnBlock(sender, ws.item.index);
    }
}

- (void)sureBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    if(self.sureBtnBlock) {
        self.sureBtnBlock(sender, ws.item.index);
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
        _statusLabel.text = @"等待买家收货";
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

//中间部分
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

//运输部分
- (UIView *)transportView {
    if(!_transportView) {
        _transportView = [[UIView alloc] init];
        _transportView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    }
    return _transportView;
}

- (UIButton *)transportBtn {
    if(!_transportBtn) {
        _transportBtn = [[UIButton alloc] init];
        [_transportBtn setTitle:@"运送中" forState:0];
        _transportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_transportBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        _transportBtn.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _transportBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_transportBtn setImage:[UIImage imageNamed:@""] forState:0];
    }
    return _transportBtn;
}

- (UILabel *)transportLabel {
    if(!_transportLabel) {
        _transportLabel = [[UILabel alloc] init];
        _transportLabel.numberOfLines  = 0;
        _transportLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];

    }
    return _transportLabel;
}

//底部view
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
        [_tipBtn setTitle:@"确认收货" forState:0];
        _tipBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_tipBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _tipBtn.layer.cornerRadius = 10.f;
        _tipBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _tipBtn.layer.borderWidth = 1.f;
        _tipBtn.layer.masksToBounds = YES;
        [_tipBtn setBackgroundColor:[UIColor whiteColor]];
        [_tipBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
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
