//
//  XKMallTextTableViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//
#import "XKPayAlertSheetView.h"
#import "XKMallOrderDetailWaitPayInfoCell.h"
@interface XKMallOrderDetailWaitPayInfoCell ()

@property (nonatomic, strong)UILabel *topInfoLabel;
@property (nonatomic, strong)UILabel *bottomInfoLabel;

@end

@implementation XKMallOrderDetailWaitPayInfoCell

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

}

- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model {
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
}

- (void)addUIConstraint {
    
    [self.topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    [self.bottomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.topInfoLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];


    
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



@end
