//
//  XKWelfareCollectionProgressOrTimeCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareCollectionProgressOrTimeCell.h"
#import "XKWelfareProgressView.h"

@interface XKWelfareCollectionProgressOrTimeCell ()
@property (nonatomic, strong) UIView  *timeBgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView  *progressBgView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIProgressView *joinProgress;
@property (nonatomic, strong) XKWelfareProgressView *progressNumberView;
@end
@implementation XKWelfareCollectionProgressOrTimeCell
- (void)createUI {
    [super createUI];
    [self addCustomSuviews];
    [self layout];
}

- (void)setModel:(XKCollectWelfareDataItem *)model {
    [super setModel:model];
    
    NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:model.target.expectDrawTime];
    NSString *timeStr = [NSString stringWithFormat:@"时间：%@",time];
    NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeAttrString addAttribute:NSForegroundColorAttributeName
                           value:XKMainTypeColor
                           range:NSMakeRange(3, timeStr.length - 3)];
    _timeLabel.attributedText = timeAttrString;
    
    CGFloat progress = @(model.target.joinCount).floatValue/model.target.maxStake;
    if(model.target.joinCount == 0) {
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
        make.height.mas_equalTo(16 * ScreenScale);
        make.left.equalTo(self.joinProgress.mas_left).offset(width * self.joinProgress.progress - offset);
    }];
}

- (void)addCustomSuviews {
    [self.myContentView addSubview:self.timeBgView];
    [self.timeBgView addSubview:self.timeLabel];
    
    [self.myContentView addSubview:self.progressBgView];
    [self.progressBgView addSubview:self.progressLabel];
    [self.progressBgView addSubview:self.joinProgress];
    [self.progressBgView addSubview:self.progressNumberView];
}

- (void)layout {
    
    [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10 * ScreenScale);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5 * ScreenScale);
        make.height.mas_equalTo(30 * ScreenScale);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressBgView.mas_left).offset(10 * ScreenScale);
        make.centerY.equalTo(self.progressBgView.mas_centerY);
    }];
    
    [self.joinProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.left.equalTo(self.progressLabel.mas_right).offset(5 * ScreenScale);
        make.right.equalTo(self.progressBgView.mas_right).offset(-15 * ScreenScale);
        make.height.mas_equalTo(6 * ScreenScale);
    }];
    
    [self.progressNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16 * ScreenScale);
        make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress);
    }];
    
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.progressBgView.mas_bottom).offset(2);
        make.height.mas_equalTo(30);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBgView.mas_left).offset(10);
        make.right.equalTo(self.timeBgView.mas_right).offset(-10);
        make.centerY.equalTo(self.timeBgView.mas_centerY);
    }];
    
    [self layoutIfNeeded];
}


- (UIView *)progressBgView {
    if (!_progressBgView) {
        _progressBgView = [UIView new];
        _progressBgView.backgroundColor = UIColorFromRGB(0xF0F6FF);
        _progressBgView.layer.cornerRadius = 3.f;
    }
    return _progressBgView;
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

@end
