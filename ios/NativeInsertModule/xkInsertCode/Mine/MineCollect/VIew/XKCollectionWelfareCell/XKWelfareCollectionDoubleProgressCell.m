//
//  XKWelfareCollectionDoubleProgressCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareCollectionDoubleProgressCell.h"
#import "XKWelfareProgressView.h"

@interface XKWelfareCollectionDoubleProgressCell ()
@property (nonatomic, strong) UIView  *progressBgView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIProgressView *joinProgress;
@property (nonatomic, strong) XKWelfareProgressView *progressNumberView;
@end
@implementation XKWelfareCollectionDoubleProgressCell
-(void)createUI {
    [super createUI];
    [self addCustomSuviews];
}
- (void)addCustomSuviews {
    [self.bgContainView addSubview:self.progressBgView];
    [self.progressBgView addSubview:self.progressLabel];
    [self.progressBgView addSubview:self.joinProgress];
    [self.progressBgView addSubview:self.progressNumberView];
    [self layout];
}
- (void)setModel:(XKCollectWelfareDataItem *)model {
    [super setModel:model];
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
        make.height.mas_equalTo(16);
        make.left.equalTo(self.joinProgress.mas_left).offset(width * self.joinProgress.progress - offset);
    }];
}

- (void)layout {
    [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgContainView);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(28);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressBgView.mas_left).offset(10);
        make.centerY.equalTo(self.progressBgView.mas_centerY);
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
@end
