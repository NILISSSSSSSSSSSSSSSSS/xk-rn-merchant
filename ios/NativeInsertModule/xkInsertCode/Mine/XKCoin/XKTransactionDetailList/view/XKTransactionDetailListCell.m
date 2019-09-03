//
//  XKTransactionDetailListCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTransactionDetailListCell.h"
#import "XKTransactionDetailModel.h"

@interface XKTransactionDetailListCell ()


@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *decLabel;
@property (nonatomic, strong) UILabel           *timeLabel;
@property (nonatomic, strong) UILabel           *priceLabel;
@property (nonatomic, strong) UIView            *segmentationView;
@property (nonatomic, strong) UIView            *lineView;

@end

@implementation XKTransactionDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.decLabel];
    [self.contentView addSubview:self.segmentationView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


- (void)layoutViews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(12);
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
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.nameLabel).offset(5);
        make.width.mas_greaterThanOrEqualTo(@100);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

- (void)setVaules:(XKTransactionDetailModel *)model {
    
    self.nameLabel.text = model.title;
    self.decLabel.text = model.dec;
    self.timeLabel.text = model.time;
    if (model.add.integerValue) {
        self.priceLabel.textColor = HEX_RGB(0xEE6161);
        self.priceLabel.text = [NSString stringWithFormat:@"+%@",model.price];
    } else {
        self.priceLabel.textColor = HEX_RGB(0x222222);
        self.priceLabel.text = [NSString stringWithFormat:@"-%@",model.price];
    }
}

#pragma mark - Setter

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
