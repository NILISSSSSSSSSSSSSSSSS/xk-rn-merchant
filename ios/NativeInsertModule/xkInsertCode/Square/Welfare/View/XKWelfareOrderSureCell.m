//
//  XKWelfareOrderSureCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderSureCell.h"
#import "XKWelfareBuyCarSumView.h"
#import "XKWelfareProgressView.h"
@interface XKWelfareOrderSureCell ()
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)UIProgressView *joinProgress;
@property (nonatomic, strong)XKWelfareProgressView *progressNumberView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *pointLabel;
@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, strong)UIView *segmengView;
@end

@implementation XKWelfareOrderSureCell
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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.progressLabel];
    [self.contentView addSubview:self.joinProgress];
    [self.contentView addSubview:self.progressNumberView];
    [self.contentView addSubview:self.pointLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.segmengView];
    [self.contentView addSubview:self.timeLabel];
}
- (void)handleData {
    _joinProgress.progress = 0.8;
    [self.progressNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress);
    }];
}
- (void)bindDataWithItem:(XKWelfareBuyCarItem *)item {
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.name;
    CGFloat progress = @(item.participateStake).floatValue/item.maxStake;
    self.joinProgress.progress = progress;
    NSString *progressText = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    self.progressNumberView.progressLabel.text = progressText;
    CGFloat textW = [progressText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH,MAXFRAG) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.width;
    CGFloat offset = progress == 1.f ? (textW + 10 ) : 0;
    [self.progressNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress - offset);
    }];
}

- (void)addUIConstraint {
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.width.mas_equalTo(80);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.joinProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.left.equalTo(self.progressLabel.mas_right).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(6);
    }];
    
    [self.progressNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress);
    }];
    
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.progressLabel.mas_bottom).offset(2);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.pointLabel.mas_bottom).offset(2);
    }];
    
    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(14);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
    }];
    
    self.timeLabel.hidden = YES;
    [self layoutIfNeeded];
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

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
        _nameLabel.text = @"这是一个测试用的标题名称 大家不要太在意这些东西";
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel.text = @"开奖时间：20:08分";
    }
    return _timeLabel;
}

- (UILabel *)numberLabel {
    if(!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _numberLabel.textColor = UIColorFromRGB(0x555555);
        _numberLabel.text = @"数量：1";
    }
    return _numberLabel;
}

- (UILabel *)progressLabel {
    if(!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        [_progressLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _progressLabel.textColor = UIColorFromRGB(0x555555);
        _progressLabel.text = @"进度：";
    }
    return _progressLabel;
}

- (UIProgressView *)joinProgress {
    if(!_joinProgress) {
        _joinProgress = [[UIProgressView alloc] init];
        _joinProgress.progressTintColor = XKMainTypeColor;
        _joinProgress.trackTintColor = UIColorFromRGB(0xe5e5e5);
        _joinProgress.layer.cornerRadius = 3.f;
        _joinProgress.layer.masksToBounds = YES;
        _joinProgress.progress = 0.5;
    }
    return _joinProgress;
}

- (XKWelfareProgressView *)progressNumberView {
    if(!_progressNumberView) {
        _progressNumberView = [[XKWelfareProgressView alloc] init];
    }
    return _progressNumberView;
}

- (UILabel *)pointLabel {
    if(!_pointLabel) {
        _pointLabel = [[UILabel alloc] init];
        [_pointLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _pointLabel.textColor = UIColorFromRGB(0x999999);
        NSString *point = @"1067";
        NSString *nameStr = [NSString stringWithFormat:@"积分：%@",point];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xee6161)
                           range:NSMakeRange(3, nameStr.length - 3)];
        _pointLabel.attributedText = attrString;
    }
    return _pointLabel;
}

- (UIView *)segmengView {
    if(!_segmengView) {
        _segmengView = [[UIView alloc] init];
        _segmengView.backgroundColor = XKSeparatorLineColor;
    }
    return _segmengView;
}


@end
