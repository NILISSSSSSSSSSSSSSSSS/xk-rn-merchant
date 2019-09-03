//
//  XKOrderDetailBookingStatusTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderDetailBookingStatusTableViewCell.h"
#import "XKTradingAreaOrderDetaiModel.h"

@interface XKOrderDetailBookingStatusTableViewCell ()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;
@property (nonatomic, strong) NSTimer          *timer;
@property (nonatomic, assign) NSInteger        second;
@property (nonatomic, assign) NSInteger        orderStatus;



@end

@implementation XKOrderDetailBookingStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLabel];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.height.width.equalTo(@14);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.imgView);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];

}

- (void)setValueWithModel:(XKTradingAreaOrderDetaiModel *)model orderType:(NSInteger)orderType orderStatus:(NSInteger)status {
    [self.timer invalidate];
    self.timer = nil;
    self.orderStatus = status;
    NSString *statusName;
    NSString *decName;
    /*NSMutableArray *seatNameArr = [NSMutableArray array];
    NSString *seatName;
     for (OrderItems *items in model.items) {
        if (items.seatName.length) {
            [seatNameArr addObject:items.seatName];
        }
    }
    if (seatNameArr.count) {
        seatName = [seatNameArr componentsJoinedByString:@","];
    }*/
    
    //判断订单状态
    if (status == 0) {
        statusName = @"待接单";
        decName = [self addTimerWithTimestampString:model.agreeEndDate];

    } else if (status == 1) {
        statusName = @"待支付";
        decName = [self addTimerWithTimestampString:model.payEndDate];

    } else if (status == 2) {
        statusName = @"待消费";
        /* 退款方式 服务类 商品类 住宿类 消费前CONSUME_BEFORE,预约规定前多少时间可退RESERVATION_BEFORE_BYTIME,预约前随时退RESERVATION_BEFORE,不能退NOT_REFUNDS*/
        if ([model.refunds isEqualToString:@"CONSUME_BEFORE"]) {
            decName = @"消费前可退";
        } else if ([model.refunds isEqualToString:@"RESERVATION_BEFORE_BYTIME"]) {
            decName = [NSString stringWithFormat:@"消费前%@小时可退", model.refundsTime];
        } else if ([model.refunds isEqualToString:@"RESERVATION_BEFORE"]) {
            decName = @"随时可退";
        } else if ([model.refunds isEqualToString:@"NOT_REFUNDS"]) {
            decName = @"该订单不支持退款";
        } else {
            decName = @"该订单支持申请退款";
        }
    } else if (status == 3) {
        statusName = @"备货中";
        decName = @"商家正在准备商品";
    } else if (status == 4) {
        statusName = @"进行中";
        decName = @"订单正在进行中";
    } else if (status == 5) {
        statusName = @"待评价";
        decName = [self addTimerWithTimestampString:model.evaluateEndDate];
    } else if (status == 6) {
        statusName = @"已完成";
        decName = [NSString stringWithFormat:@"完成时间：%@", [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:model.updatedAt]];
    } else if (status == 7) {
        statusName = @"售后中";
        decName = @"等待商家确认";
    } else if (status == 8) {
        statusName = @"已关闭";
        decName = [NSString stringWithFormat:@"关闭时间：%@", [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:model.updatedAt]];
    }
    
    if (orderType == 0) {//服务
    } else if (orderType == 1) {//酒店
    } else if (orderType == 2) {//现场购物
    } else {//外卖
        if ([statusName isEqualToString:@"进行中"]) {
            decName = @"商品正在配送";
        } else if ([statusName isEqualToString:@"待评价"]) {
            decName = @"感谢您对晓可的信任，您可以对商品做出评价";
        }
    }

    /*if (seatName) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", statusName, seatName];
    } else {*/
        self.nameLabel.text = statusName;
    /*}*/
    self.decLabel.text = decName;
}



- (NSString *)addTimerWithTimestampString:(NSString *)timestampString {
    self.second = [XKTimeSeparateHelper backSecondWithTimestampString:timestampString];
    
    if (self.second >= 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(nextTime)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        return [self backDecLabelText];
    } else {
        return @"(29分56秒)后台没起定时任务，bug指给后台。";
    }
}

- (void)nextTime {
    self.decLabel.text = [self backDecLabelText];
}

- (NSString *)backDecLabelText {
    
    NSInteger day = self.second / 3600 / 24;
    NSInteger hour = self.second / 3600;
    NSInteger mint = self.second % 3600 / 60;
    NSInteger secs = self.second % 3600 % 60;
    
    
    //判断订单状态
    NSString *result = @"";
    if (self.orderStatus == 0) {//待接单
        result = [NSString stringWithFormat:@"%d分%d秒后商家未接单，系统将关闭订单", (int)mint, (int)secs];
    } else if (self.orderStatus == 1) {//待支付
        result = [NSString stringWithFormat:@"%d分%d秒后仍未付款，系统将关闭订单", (int)mint, (int)secs];
    } else if (self.orderStatus == 5) {//待评价
        result = [NSString stringWithFormat:@"温馨提示：%d天%d时%d分%d秒后，系统将默认好评", (int)day, (int)hour, (int)mint, (int)secs];
    }
    if (self.second == 0) {
        //刷新
        if (self.refreshOrderDetailBlock) {
            self.refreshOrderDetailBlock();
        }
        [self.timer invalidate];
        self.timer = nil;
    }
    self.second --;
    return result;
}



#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.text = @"待付款(包间102)";
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0xee6161);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
//        _decLabel.text = @"等待商家准备";
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLabel.textColor = HEX_RGB(0x999999);
        _decLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _decLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"xk_icon_snatchTreasure_order_waitTrans_detail"];
    }
    return _imgView;
}


@end
