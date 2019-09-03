//
//  XKCustomerSerChatOrderTableViewCell.m
//  XKSquare
//
//  Created by william on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomerSerChatOrderTableViewCell.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKMallOrderViewModel.h"

@interface XKCustomerSerChatOrderTableViewCell()

@property(nonatomic, strong) UIButton           *chooseBtn;
@property(nonatomic, strong) UIImageView        *goodsImgView;
@property(nonatomic, strong) UILabel            *titleLabel;
@property(nonatomic, strong) UILabel            *priceLabel;
@property(nonatomic, strong) UILabel            *timeLabel;
@property(nonatomic, strong) UILabel            *orderNumLabel;
@property(nonatomic, strong) UILabel            *statusLabel;


@property (nonatomic, strong) WelfareOrderDataItem *welfareOrder;

@property (nonatomic, strong) MallOrderListDataItem *platformOrder;

@end
@implementation XKCustomerSerChatOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self layoutViews];
    }
    return self;
}

-(void)initViews{
    [self.contentView addSubview:self.chooseBtn];
    [self.contentView addSubview:self.goodsImgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.orderNumLabel];
    [self.contentView addSubview:self.statusLabel];
}

-(void)layoutViews{
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15.0 * ScreenScale);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(18.0 * ScreenScale);
    }];
    
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.chooseBtn.mas_right).offset(15.0 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(100 * ScreenScale, 100 * ScreenScale));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsImgView);
        make.left.mas_equalTo(self.goodsImgView.mas_right).offset(10 * ScreenScale);
        make.trailing.mas_equalTo(-12 * ScreenScale);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.timeLabel.mas_top);
        make.leading.trailing.mas_equalTo(self.titleLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.orderNumLabel.mas_top);
        make.leading.trailing.mas_equalTo(self.priceLabel);
    }];
    
    [self.orderNumLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodsImgView).offset(-5.0 * ScreenScale);
        make.leading.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.statusLabel.mas_left).offset(-5.0 * ScreenScale);
    }];
    
    [self.statusLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-12.0 * ScreenScale);
        make.bottom.mas_equalTo(self.orderNumLabel);
    }];

}

- (void)configCellWithWelfareOrder:(WelfareOrderDataItem *)welfareOrder {
    _welfareOrder = welfareOrder;
    if (_welfareOrder.url && _welfareOrder.url.length) {
        [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:_welfareOrder.url] placeholderImage:kDefaultPlaceHolderImg];
    } else {
        self.goodsImgView.image = kDefaultPlaceHolderImg;
    }
    self.titleLabel.text = _welfareOrder.name;
    self.priceLabel.hidden = YES;
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:[NSDate dateWithTimeIntervalSince1970:_welfareOrder.lotteryTime]]];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", _welfareOrder.orderId];
    if ([_welfareOrder.state isEqualToString:@"NO_LOTTERY"]) {
        // 未开奖
        self.statusLabel.text = @"未开奖";
        self.statusLabel.textColor = XKMainRedColor;
    } else if ([_welfareOrder.state isEqualToString:@"NOT_SHARE"] || [_welfareOrder.state isEqualToString:@"NOT_DELIVERY"] || [_welfareOrder.state isEqualToString:@"DELIVERY"]) {
        // 已中奖
        self.statusLabel.text = @"已中奖";
        self.statusLabel.textColor = XKMainRedColor;
    } else if ([_welfareOrder.state isEqualToString:@"RECEVING"] || [_welfareOrder.state isEqualToString:@"LOSING_LOTTERY"] || [_welfareOrder.state isEqualToString:@"SHARE_LOTTERY"]) {
        // 已完成
        self.statusLabel.text = @"已完成";
        self.statusLabel.textColor = HEX_RGB(0x555555);
    }
}

