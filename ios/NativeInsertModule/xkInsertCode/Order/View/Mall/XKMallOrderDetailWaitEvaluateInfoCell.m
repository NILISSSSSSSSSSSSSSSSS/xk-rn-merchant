//
//  XKMallOrderDetailWaitEvaluateInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailWaitEvaluateInfoCell.h"
@interface XKMallOrderDetailWaitEvaluateInfoCell ()

@property (nonatomic, strong) UIView  *topLineView;
@property (nonatomic, strong) UIView  *bottomLineView;
@property (nonatomic, strong) UILabel *topInfoLabel;
@property (nonatomic, strong) UILabel *bottomInfoLabel;

@end

@implementation XKMallOrderDetailWaitEvaluateInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 6.f;
        
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.topInfoLabel];
    [self.contentView addSubview:self.bottomInfoLabel];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
}

- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model withType:(NSInteger)type {
    if (type == 0) {
        _topLineView.hidden = YES;
         _bottomLineView.hidden = NO;
        NSString *number = model.orderId;
        NSString *numberStr = [NSString stringWithFormat:@"订单编号：%@",number];
        NSMutableAttributedString *orderString = [[NSMutableAttributedString alloc] initWithString:numberStr];
        [orderString addAttribute:NSFontAttributeName
                            value:XKRegularFont(12)
                            range:NSMakeRange(5, numberStr.length - 5)];
        _topInfoLabel.attributedText = orderString;
        
        NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(model.createTime).stringValue];
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",time];
        NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:timeStr];
        [timeString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, timeStr.length - 5)];
        [timeString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0x555555)
                           range:NSMakeRange(5, timeStr.length - 5)];
        _bottomInfoLabel.attributedText = timeString;
    } else   if (type == 1){
        _topLineView.hidden = YES;
        _bottomLineView.hidden = YES;
        NSString *payType = @"";
        if([model.payChannel isEqualToString: @"ALI_PAY"]) {
            payType = @"支付宝app";
        } else if([model.payChannel isEqualToString: @"ALI_PAY_WAP"]) {
            payType = @"支付宝手机网站支付";
        } else if([model.payChannel isEqualToString: @"ALI_PAY_QR"]) {
            payType = @"支付宝扫码支付";
        } else if([model.payChannel isEqualToString: @"ALI_PAY_PC_DIRECT"]) {
            payType = @"支付宝电脑网站支付";
        } else if([model.payChannel isEqualToString: @"WX"]) {
            payType = @"微信 App 支付";
        } else if([model.payChannel isEqualToString: @"WX_PUB"]) {
            payType = @"微信公众号支付";
        }
        NSString *type = [NSString stringWithFormat:@"%@   ¥%.2f",payType,model.amountInfo.payMoney / 100.f];
        NSString *typeStr = [NSString stringWithFormat:@"支付方式：%@",type];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:typeStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, typeStr.length - 5)];
        _topInfoLabel.attributedText = attrString;
        
        
        NSString *payTime = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(model.payTime).stringValue];
        NSString *payTimeStr = [NSString stringWithFormat:@"支付时间：%@",payTime];
        NSMutableAttributedString *payTimeAttrString = [[NSMutableAttributedString alloc] initWithString:payTimeStr];
        [payTimeAttrString addAttribute:NSFontAttributeName
                                  value:XKRegularFont(12)
                                  range:NSMakeRange(5, payTimeStr.length - 5)];
        _bottomInfoLabel.attributedText = payTimeAttrString;
    } else if (type == 2) {
        _topLineView.hidden = NO;
        _bottomLineView.hidden = YES;
        NSArray *nameArr = @[@"小可自营物流",@"顺丰",@"韵达",@"中通",@"申通",@"圆通",@"百世汇通",@"用户自行配送"];
        NSArray *valueArr = @[@"XK",@"SF",@"YD",@"ZT",@"ST",@"YT",@"BSHT",@"HIMSELF"];
        NSInteger index = [valueArr indexOfObject:model.logisticsName];
        NSString *transport = nameArr[index];
        NSString *transportStr = [NSString stringWithFormat:@"物流公司：%@   %@",transport,model.logisticsNo];
        NSMutableAttributedString *transportAttrString = [[NSMutableAttributedString alloc] initWithString:transportStr];
        [transportAttrString addAttribute:NSFontAttributeName
                                    value:XKRegularFont(12)
                                    range:NSMakeRange(5, transportStr.length - 5)];
        _topInfoLabel.attributedText = transportAttrString;
        
        NSString *postTime = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:model.shippingTime];
        NSString *postTimeStr = [NSString stringWithFormat:@"发货时间：%@",postTime];
        NSMutableAttributedString *postTimeAttrString = [[NSMutableAttributedString alloc] initWithString:postTimeStr];
        [postTimeAttrString addAttribute:NSFontAttributeName
                                   value:XKRegularFont(12)
                                   range:NSMakeRange(5, postTimeStr.length - 5)];
        _bottomInfoLabel.attributedText = postTimeAttrString;
    } else {
        _topInfoLabel.hidden = NO;
        _bottomLineView.hidden = YES;
        NSString *sendTime = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(model.payTime).stringValue];
        NSString *sendTimeStr = [NSString stringWithFormat:@"收货时间：%@",sendTime];
        NSMutableAttributedString *sendTimeAttrString = [[NSMutableAttributedString alloc] initWithString:sendTimeStr];
        [sendTimeAttrString addAttribute:NSFontAttributeName
                                  value:XKRegularFont(12)
                                  range:NSMakeRange(5, sendTimeStr.length - 5)];
        _topInfoLabel.attributedText = sendTimeAttrString;
      

    }
}

- (void)addUIConstraint {
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [self.topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.topLineView.mas_top).offset(15);
    }];
    
    [self.bottomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.topInfoLabel.mas_bottom).offset(10);
      
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark event
- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _topLineView;
}

- (UILabel *)topInfoLabel {
    if(!_topInfoLabel) {
        _topInfoLabel = [[UILabel alloc] init];
        _topInfoLabel.font = XKRegularFont(14);
        _topInfoLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _topInfoLabel;
}

- (UILabel *)bottomInfoLabel {
    if(!_bottomInfoLabel) {
        _bottomInfoLabel = [[UILabel alloc] init];
        _bottomInfoLabel.font = XKRegularFont(14);
        _bottomInfoLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _bottomInfoLabel;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomLineView;
}
@end
