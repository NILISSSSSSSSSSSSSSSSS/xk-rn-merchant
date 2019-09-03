//
//  XKMineConfigureRecipientEditRegionTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientEditRegionTableViewCell.h"
#import "XKMineConfigureRecipientListModel.h"

@interface XKMineConfigureRecipientEditRegionTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) XKMineConfigureRecipientItem *recipientItem;

@end

@implementation XKMineConfigureRecipientEditRegionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureSubviews];
    
    return self;
}

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem {
    
    self.recipientItem = recipientItem;
    if (recipientItem.provinceName && ![recipientItem.provinceName isEqualToString:@""] &&
        recipientItem.cityName && ![recipientItem.cityName isEqualToString:@""] &&
        recipientItem.districtName && ![recipientItem.districtName isEqualToString:@""] ) {
        self.describeLabel.text = [NSString stringWithFormat:@"%@%@%@", recipientItem.provinceName, recipientItem.cityName, recipientItem.districtName];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (!selected) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(regionCellDidSelected:)]) {
        [self.delegate regionCellDidSelected:self];
    }
}

- (void)configureSubviews {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.width.mas_equalTo(80);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-18);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.equalTo(self.arrowImageView.mas_left);
    }];
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = XKSeparatorLineColor;
    [self.contentView addSubview:separatorView];
    [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    self.titleLabel.text = @"所有地区";
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
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
        _describeLabel.textColor = [UIColor darkGrayColor];
        _describeLabel.text = @"请选择";
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

@end
