//
//  XKMessageSysAndPraiseCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/19.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMessageSysAndPraiseCell.h"

@interface XKMessageSysAndPraiseCell()
/**背景视图*/
@property(nonatomic, strong) UIView *bigContentView;
/**描述视图*/
@property(nonatomic, strong) UILabel *desLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**红点*/
@property(nonatomic, strong) UIView *redPoint;
@end
@implementation XKMessageSysAndPraiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self creatUI];
        [self layout];
    }
    return self;
}

- (void)setModel:(XKSysDetailMessageModelDataItem *)model {
    _model = model;
    _desLabel.text = model.msgContent;
    _timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimestampString:model.createdAt];
    if (model.isRead == 1) {
        _redPoint.hidden = YES;
    }else {
        _redPoint.hidden = NO;
    }
}

- (void)creatUI {
    [self.contentView addSubview:self.bigContentView];
    
    [self.bigContentView addSubview:self.redPoint];
    [self.bigContentView addSubview:self.desLabel];
    [self.bigContentView addSubview:self.timeLabel];
}
- (void)layout {
    
    [self.bigContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.contentView);
    }];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.bigContentView);
        make.height.width.mas_equalTo(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
    }];
}


- (UIView *)bigContentView {
    if (!_bigContentView) {
        _bigContentView = [[UIView alloc]init];
        _bigContentView.backgroundColor = [UIColor whiteColor];
        _bigContentView.xk_openClip = YES;
        _bigContentView.xk_radius = 5;
        _bigContentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _bigContentView;
}


- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.textColor = HEX_RGB(0x222222);
        _desLabel.font = XKRegularFont(14);
        _desLabel.numberOfLines = 2;
    }
    return _desLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel ) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = XKRegularFont(14);
        _timeLabel.textColor = HEX_RGB(0xBBBBBB);
        _timeLabel.text = @"刚刚";
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [[UIView alloc]init];
        _redPoint.backgroundColor = XKMainRedColor;
        _redPoint.hidden = YES;
        _redPoint.xk_openClip = YES;
        _redPoint.xk_radius = 5;
        _redPoint.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _redPoint;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end
