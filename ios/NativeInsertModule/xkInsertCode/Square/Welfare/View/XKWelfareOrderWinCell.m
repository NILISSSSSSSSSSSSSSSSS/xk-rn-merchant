//
//  XKWelfareOrderWinCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderWinCell.h"
#import "XKTimeSeparateHelper.h"
@interface XKWelfareOrderWinCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)WelfareOrderDataItem *item;
@end

@implementation XKWelfareOrderWinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.backgroundColor = [UIColor clearColor];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.timeLabel];
    [self.bgContainView addSubview:self.statusLabel];
}

- (void)bindData:(WelfareOrderDataItem *)item {
    _item = item;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;
    NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(item.lotteryTime).stringValue];
    self.timeLabel.text = [NSString stringWithFormat:@"中奖时间：%@",time];
    NSString *status = @"";
    if([item.state isEqualToString:@"NO_LOTTERY"]) {
        status = @"未开奖";
    } else if([item.state isEqualToString:@"LOSING_LOTTERY"]) {
        status = @"未中奖";
    } else if([item.state isEqualToString:@"WINNING_LOTTERY"]) {
        status = @"已中奖";
    } else if([item.state isEqualToString:@"SHARE_LOTTERY"]) {
        status = @"已晒单";
    } else if([item.state isEqualToString:@"NOT_SHARE"]) {
        status = @"待分享";
    } else if([item.state isEqualToString:@"NOT_DELIVERY"]) {
        status = @"待发货";
    } else if([item.state isEqualToString:@"DELIVERY"]) {
        status = @"待收货";
    } else if([item.state isEqualToString:@"RECEVING"]) {
        status = @"已收货";
    } else if([item.state isEqualToString:@"CHANGED"]) {
        status = @"已换货";
    }
    NSString *statusStr = [NSString stringWithFormat:@"商品状态：%@",status];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(5, statusStr.length - 5)];
    self.statusLabel.attributedText = attrString;
}

- (void)bindItem:(XKMallBuyCarItem *)item {
     [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.goodsName;
    self.timeLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.timeLabel.text = [NSString stringWithFormat:@"规格：%@ x %zd",item.goodsAttr, item.quantity];
    NSString *price = @(item.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格：%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(3, priceStr.length - 3)];
    self.statusLabel.attributedText = attrString;
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.top.equalTo(self.bgContainView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(3);
        make.right.equalTo(self.nameLabel);
    }];

}

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
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _timeLabel.textColor = UIColorFromRGB(0x555555);
        
    }
    return _timeLabel;
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _statusLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _statusLabel;
}

@end
