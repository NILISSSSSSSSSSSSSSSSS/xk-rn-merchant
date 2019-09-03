//
//  XKOrderDetailOrderInfoTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOrderDetailOrderInfoTableViewCell.h"

@interface XKOrderDetailOrderInfoTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;

@end

@implementation XKOrderDetailOrderInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLabel];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.nameLabel.mas_top);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
    }];
    
}


- (void)setValueWithDic:(NSDictionary *)dic {
    
    if (self.cellType == OrderInfoCellType_goodsInfo) {
        self.nameLabel.textColor = HEX_RGB(0x555555);
        [self.nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.alignment(NSTextAlignmentLeft).lineSpacing(10);
            confer.text(@"小包（4~5人）");
            confer.text(@"\n");
            confer.text(@"今天（09-11）13:00-17:00 共5小时");
            confer.text(@"\n");
            confer.text(@"套餐数量：7");
            confer.text(@"\n");
            confer.text(@"订单总额：");
            confer.text(@"￥998").textColor(HEX_RGB(0xEE6161));
        }];
        
    } else if (self.cellType == OrderInfoCellType_orderInfo) {
        
        self.nameLabel.textColor = HEX_RGB(0x777777);
        NSString *content = @"手机号\n备注\n订单编号\n下单时间";
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
        self.nameLabel.attributedText = contentString;
        
        
        [self.decLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.paragraphStyle.alignment(NSTextAlignmentRight).lineSpacing(10);
            confer.text(@"1352667587");
            confer.text(@"\n");
            confer.text(@"未填写");
            confer.text(@"\n");
            confer.text(@"1244 33333 4444 4442 77");
            confer.text(@"\n");
            confer.text(@"2018-12-22 13:23");
        }];
    }
    
}

#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x777777);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.numberOfLines = 0;
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _decLabel.textColor = HEX_RGB(0x555555);
        _decLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _decLabel;
}

@end
