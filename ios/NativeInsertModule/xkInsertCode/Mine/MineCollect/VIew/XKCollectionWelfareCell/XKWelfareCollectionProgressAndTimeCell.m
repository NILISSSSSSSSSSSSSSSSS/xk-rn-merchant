//
//  XKWelfareCollectionProgressAndTimeCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareCollectionProgressAndTimeCell.h"
#import "XKWelfareProgressView.h"

@interface XKWelfareCollectionProgressAndTimeCell ()
@property (nonatomic, strong) UIView  *infoBgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIProgressView *joinProgress;
@property (nonatomic, strong) XKWelfareProgressView *progressNumberView;
@end

@implementation XKWelfareCollectionProgressAndTimeCell
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
    [self.myContentView addSubview:self.infoBgView];
    [self.infoBgView addSubview:self.timeLabel];
    [self.infoBgView addSubview:self.progressLabel];
    [self.infoBgView addSubview:self.joinProgress];
    [self.infoBgView addSubview:self.progressNumberView];
}
- (void)layout {
    [self.infoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10 * ScreenScale);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5 * ScreenScale);
        make.height.mas_equalTo(55 * ScreenScale);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView.mas_left).offset(10 * ScreenScale);
        make.right.equalTo(self.infoBgView.mas_right).offset(-10 * ScreenScale);
        make.bottom.equalTo(self.infoBgView.mas_bottom).offset(-10 * ScreenScale);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBgView.mas_left).offset(10 * ScreenScale);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-5 * ScreenScale);
    }];
    
    [self.joinProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.left.equalTo(self.progressLabel.mas_right).offset(5 * ScreenScale);
        make.right.equalTo(self.infoBgView.mas_right).offset(-15 * ScreenScale);
        make.height.mas_equalTo(6 * ScreenScale);
    }];
    
    [self.progressNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLabel);
        make.height.mas_equalTo(16 * ScreenScale);
        make.left.equalTo(self.joinProgress.mas_left).offset(self.joinProgress.width * self.joinProgress.progress);
    }];
    
    [self layoutIfNeeded];
}


- (UIView *)infoBgView {
    if (!_infoBgView) {
        _infoBgView = [UIView new];
        _infoBgView.backgroundColor = UIColorFromRGB(0xF0F6FF);
        _infoBgView.layer.cornerRadius = 3.f;
    }
    return _infoBgView;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:XKRegularFont(12)];
        _timeLabel.textColor = UIColorFromRGB(0x777777);
        _timeLabel.backgroundColor = UIColorFromRGB(0xF0F6FF);
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
