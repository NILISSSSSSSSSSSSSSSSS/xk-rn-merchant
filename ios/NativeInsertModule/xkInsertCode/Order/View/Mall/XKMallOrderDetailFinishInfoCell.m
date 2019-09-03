//
//  XKMallOrderDetailFinishInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderDetailFinishInfoCell.h"
#import "PhotoPreviewModel.h"
#import "BigPhotoPreviewBaseController.h"
@interface XKMallOrderDetailFinishInfoCell ()
@property (nonatomic, strong)UILabel *bottomLeftLabel;
@property (nonatomic, strong)UILabel *bottomRightLabel;
@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UILabel *orderNoLabel;
@property (nonatomic, strong)UILabel *orderTimeLabel;
@property (nonatomic, strong)UIView *midLineView;

@property (nonatomic, strong)UILabel *payWayLabel;
@property (nonatomic, strong)UILabel *payTimeLabel;
@property (nonatomic, strong)UIView *centerLineView;

@property (nonatomic, strong)UILabel *transportCompanyLabel;
@property (nonatomic, strong)UILabel *transportTimeLabel;
@property (nonatomic, strong)UIView *bottomLineView;

@property (nonatomic, strong)UILabel *acceptTimeLabel;
@property (nonatomic, strong)UIView *lastLineView;

@property (nonatomic, strong)UILabel *ticketTypeLabel;
@property (nonatomic, strong)UILabel *ticketHeaderLabel;
@property (nonatomic, strong)UILabel *ticketContentLabel;
@property (nonatomic, strong)UIButton *downLoadBtn;

@property (nonatomic, strong) XKMallOrderDetailViewModel  *model;
@end

@implementation XKMallOrderDetailFinishInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 6.f;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bottomLeftLabel];
    [self.contentView addSubview:self.bottomRightLabel];
    [self.contentView addSubview:self.topLineView];
    
    [self.contentView addSubview:self.orderNoLabel];
    [self.contentView addSubview:self.orderTimeLabel];
    [self.contentView addSubview:self.midLineView];
    
    [self.contentView addSubview:self.payWayLabel];
    [self.contentView addSubview:self.payTimeLabel];
    [self.contentView addSubview:self.centerLineView];
    
    [self.contentView addSubview:self.transportCompanyLabel];
    [self.contentView addSubview:self.transportTimeLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    [self.contentView addSubview:self.acceptTimeLabel];
    [self.contentView addSubview:self.lastLineView];
    
    [self.contentView addSubview:self.ticketTypeLabel];
    [self.contentView addSubview:self.ticketHeaderLabel];
    [self.contentView addSubview:self.ticketContentLabel];
    [self.contentView addSubview:self.downLoadBtn];
}

- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model {
    _model = model;
    if (model.invoiceInfo.electInvoice) {
        _downLoadBtn.hidden = NO;
    } else {
         _downLoadBtn.hidden = YES;
    }
    NSString *number =  model.orderId;
    NSString *numberStr = [NSString stringWithFormat:@"订单编号：%@",number];
    NSMutableAttributedString *orderString = [[NSMutableAttributedString alloc] initWithString:numberStr];
    [orderString addAttribute:NSFontAttributeName
                        value:XKRegularFont(12)
                        range:NSMakeRange(5, numberStr.length - 5)];
    _orderNoLabel.attributedText = orderString;
    
    NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(model.createDate).stringValue];
    NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",time];
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeString addAttribute:NSFontAttributeName
                       value:XKRegularFont(12)
                       range:NSMakeRange(5, timeStr.length - 5)];
    [timeString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0x555555)
                       range:NSMakeRange(5, timeStr.length - 5)];
    _orderTimeLabel.attributedText = timeString;
    
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
    NSString *type = [NSString stringWithFormat:@"%@  ¥ %.2f",payType,model.amountInfo.payMoney];
    NSString *typeStr = [NSString stringWithFormat:@"支付方式：%@",type];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:typeStr];
    [attrString addAttribute:NSFontAttributeName
                       value:XKRegularFont(12)
                       range:NSMakeRange(5, typeStr.length - 5)];
    _payWayLabel.attributedText = attrString;
    
    
    NSString *payTime = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(model.payTime).stringValue];
    NSString *payTimeStr = [NSString stringWithFormat:@"支付时间：%@",payTime];
    NSMutableAttributedString *payTimeAttrString = [[NSMutableAttributedString alloc] initWithString:payTimeStr];
    [payTimeAttrString addAttribute:NSFontAttributeName
                              value:XKRegularFont(12)
                              range:NSMakeRange(5, payTimeStr.length - 5)];
    _payTimeLabel.attributedText = payTimeAttrString;
    
    NSArray *nameArr = @[@"小可自营物流",@"顺丰",@"韵达",@"中通",@"申通",@"圆通",@"百世汇通",@"用户自行配送"];
    NSArray *valueArr = @[@"XK",@"SF",@"YD",@"ZT",@"ST",@"YT",@"BSHT",@"HIMSELF"];
    NSInteger index = [valueArr indexOfObject:model.logisticsName];
    NSString *transport = nameArr[index];
    NSString *transportStr = [NSString stringWithFormat:@"物流公司：%@   %@",transport,model.logisticsNo];
    NSMutableAttributedString *transportAttrString = [[NSMutableAttributedString alloc] initWithString:transportStr];
    [transportAttrString addAttribute:NSFontAttributeName
                                value:XKRegularFont(12)
                                range:NSMakeRange(5, transportStr.length - 5)];
    _transportCompanyLabel.attributedText = transportAttrString;
    
    NSString *postTime = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:model.shippingTime];
    NSString *postTimeStr = [NSString stringWithFormat:@"发货时间：%@",postTime];
    NSMutableAttributedString *postTimeAttrString = [[NSMutableAttributedString alloc] initWithString:postTimeStr];
    [postTimeAttrString addAttribute:NSFontAttributeName
                               value:XKRegularFont(12)
                               range:NSMakeRange(5, postTimeStr.length - 5)];
    _transportTimeLabel.attributedText = postTimeAttrString;
    
    NSString *receiveTime = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(model.receivceDate).stringValue];
    NSString *receiveTimeStr = [NSString stringWithFormat:@"收货时间：%@",receiveTime];
    NSMutableAttributedString *recekiveAttrString = [[NSMutableAttributedString alloc] initWithString:receiveTimeStr];
    [recekiveAttrString addAttribute:NSFontAttributeName
                       value:XKRegularFont(12)
                       range:NSMakeRange(5, receiveTimeStr.length - 5)];
    _acceptTimeLabel.attributedText = recekiveAttrString;
    
    NSString *ticketType = nil;
    if ([model.invoiceInfo.invoiceType isEqualToString:@"PERSONAL"]) {
        ticketType = @"个人";
    } else  if ([model.invoiceInfo.invoiceType isEqualToString:@"ENTERPRISE"]) {
        ticketType = @"企业发票";
    }
    NSString *ticketTypeStr = [NSString stringWithFormat:@"发票类型：%@",ticketType ?:@""];
    NSMutableAttributedString *ticketAttrString = [[NSMutableAttributedString alloc] initWithString:ticketTypeStr];
    [ticketAttrString addAttribute:NSFontAttributeName
                             value:XKRegularFont(12)
                             range:NSMakeRange(5, ticketTypeStr.length - 5)];
    _ticketTypeLabel.attributedText = ticketAttrString;
    
    NSString *header = model.invoiceInfo.head;
    NSString *headerStr = [NSString stringWithFormat:@"发票抬头：%@",header ?:@""];
    NSMutableAttributedString *headerString = [[NSMutableAttributedString alloc] initWithString:headerStr];
    [headerString addAttribute:NSFontAttributeName
                         value:XKRegularFont(12)
                         range:NSMakeRange(5, headerStr.length - 5)];
    _ticketHeaderLabel.attributedText = headerString;
    
    NSString *content = model.invoiceInfo.invoiceContent;
    NSString *contentStr = [NSString stringWithFormat:@"发票内容：%@",content ?:@""];
    NSMutableAttributedString *detailString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [detailString addAttribute:NSFontAttributeName
                         value:XKRegularFont(12)
                         range:NSMakeRange(5, contentStr.length - 5)];
    _ticketContentLabel.attributedText = detailString;
    
    
    NSString *total = [NSString stringWithFormat:@"¥ %.2f",model.amountInfo.goodsMoney / 100];
    NSString *post = [NSString stringWithFormat:@"¥ %.2f",model.amountInfo.postFee / 100];
    NSString *discount = [NSString stringWithFormat:@"- ¥ %f",model.amountInfo.discountMoney / 100];
    [_bottomRightLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(13);
        confer.text(total).textColor(HEX_RGB(0x555555)).font(XKRegularFont(12));
        confer.text(@"\n");
        confer.text(post).textColor(HEX_RGB(0x555555)).font(XKRegularFont(12));
        confer.text(@"\n");
        confer.text(discount).textColor(HEX_RGB(0x555555)).font(XKRegularFont(12));
    }];
}

