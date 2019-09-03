//
//  XKMallTypeTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallTypeTableViewCell.h"

@interface XKMallTypeTableViewCell ()

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIView            *indexView;

@end

@implementation XKMallTypeTableViewCell

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
        self.contentView.backgroundColor = HEX_RGB(0xf1f1f1);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.indexView];

}


- (void)layoutViews {
    
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.contentView);
        make.width.equalTo(@3);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@1);
    }];
    
}

- (void)setTitle:(NSString *)title titleColor:(UIColor *)color {
    self.nameLabel.text = title;
    self.nameLabel.textColor = color;
}

- (void)setSelectedBackGroundViewColor:(UIColor *)color {
    self.contentView.backgroundColor = color;
}

- (void)showSelectedView:(BOOL)selected {
    self.indexView.hidden = !selected;
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


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEX_RGB(0xE5E5E5);
    }
    return _lineView;
}

- (UIView *)indexView {
    if (!_indexView) {
        _indexView = [[UIView alloc] init];
        _indexView.hidden = YES;
        _indexView.backgroundColor = HEX_RGB(0xEE6161);
    }
    return _indexView;
}

@end
