//
//  XKMineAccountManageTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineAccountManageTableViewCell.h"
#import "XKMineAccountManageModel.h"

@interface XKMineAccountManageTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation XKMineAccountManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureSubviews];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        [self.delegate accountManageCellDidSelected:self];
    }
}

- (void)configAccountManageTableViewCellWithModel:(XKMineAccountManageModel *)model {
    
    self.titleLabel.text = model.titleString;
    self.describeLabel.text = model.describeString;
}

- (void)showCellSeparator {
    self.separatorView.hidden = NO;
}

- (void)hiddenCellSeparator {
    self.separatorView.hidden = YES;
}

- (void)configureSubviews {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(18);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-18);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.arrowImageView.mas_right).offset(-20);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    self.titleLabel.text = @"test";
    self.describeLabel.text = @"123";
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)describeLabel {
    
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.numberOfLines = 1;
        _describeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _describeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_describeLabel];
    }
    return _describeLabel;
}

- (UIImageView *)arrowImageView {
    
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"xk_btn_Mine_Setting_nextBlack"];
        [self.contentView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UIView *)separatorView {
    
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = XKSeparatorLineColor;
        [self.contentView addSubview:_separatorView];
    }
    return _separatorView;
}

@end
