//
//  XKWelfareOrderDetailFinishCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailFinishCell.h"

@interface XKWelfareOrderDetailFinishCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *numberLabel;
@end

@implementation XKWelfareOrderDetailFinishCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.numberLabel];
}

- (void)handleDataWithItem:(XKWelfareFinishDetailDataItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.avatar] placeholderImage:kDefaultHeadImg];
    self.countLabel .text = item.nickname;
    NSString *number = @(item.lotteryNumbers.count).stringValue;
    NSString *numberStr = [NSString stringWithFormat:@"购买注数：%@",number];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:numberStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(5, numberStr.length - 5)];
    _countLabel.attributedText = attrString;
    
    
    NSString *num = @"";
    for (XKWelfareOrderNumberItem * numbers in item.lotteryNumbers) {
        num =  [num stringByAppendingString:[NSString stringWithFormat:@"编号：%@",numbers.lotteryNumber]];
        num =  [num stringByAppendingString:@"\n"];
    }
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:num];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
    self.numberLabel.attributedText = contentString;
    
    if (item.lotteryNumbers.count < 2) {
        [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
        
        [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.countLabel.mas_bottom).offset(10);
            make.left.equalTo(self.iconImgView.mas_right).offset(10);
            
        }];
    } else {
        [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
           
        }];
        
        [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.countLabel.mas_bottom).offset(10);
            make.left.equalTo(self.iconImgView.mas_right).offset(10);
            make.bottom.equalTo(self.contentView).offset(-15);
            
        }];
    }
    
    
}

- (void)addUIConstraint {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(self.contentView).offset(-15);
    }];

    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.top.equalTo(self.iconImgView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.iconImgView.mas_top);
       
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.countLabel.mas_bottom).offset(10);
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
     
    }];
    
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 3.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _countLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _countLabel;
}

- (UILabel *)numberLabel {
    if(!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _numberLabel.textColor = UIColorFromRGB(0x222222);
        _numberLabel.numberOfLines = 0;
        _numberLabel.backgroundColor = [UIColor redColor];
    }
    return _numberLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10]];
        _timeLabel.textColor = UIColorFromRGB(0x222222);
        _timeLabel.numberOfLines = 2;
        _timeLabel.text = @"时间: 2018-09-09";
    }
    return _timeLabel;
}

@end
