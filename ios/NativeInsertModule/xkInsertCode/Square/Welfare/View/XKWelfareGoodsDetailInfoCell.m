//
//  XKWelfareGoodsDetailInfoCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailInfoCell.h"
#import "XKWelfareProgressView.h"
@interface XKWelfareGoodsDetailInfoCell ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *standerLabel;
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)UILabel *ticketLabel;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)UIProgressView *progressView;
@property (nonatomic, strong)XKWelfareProgressView *progressTipView;
@end

@implementation XKWelfareGoodsDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.standerLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.ticketLabel];
    [self.contentView addSubview:self.progressLabel];
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.progressTipView];
}

- (void)addUIConstraint {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.standerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.standerLabel.mas_bottom).offset(5);
    }];
    
    [self.ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).offset(50);
        make.top.equalTo(self.countLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.countLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressLabel.mas_right);
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(4);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.progressTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.progressView.mas_right).multipliedBy(self.progressView.progress);
    }];
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:16];
        _nameLabel.text = @"品男装长袖衬衫C品男装长袖衬衫C品男装长袖衬衫C品男装长袖衬衫C";
    }
    return _nameLabel;
}

- (UILabel *)standerLabel {
    if(!_standerLabel) {
        _standerLabel = [[UILabel alloc] init];
        _standerLabel.textColor = UIColorFromRGB(0x777777);
        _standerLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _standerLabel.text = @"规格参数：90 x 89";
    }
    return _standerLabel;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = UIColorFromRGB(0x777777);
        _countLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        NSString *count = @"90";
        NSString *countStr = [NSString stringWithFormat:@"本月开奖累计次数：%@",count];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:countStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(9, countStr.length - 9)];
        _countLabel.attributedText = attrString;
    }
    return _countLabel;
}

- (UILabel *)ticketLabel {
    if(!_ticketLabel) {
        _ticketLabel = [[UILabel alloc] init];
        _ticketLabel.textColor = UIColorFromRGB(0x777777);
        _ticketLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        NSString *count = @"890";
        NSString *countStr = [NSString stringWithFormat:@"代金券：%@",count];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:countStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(4, countStr.length - 4)];
        _ticketLabel.attributedText = attrString;
    }
    return _ticketLabel;
}

- (UILabel *)progressLabel {
    if(!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = UIColorFromRGB(0x777777);
        _progressLabel.font =  [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _progressLabel.text = @"本次开奖进度：";
    }
    return _progressLabel;
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = UIColorFromRGB(0xDFE2E6);
        _progressView.progressTintColor = XKMainTypeColor;
        _progressView.layer.cornerRadius = 2.f;
        _progressView.layer.masksToBounds = YES;
        _progressView.progress = 0.8;
    }
    return _progressView;
}


- (XKWelfareProgressView *)progressTipView {
    if(!_progressTipView) {
        _progressTipView = [[XKWelfareProgressView alloc] init];

    }
    return _progressTipView;
}
@end
