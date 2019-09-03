//
//  XKMallOrderTraceViewTopCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderTraceViewTopCell.h"
#import "UIView+XKCornerRadius.h"
@interface XKMallOrderTraceViewTopCell ()
@property (nonatomic, strong)UILabel *transportCompanyLabel;
@property (nonatomic, strong)UILabel *transportOrderLabel;
@property (nonatomic, strong)UILabel *orderLabel;
@end

@implementation XKMallOrderTraceViewTopCell


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
    [self.contentView addSubview:self.transportCompanyLabel];
    [self.contentView addSubview:self.transportOrderLabel];
    [self.contentView addSubview:self.orderLabel];
    
}

- (void)bindModel:(XKOrderTransportInfoModel *)model withOrderId:(NSString *)orderId {
    
    NSArray *nameArr = @[@"小可自营物流",@"顺丰",@"韵达",@"中通",@"申通",@"圆通",@"百世汇通",@"用户自行配送"];
    NSArray *valueArr = @[@"XK",@"SF",@"YD",@"ZT",@"ST",@"YT",@"BSHT",@"HIMSELF"];
    NSInteger index = [valueArr indexOfObject:model.companyName];
    NSString *companyName = nameArr[index];
    NSString *companyNameStr = [NSString stringWithFormat:@"物流公司：%@",companyName];
    NSMutableAttributedString *companyNameStrAttrString = [[NSMutableAttributedString alloc] initWithString:companyNameStr];
    [companyNameStrAttrString addAttribute:NSFontAttributeName
                       value:XKRegularFont(14)
                       range:NSMakeRange(5, companyNameStr.length - 5)];
    _transportCompanyLabel.attributedText = companyNameStrAttrString;
    
    NSString *numberStr = [NSString stringWithFormat:@"订单编号：%@",orderId];
    NSMutableAttributedString *numberStrAttrString = [[NSMutableAttributedString alloc] initWithString:numberStr];
    [numberStrAttrString addAttribute:NSFontAttributeName
                       value:XKRegularFont(14)
                       range:NSMakeRange(5, numberStr.length - 5)];
    _orderLabel.attributedText = numberStrAttrString;
    
  
    NSString *transportStr = [NSString stringWithFormat:@"快递单号：%@",model.number];
    NSMutableAttributedString *transportStrAttrString = [[NSMutableAttributedString alloc] initWithString:transportStr];
    [transportStrAttrString addAttribute:NSFontAttributeName
                       value:XKRegularFont(14)
                       range:NSMakeRange(5, transportStr.length - 5)];
    _transportOrderLabel.attributedText = transportStrAttrString;
}

- (void)addUIConstraint {
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.transportCompanyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.orderLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.transportOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.transportCompanyLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];


}

- (UILabel *)transportCompanyLabel {
    if(!_transportCompanyLabel) {
        _transportCompanyLabel = [[UILabel alloc] init];
        _transportCompanyLabel.font = XKRegularFont(14);
        _transportCompanyLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _transportCompanyLabel;
}

- (UILabel *)transportOrderLabel {
    if(!_transportOrderLabel) {
        _transportOrderLabel = [[UILabel alloc] init];
        _transportOrderLabel.font = XKRegularFont(14);
        _transportOrderLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _transportOrderLabel;
}

- (UILabel *)orderLabel {
    if(!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.font = XKRegularFont(14);
        _orderLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _orderLabel;
}

@end