- (void)configCellWithPlatformOrder:(MallOrderListDataItem *)platformOrder {
    _platformOrder = platformOrder;
    if (_platformOrder.goods.count >= 1) {
        MallOrderListObj *goods = _platformOrder.goods.firstObject;
        if (goods.goodsPic && goods.goodsPic.length) {
            [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goodsPic] placeholderImage:kDefaultPlaceHolderImg];
        } else {
            self.goodsImgView.image = kDefaultPlaceHolderImg;
        }
        if (_platformOrder.goods.count == 1) {
            self.titleLabel.text = goods.goodsName;
        } else {
            self.titleLabel.text = [NSString stringWithFormat:@"共%tu个商品", _platformOrder.goods.count];
        }
    } else {
        self.goodsImgView.image = kDefaultPlaceHolderImg;
        self.titleLabel.text = @"订单内无商品";
    }
    CGFloat allPrice = 0.0;
    for (MallOrderListObj *goods in _platformOrder.goods) {
        allPrice += goods.price * goods.num;
    }
    self.priceLabel.attributedText = [NSMutableAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(@"价格：").font(XKRegularFont(12.0)).textColor(HEX_RGB(0x777777));
        confer.text([NSString stringWithFormat:@"%.2f", allPrice / 100.0]).font(XKRegularFont(12.0)).textColor(XKMainRedColor);
    }];
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithDate:[NSDate dateWithTimeIntervalSince1970:_platformOrder.createTime]]];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", _platformOrder.orderId];
    if ([_platformOrder.orderStatus isEqualToString:@"PRE_PAY"]) {
        self.statusLabel.text = @"待付款";
        self.statusLabel.textColor = XKMainRedColor;
    } else if ([_platformOrder.orderStatus isEqualToString:@"PRE_SHIP"]) {
        self.statusLabel.text = @"待发货";
        self.statusLabel.textColor = XKMainRedColor;
    } else if ([_platformOrder.orderStatus isEqualToString:@"PRE_RECEVICE"]) {
        self.statusLabel.text = @"待收货";
        self.statusLabel.textColor = XKMainRedColor;
    } else if ([_platformOrder.orderStatus isEqualToString:@"PRE_EVALUATE"]) {
        self.statusLabel.text = @"待评价";
        self.statusLabel.textColor = XKMainRedColor;
    } else if ([_platformOrder.orderStatus isEqualToString:@"COMPLETELY"]) {
        self.statusLabel.text = @"已完成";
        self.statusLabel.textColor = HEX_RGB(0x555555);
    }
}

- (void)setCellSelected:(BOOL)selected {
    self.chooseBtn.selected = selected;
}

#pragma mark – Getters and Setters

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
        [_chooseBtn setImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
    }
    return _chooseBtn;
}

-(UIImageView *)goodsImgView{
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.layer.cornerRadius = 5.0;
        _goodsImgView.layer.masksToBounds = YES;
        _goodsImgView.clipsToBounds = YES;
    }
    return _goodsImgView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"标题";
        _titleLabel.font = XKRegularFont(14.0);
        _titleLabel.textColor = HEX_RGB(0x222222);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"价格";
        _priceLabel.font = XKRegularFont(12.0);
        _priceLabel.textColor = HEX_RGB(0x777777);
        _priceLabel.numberOfLines = 1;
    }
    return _priceLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"时间";
        _timeLabel.font = XKRegularFont(12.0);
        _timeLabel.textColor = HEX_RGB(0x777777);
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}

-(UILabel *)orderNumLabel{
    if (!_orderNumLabel) {
        _orderNumLabel = [[UILabel alloc] init];
        _orderNumLabel.text = @"订单号";
        _orderNumLabel.font = XKRegularFont(12.0);
        _orderNumLabel.textColor = HEX_RGB(0x777777);
        _orderNumLabel.numberOfLines = 1;
    }
    return _orderNumLabel;
}

-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"状态";
        _statusLabel.font = XKRegularFont(12.0);
        _statusLabel.textColor = HEX_RGB(0x555555);
        _statusLabel.numberOfLines = 1;
    }
    return _statusLabel;
}
@end
