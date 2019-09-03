//
//  XKWelfareGoodsDetailNumberInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailNumberInfoCell.h"
@interface XKWelfareGoodsDetailNumberInfoCell ()
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UILabel  *numberLabel;
@end

@implementation XKWelfareGoodsDetailNumberInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model {
    NSString *number = @"";
    for (XKWelfareOrderNumberItem * item in model.lotteryNumbers) {
        number =  [number stringByAppendingString:[NSString stringWithFormat:@"兑奖编号：%@",item.lotteryNumber]];
        number =  [number stringByAppendingString:@"\n"];
    }
    self.countLabel.text = [NSString stringWithFormat:@"兑奖注数：%zd",model.lotteryNumbers.count];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:number];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
    self.numberLabel.attributedText = contentString;
    
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.numberLabel];
}

- (void)addUIConstraint {
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.countLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.lineView.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
    }];
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:17];
        _countLabel.textColor = XKMainTypeColor;
        _countLabel.text = @"兑奖注数：0";
    }
    return _countLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = UIColorFromRGB(0x555555);
        _numberLabel.numberOfLines = 0;
    }
    return _numberLabel;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}
@end