- (void)addUIConstraint {
    [self.bottomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.bottomRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomLeftLabel.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.bottomLeftLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.topLineView.mas_bottom).offset(10);
    }];
    
    [self.orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset(5);
    }];
    
    [self.midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.orderTimeLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    [self.payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.midLineView.mas_bottom).offset(10);
    }];
    
    [self.payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.payWayLabel.mas_bottom).offset(5);
    }];
    
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.payTimeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.transportCompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.centerLineView.mas_bottom).offset(10);
    }];
    
    [self.transportTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.transportCompanyLabel.mas_bottom).offset(5);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.transportTimeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.acceptTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(5);
    }];
    
    [self.lastLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.acceptTimeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.ticketTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.lastLineView.mas_bottom).offset(10);
    }];
    
    [self.ticketHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.ticketTypeLabel.mas_bottom).offset(5);
    }];
    
    [self.ticketContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.ticketHeaderLabel.mas_bottom).offset(5);
    }];
    
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
}

- (void)downLoadBtnCLick:(UIButton *)sender {
    PhotoPreviewModel *model = [[PhotoPreviewModel alloc] init];
    model.imageURL = _model.invoiceInfo.electInvoice;
    
    BigPhotoPreviewBaseController *photoPreviewController = [[BigPhotoPreviewBaseController alloc] init];
    photoPreviewController.models = @[model].mutableCopy;
    photoPreviewController.isSupportLongPress = NO;
    photoPreviewController.isShowNav = YES;
    photoPreviewController.isShowTitle = YES;
    photoPreviewController.strNavTitle = @"发票详情";
    photoPreviewController.isShowStatusBar = YES;
    photoPreviewController.isHiddenIndex = YES;
    photoPreviewController.navColor = XKMainTypeColor;
    photoPreviewController.isSave = YES;
    [[self getCurrentUIVC] presentViewController:photoPreviewController animated:YES completion:nil];
}

- (UILabel *)orderNoLabel {
    if(!_orderNoLabel) {
        _orderNoLabel = [[UILabel alloc] init];
        _orderNoLabel.font = XKRegularFont(14);
        _orderNoLabel.textColor = UIColorFromRGB(0x555555);
        
        NSString *number = @"12884G34598";
        NSString *numberStr = [NSString stringWithFormat:@"订单编号：%@",number];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:numberStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, numberStr.length - 5)];
        _orderNoLabel.attributedText = attrString;
    }
    return _orderNoLabel;
}

- (UILabel *)orderTimeLabel {
    if(!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] init];
        _orderTimeLabel.font = XKRegularFont(14);
        _orderTimeLabel.textColor = UIColorFromRGB(0x555555);
        
        NSString *time = @"2018-07-23 13:22:03";
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",time];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:timeStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, timeStr.length - 5)];
        _orderTimeLabel.attributedText = attrString;
    }
    return _orderTimeLabel;
}

- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _topLineView;
}

- (UILabel *)payWayLabel {
    if(!_payWayLabel) {
        _payWayLabel = [[UILabel alloc] init];
        _payWayLabel.font = XKRegularFont(14);
        _payWayLabel.textColor = UIColorFromRGB(0x555555);
        
        NSString *type = @"微信支付  ¥ 246";
        NSString *typeStr = [NSString stringWithFormat:@"支付方式：%@",type];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:typeStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, typeStr.length - 5)];
        _payWayLabel.attributedText = attrString;
    }
    return _payWayLabel;
}

- (UILabel *)payTimeLabel {
    if(!_payTimeLabel) {
        _payTimeLabel = [[UILabel alloc] init];
        _payTimeLabel.font = XKRegularFont(14);
        _payTimeLabel.textColor = UIColorFromRGB(0x555555);

    }
    return _payTimeLabel;
}


