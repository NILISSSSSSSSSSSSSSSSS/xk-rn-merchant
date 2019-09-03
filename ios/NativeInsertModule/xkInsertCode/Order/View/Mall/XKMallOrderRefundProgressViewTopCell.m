//
//  XKMallOrderRefundProgressViewTopCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderRefundProgressViewTopCell.h"
#import "UIView+XKCornerRadius.h"
@interface XKMallOrderRefundProgressViewTopCell ()
@property (nonatomic, strong)UILabel *refundProgressLabel;
@property (nonatomic, strong)UILabel *orderLabel;
@end

@implementation XKMallOrderRefundProgressViewTopCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 5;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.refundProgressLabel];
    [self.contentView addSubview:self.orderLabel];
    
}

- (void)updateInfoWithModel:(XKMallOrderDetailViewModel *)item {
    self.orderLabel.text = [NSString stringWithFormat:@"订单编号:%zd",item.refundId];
    NSString *status = @"";
    if ([item.refundStatus isEqualToString:@"APPLY"]) {
        status = @"已申请";
    } else if ([item.refundStatus isEqualToString:@"REFUSED"]) {
        status = @"未通过";
    } else if ([item.refundStatus isEqualToString:@"PRE_USER_SHIP"]) {
        status = @"待用户发货";
    } else if ([item.refundStatus isEqualToString:@"PRE_PLAT_RECEIVE"]) {
        status = @"待平台收货";
    } else if ([item.refundStatus isEqualToString:@"PRE_REFUND"]) {
        status = @"待平台退款";
    } else if ([item.refundStatus isEqualToString:@"REFUNDING"]) {
       status = @"退款中";
    } else if ([item.refundStatus isEqualToString:@"COMPLETE"]) {
       status = @"退款完成";
    }
    self.refundProgressLabel.text = [NSString stringWithFormat:@"退款进度:%@",status];
}

- (void)addUIConstraint {
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.refundProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.orderLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
}

- (UILabel *)refundProgressLabel {
    if(!_refundProgressLabel) {
        _refundProgressLabel = [[UILabel alloc] init];
        _refundProgressLabel.font = XKRegularFont(14);
        _refundProgressLabel.textColor = UIColorFromRGB(0x222222);
        
        NSString *transport = @"申请中";
        NSString *transportStr = [NSString stringWithFormat:@"退款进度：%@",transport];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:transportStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(14)
                           range:NSMakeRange(5, transportStr.length - 5)];
        _refundProgressLabel.attributedText = attrString;
    }
    return _refundProgressLabel;
}

- (UILabel *)orderLabel {
    if(!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.font = XKRegularFont(14);
        _orderLabel.textColor = UIColorFromRGB(0x222222);
        
        NSString *number = @"234475757539399";
        NSString *numberStr = [NSString stringWithFormat:@"订单编号：%@",number];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:numberStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(14)
                           range:NSMakeRange(5, numberStr.length - 5)];
        _orderLabel.attributedText = attrString;
    }
    return _orderLabel;
}

@end
