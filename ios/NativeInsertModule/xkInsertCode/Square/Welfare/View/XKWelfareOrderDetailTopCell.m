//
//  XKWelfareOrderDetailWaitOpenTopCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailTopCell.h"
@interface XKWelfareOrderDetailTopCell ()
@property (nonatomic, strong)UIImageView *timerTipImgView;
@property (nonatomic, strong)UILabel *timerTipLabel;
@property (nonatomic, strong)UILabel *timerLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *phoneLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation XKWelfareOrderDetailTopCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.timerTipImgView];
    [self.contentView addSubview:self.timerTipLabel];
    [self.contentView addSubview:self.timerLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.addressLabel];
    
}

- (void)handleOrderDetailWithType:(MallOrderType)orderType dataModel:(XKMallOrderDetailViewModel *)model {
    NSString *status = @"";
    switch (orderType) {
        case MOT_PRE_PAY:
            status = @"等待付款";
            break;
        case MOT_PRE_SHIP:
            status = @"等待商家发货";
            break;
        case MOT_PRE_RECEVICE:
            status = @"等待买家收货";
            break;
        case MOT_PRE_EVALUATE:
            status = @"等待买家评价";
            break;
        case MOT_COMPLETELY:
        {
             _timerTipImgView.image = [UIImage imageNamed:@"xk_ic_order_success"];
             status = @"交易成功";
            _timerLabel.textColor = XKMainTypeColor;
        }
           
            break;
        case MOT_TERMINATE:
        {
            _timerTipImgView.image = [UIImage imageNamed:@"xk_ic_order_success"];
            status = @"交易已关闭";
            _timerLabel.textColor = XKMainTypeColor;
        }
            
            break;
        case MOT_SALED_SERVICE:
            status = @"交易完成";
            break;
            
        default:
            break;
    }
    self.timerLabel.text = status;
    self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",model.addressInfo.userName ?:@""];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",model.addressInfo.userPhone ?:@""];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",model.addressInfo.userAddress ?:@""];
}

- (void)handleWelfareOrderDetailWithType:(WelfareOrderType)orderType dataModel:(XKWelfareOrderDetailViewModel *)model {
    NSString *status = @"";
    _timerLabel.textColor = UIColorFromRGB(0x222222);
    switch (orderType) {
        case WelfareOrderTypePre_send://待发货
            status = @"等待商家发货";
            break;
        case WelfareOrderTypePre_recevice:
            status = @"等待买家收货";
            break;
        case WelfareOrderTypeReceviced:
            status = @"";
            break;
        case WelfareOrderTypeNotShare:
            status = @"等待用户分享";
            break;
            
        default:
            break;
    }
    self.timerLabel.text = status;
    self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",model.userName];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",model.userPhone];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",model.userAddress];
    
    NSString *address = [NSString stringWithFormat:@"地址：%@",model.userAddress];
//    CGFloat addressH = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.height;
//    [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, addressH + 75 + 5)];
    
}

- (void)addUIConstraint {
    [self.timerTipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.timerTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timerTipImgView.mas_right).offset(5);
        make.centerY.equalTo(self.timerTipImgView);
    }];
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timerTipLabel.mas_right).offset(5);
        make.centerY.equalTo(self.timerTipLabel);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.timerTipLabel.mas_bottom).offset(15);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(65);
        make.top.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timerTipImgView);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downCountTime) userInfo:nil repeats:YES];
}

-(void)downCountTime{
    int timeCount = self.timerLabel.text.intValue;
    if (timeCount <= 0) {
        [_timer invalidate];
        _timer = nil;
        self.timerLabel.text = @"00:00:00";
    } else {
        self.timerLabel.text = [NSString stringWithFormat:@"%lds", (long)timeCount];
        timeCount--;
    }
}

- (UIImageView *)timerTipImgView {
    if(!_timerTipImgView) {
        _timerTipImgView = [[UIImageView alloc] init];
        _timerTipImgView.contentMode = UIViewContentModeScaleAspectFit;
        _timerTipImgView.image = [UIImage imageNamed:@"xk_icon_snatchTreasure_order_waitTrans_detail"];
    }
    return _timerTipImgView;
}

- (UILabel *)timerTipLabel {
    if(!_timerTipLabel) {
        _timerTipLabel = [[UILabel alloc] init];
        _timerTipLabel.font = XKRegularFont(16);
        _timerTipLabel.textColor = UIColorFromRGB(0x222222);
    }
    
    return _timerTipLabel;
}

- (UILabel *)timerLabel {
    if(!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        [_timerLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16]];
        _timerLabel.textColor = UIColorFromRGB(0xee6161);

    }
    return _timerLabel;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]];
        _nameLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _nameLabel;
}


- (UILabel *)phoneLabel {
    if(!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        [_phoneLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]];
        _phoneLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _phoneLabel;
}

- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13]];
        _addressLabel.textColor = UIColorFromRGB(0x555555);
        _addressLabel.numberOfLines = 2;

    }
    return _addressLabel;
}

@end
