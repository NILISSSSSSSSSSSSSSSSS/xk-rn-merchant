//
//  XKConsumeCouponListTableViewCell.m
//  XKSquare
//
//  Created by william on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKConsumeCouponListTableViewCell.h"
#import "UIView+XKCornerRadius.h"
@interface XKConsumeCouponListTableViewCell()
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) UILabel           *priceLabel;
@property (nonatomic, strong) UIView            *segmentationView;
@property (nonatomic, strong) UIView            *lineView;
@end
@implementation XKConsumeCouponListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

-(void)initViews{
    [self addSubview:self.backWhiteView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.decLabel];
    [self addSubview:self.segmentationView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.lineView];
}

-(void)test{
    _nameLabel.text = @"猫爬架";
    _decLabel.text = @"购物劵返消费券";
    _timeLabel.text = @"2018-08-13";
    _priceLabel.text = @"10";
}

-(void)setDataModel:(XKConsumeCouponCellModel *)dataModel{
    _dataModel = dataModel;
    _nameLabel.text = _dataModel.goods;
    _decLabel.text = _dataModel.category;
    _timeLabel.text = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%ld",_dataModel.dateTime]];
    if ([dataModel.consumerCoupontype isEqualToString:@"pay"]) {
        _priceLabel.text = [NSString stringWithFormat:@"-%ld",_dataModel.Amount];
        _priceLabel.textColor = XKMainTypeColor;
    }
    else{
        _priceLabel.text = [NSString stringWithFormat:@"+%ld",_dataModel.Amount];
        _priceLabel.textColor = UIColorFromRGB(0xee6161);
    }
}

- (void)layoutViews {
    
    [self.backWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(10 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(-10 * ScreenScale);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_backWhiteView).offset(15 * ScreenScale);
        make.top.mas_equalTo(self->_backWhiteView.mas_top).offset(10 * ScreenScale);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    
    [self.segmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.decLabel.mas_right).offset(3);
        make.centerY.equalTo(self.decLabel);
        make.height.equalTo(@10);
        make.width.equalTo(@1);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentationView.mas_right).offset(3);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.decLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_backWhiteView).offset(-15 * ScreenScale);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(@100);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self->_backWhiteView);
        make.height.equalTo(@1);
    }];
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
    if (hidden) {
        _backWhiteView.xk_clipType = XKCornerClipTypeBottomBoth;
        [_backWhiteView setNeedsLayout];
        [_backWhiteView layoutIfNeeded];
    }
    else{
        _backWhiteView.xk_clipType = XKCornerClipTypeNone;
        [_backWhiteView setNeedsLayout];
        [_backWhiteView layoutIfNeeded];
    }
}
#pragma mark - Setter

-(UIView *)backWhiteView{
    if (!_backWhiteView) {
        _backWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20 * ScreenScale, self.frame.size.height)];
        _backWhiteView.backgroundColor = [UIColor whiteColor];
        _backWhiteView.xk_openClip = YES;
        _backWhiteView.xk_radius = 8;
        _backWhiteView.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    return _backWhiteView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [[UILabel alloc] init];
        _decLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLabel.textColor = HEX_RGB(0x999999);
        _decLabel.textAlignment = NSTextAlignmentRight;
    }
    return _decLabel;
}

- (UIView *)segmentationView {
    if (!_segmentationView) {
        _segmentationView = [[UIView alloc] init];
        _segmentationView.backgroundColor = XKSeparatorLineColor;
    }
    return _segmentationView;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _timeLabel.textColor = HEX_RGB(0x999999);
    }
    return _timeLabel;
}

- (UILabel *)priceLabel {
    
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
    }
    return _priceLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}
@end
