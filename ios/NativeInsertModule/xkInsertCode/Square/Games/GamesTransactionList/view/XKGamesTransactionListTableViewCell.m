//
//  XKGamesTransactionListTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGamesTransactionListTableViewCell.h"


@interface XKGamesTransactionListTableViewCell ()

@property (nonatomic, copy  ) UILabel           *nameLabel;
@property (nonatomic, copy  ) UILabel           *timeLabel;
@property (nonatomic, copy  ) UILabel           *typeLabel;
@property (nonatomic, copy  ) UILabel           *yuELabel;
@property (nonatomic, copy  ) UILabel           *priceLabel;
@property (nonatomic, strong) UIView            *lineView;


@end


@implementation XKGamesTransactionListTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
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


- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


- (void)initViews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.yuELabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.lineView];
    
}



- (void)layoutViews {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.yuELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right);
        make.centerY.equalTo(self.typeLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.typeLabel);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"现金购买";
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x222222);
    }
    return _nameLabel;
    
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"2018-12-09";
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _timeLabel.textColor = HEX_RGB(0x999999);
    }
    return _timeLabel;
    
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.text = @"XXX币余额：";
        _typeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _typeLabel.textColor = HEX_RGB(0x777777);
    }
    return _typeLabel;
}

- (UILabel *)yuELabel {
    if (!_yuELabel) {
        _yuELabel = [[UILabel alloc] init];
        _yuELabel.textAlignment = NSTextAlignmentLeft;
        _yuELabel.text = @"238";
        _yuELabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _yuELabel.textColor = HEX_RGB(0xEE6161);
    }
    return _yuELabel;
}


- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.text = @"-200.00";
        _priceLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _priceLabel.textColor = XKMainTypeColor;
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




