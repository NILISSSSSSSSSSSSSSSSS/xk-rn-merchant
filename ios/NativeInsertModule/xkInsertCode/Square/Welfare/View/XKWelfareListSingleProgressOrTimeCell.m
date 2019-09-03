//
//  XKWelfareListSingleProgressOrTimeCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareListSingleProgressOrTimeCell.h"
#import "XKWelfareProgressView.h"
@interface XKWelfareListSingleProgressOrTimeCell ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView  *timeBgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView  *progressBgView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIProgressView *joinProgress;
@property (nonatomic, strong) XKWelfareProgressView *progressNumberView;
@end

@implementation XKWelfareListSingleProgressOrTimeCell

- (void)bindData:(WelfareDataItem *)item WithType:(NSInteger)layoutType {
    [super bindData:item WithType:layoutType];
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.mainUrl] placeholderImage:kDefaultPlaceHolderImg];
    self.nameLabel.text = item.goodsName;
    
    NSString *price = @(item.perPrice / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"消费券：%@",price];
    NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttrString addAttribute:NSForegroundColorAttributeName
                            value:UIColorFromRGB(0x222222)
                            range:NSMakeRange(4, priceStr.length - 4)];
    _priceLabel.attributedText = priceAttrString;
    
    NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:item.expectDrawTime];
    NSString *timeStr = [NSString stringWithFormat:@"时间：%@",time];
    NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeAttrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0xF5A623)
                           range:NSMakeRange(3, timeStr.length - 3)];
    _timeLabel.attributedText = timeAttrString;
    
    CGFloat progress = @(item.joinCount).floatValue/item.maxStake;
    if(item.joinCount == 0) {
        progress = 0.0;
    }
    self.joinProgress.progress = progress;
    NSString *progressText = [NSString stringWithFormat:@"%.0f%%",progress * 100];
    self.progressNumberView.progressLabel.text = progressText;
    CGFloat textW = [progressText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH,MAXFRAG) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.width;
    CGFloat offset = progress == 1.f ? (textW + 10 ) : textW / 2;
    CGFloat width = self.joinProgress.width;
    [self.progressNumberView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.joinProgress.mas_left).offset(width * self.joinProgress.progress - offset);
    }];
    
}

- (void)addCustomSuviews {
    [self.contentView addSubview:self.bgContainView];
    
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.priceLabel];
    [self.bgContainView addSubview:self.timeBgView];
    [self.timeBgView addSubview:self.timeLabel];
    
    [self.bgContainView addSubview:self.progressBgView];
    [self.progressBgView addSubview:self.progressLabel];
    [self.progressBgView addSubview:self.joinProgress];
    [self.progressBgView addSubview:self.progressNumberView];
    
}


- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.top.equalTo(self.bgContainView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
    }];
    
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.bgContainView.mas_bottom).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.timeBgView.mas_top).offset(-2);
        make.height.mas_equalTo(30);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBgView.mas_left).offset(10);
        make.right.equalTo(self.timeBgView.mas_right).offset(-10);
        make.centerY.equalTo(self.timeBgView.mas_centerY);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.progressBgView.mas_top).offset(-5);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressBgView.mas_left).offset(10);
        make.centerY.equalTo(self.progressBgView.mas_centerY);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-10);
    }];
    
    [self.joinProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.left.equalTo(self.progressLabel.mas_right).offset(5);
        make.right.equalTo(self.progressBgView.mas_right).offset(-15);
        make.height.mas_equalTo(6);
    }];
    
    [self.progressNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16);
        make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress);
    }];
    
    [self layoutIfNeeded];
    
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 3.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:XKRegularFont(14)];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:XKRegularFont(12)];
        _priceLabel.textColor = UIColorFromRGB(0x777777);
        
    }
    return _priceLabel;
}

- (UIView *)progressBgView {
    if (!_progressBgView) {
        _progressBgView = [UIView new];
        _progressBgView.backgroundColor = UIColorFromRGB(0xF0F6FF);
        _progressBgView.layer.cornerRadius = 3.f;
    }
    return _progressBgView;
}

- (UIView *)timeBgView {
    if (!_timeBgView) {
        _timeBgView = [UIView new];
        _timeBgView.backgroundColor = UIColorFromRGB(0xFFF4E1);
        _timeBgView.layer.cornerRadius = 3.f;
    }
    return _timeBgView;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:XKRegularFont(12)];
        _timeLabel.textColor = UIColorFromRGB(0x777777);
        
    }
    return _timeLabel;
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
        _progressNumberView.progressLabel.text = @"0%";
    }
    return _progressNumberView;
}
@end
