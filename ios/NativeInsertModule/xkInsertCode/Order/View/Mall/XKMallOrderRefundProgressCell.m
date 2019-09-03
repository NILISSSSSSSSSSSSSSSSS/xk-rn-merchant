//
//  XKMallOrderRefundProgressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderRefundProgressCell.h"

@interface XKMallOrderRefundProgressCell ()
@property (nonatomic, strong)UIView *cycleView;
@property (nonatomic, strong)UIView *topLineView;
@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation XKMallOrderRefundProgressCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.cycleView];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.timeLabel];
}

- (void)addUIConstraint {
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(11);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(2);
        make.left.equalTo(self.cycleView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.cycleView.mas_bottom);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)bindDataWithModel:(XKMallRefundLogListItem *)model isFirst:(BOOL)isFirst isLast:(BOOL)isLast {
    self.statusLabel.text = model.refundInfo;
    self.timeLabel.text = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(model.createTime).stringValue];
    if(isFirst) {
        if(isLast) {
            [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.top.equalTo(self.cycleView.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        } else {
            [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.top.equalTo(self.cycleView.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
        }
        _statusLabel.textColor = UIColorFromRGB(0x222222);
        _topLineView.alpha = 0;

    } else {
        _statusLabel.textColor = UIColorFromRGB(0x999999);
        _topLineView.alpha = 1;
        if(isLast) {
            [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.top.equalTo(self.cycleView.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            }];
        } else {
            [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(15);
                make.top.equalTo(self.cycleView.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom);
            }];
        }
    }
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = XKRegularFont(12);
        _statusLabel.textColor = UIColorFromRGB(0x999999);
        _statusLabel.text = @"您的退款申请已提交您的退款申请已提交您的退款申请已提交您的退款申请已提交";
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = XKRegularFont(12);
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel.text = @"2018-07-23 13:22:03";
    }
    return _timeLabel;
}

- (UIView *)cycleView {
    if(!_cycleView) {
        _cycleView = [[UIView alloc] init];
        _cycleView.layer.cornerRadius = 4.f;
        _cycleView.layer.masksToBounds = YES;
        _cycleView.backgroundColor = XKMainTypeColor;
    }
    return _cycleView;
}

- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = UIColorFromRGB(0xd8d8d8);
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xd8d8d8);
    }
    return _bottomLineView;
}

@end