- (UIView *)centerLineView {
    if(!_centerLineView) {
        _centerLineView = [[UIView alloc] init];
        _centerLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _centerLineView;
}

- (UILabel *)transportCompanyLabel {
    if(!_transportCompanyLabel) {
        _transportCompanyLabel = [[UILabel alloc] init];
        _transportCompanyLabel.font = XKRegularFont(14);
        _transportCompanyLabel.textColor = UIColorFromRGB(0x555555);

    }
    return _transportCompanyLabel;
}

- (UILabel *)transportTimeLabel {
    if(!_transportTimeLabel) {
        _transportTimeLabel = [[UILabel alloc] init];
        _transportTimeLabel.font = XKRegularFont(14);
        _transportTimeLabel.textColor = UIColorFromRGB(0x555555);
        

    }
    return _transportTimeLabel;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomLineView;
}

- (UILabel *)acceptTimeLabel {
    if(!_acceptTimeLabel) {
        _acceptTimeLabel = [[UILabel alloc] init];
        _acceptTimeLabel.font = XKRegularFont(14);
        _acceptTimeLabel.textColor = UIColorFromRGB(0x555555);
        

    }
    return _acceptTimeLabel;
}

- (UIView *)lastLineView {
    if(!_lastLineView) {
        _lastLineView = [[UIView alloc] init];
        _lastLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lastLineView;
}

- (UILabel *)ticketTypeLabel {
    if(!_ticketTypeLabel) {
        _ticketTypeLabel = [[UILabel alloc] init];
        _ticketTypeLabel.font = XKRegularFont(14);
        _ticketTypeLabel.textColor = UIColorFromRGB(0x555555);
        
        NSString *type = @"电子普通发票";
        NSString *typeStr = [NSString stringWithFormat:@"发票类型：%@",type ?:@""];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:typeStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, typeStr.length - 5)];
        _ticketTypeLabel.attributedText = attrString;
    }
    return _ticketTypeLabel;
}

- (UILabel *)ticketHeaderLabel {
    if(!_ticketHeaderLabel) {
        _ticketHeaderLabel = [[UILabel alloc] init];
        _ticketHeaderLabel.font = XKRegularFont(14);
        _ticketHeaderLabel.textColor = UIColorFromRGB(0x555555);
        
        NSString *header = @"个人";
        NSString *headerStr = [NSString stringWithFormat:@"发票抬头：%@",header ?:@""];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:headerStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, headerStr.length - 5)];
        _ticketHeaderLabel.attributedText = attrString;
    }
    return _ticketHeaderLabel;
}

- (UILabel *)ticketContentLabel {
    if(!_ticketContentLabel) {
        _ticketContentLabel = [[UILabel alloc] init];
        _ticketContentLabel.font = XKRegularFont(14);
        _ticketContentLabel.textColor = UIColorFromRGB(0x555555);
        
        NSString *content = @"商品明细";
        NSString *contentStr = [NSString stringWithFormat:@"发票内容：%@",content ?:@""];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [attrString addAttribute:NSFontAttributeName
                           value:XKRegularFont(12)
                           range:NSMakeRange(5, contentStr.length - 5)];
        _ticketContentLabel.attributedText = attrString;
    }
    return _ticketContentLabel;
}

- (UIButton *)downLoadBtn {
    if(!_downLoadBtn) {
        _downLoadBtn = [[UIButton alloc] init];
        _downLoadBtn.layer.cornerRadius = 10.f;
        _downLoadBtn.layer.masksToBounds = YES;
        [_downLoadBtn setBackgroundColor:XKMainTypeColor];
        [_downLoadBtn setTitle:@"下载发票" forState:0];
        _downLoadBtn.titleLabel.font = XKRegularFont(12);
        [_downLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_downLoadBtn addTarget:self action:@selector(downLoadBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}


- (UILabel *)bottomLeftLabel {
    if(!_bottomLeftLabel) {
        _bottomLeftLabel = [[UILabel alloc] init];
        _bottomLeftLabel.font = XKRegularFont(14);
        _bottomLeftLabel.textColor = UIColorFromRGB(0x555555);
        _bottomLeftLabel.textAlignment = NSTextAlignmentRight;
        _bottomLeftLabel.numberOfLines = 0;
        
        NSString *content = @"商品总额：\n运费      ：\n优惠促销：";
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
        _bottomLeftLabel.attributedText = contentString;
    }
    return _bottomLeftLabel;
}

- (UILabel *)bottomRightLabel {
    if(!_bottomRightLabel) {
        _bottomRightLabel = [[UILabel alloc] init];
        _bottomRightLabel.font = XKRegularFont(12);
        _bottomRightLabel.numberOfLines = 0;
        _bottomRightLabel.textColor = UIColorFromRGB(0x555555);
        
    }
    return _bottomRightLabel;
}

- (UIView *)midLineView {
    if(!_midLineView) {
        _midLineView = [[UIView alloc] init];
        _midLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _midLineView;
}
@end
