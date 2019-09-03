//
//  XKWelfareCollectionTimeCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareCollectionTimeCell.h"
@interface XKWelfareCollectionTimeCell ()
@property (nonatomic, strong) UIView  *timeBgView;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation XKWelfareCollectionTimeCell

- (void)setModel:(XKCollectWelfareDataItem *)model {
    [super setModel:model];
    NSString *time = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:model.target.expectDrawTime];
    NSString *timeStr = [NSString stringWithFormat:@"时间：%@",time];
    NSMutableAttributedString *timeAttrString = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeAttrString addAttribute:NSForegroundColorAttributeName
                           value:XKMainTypeColor
                           range:NSMakeRange(3, timeStr.length - 3)];
    _timeLabel.attributedText = timeAttrString;
}
- (void)createUI {
    [super createUI];
    [self addCustomSuviews];
    [self layout];
}

- (void)addCustomSuviews {
    [self.myContentView addSubview:self.timeBgView];
    [self.timeBgView addSubview:self.timeLabel];
}

- (void)layout {
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5 * ScreenScale );
        make.height.mas_equalTo(30 * ScreenScale);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBgView.mas_left).offset(10 * ScreenScale);
        make.right.equalTo(self.timeBgView.mas_right).offset(-10 * ScreenScale);
        make.centerY.equalTo(self.timeBgView.mas_centerY);
    }];
    
}

- (UIView *)timeBgView {
    if (!_timeBgView) {
        _timeBgView = [UIView new];
        _timeBgView.backgroundColor = UIColorFromRGB(0xF0F6FF);
        _timeBgView.layer.cornerRadius = 3.f;
    }
    return _timeBgView;
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
@end
