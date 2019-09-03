//
//  XKMineConfigureRecipientEditTagTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientEditTagTableViewCell.h"
#import "XKMineConfigureRecipientListModel.h"

@interface XKMineConfigureRecipientEditTagTableViewCell ()

@property (nonatomic, strong) UILabel *addressTagLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation XKMineConfigureRecipientEditTagTableViewCell

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
    
    if (recipientItem.label && ![recipientItem.label isEqualToString:@""]) {
        self.describeLabel.text = recipientItem.label;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.delegate addressTagCellDidSelected:self];
    }
}

- (void)configureSubviews {
    
    [self.addressTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.centerY.equalTo(self.addressTagLabel.mas_centerY);
        make.right.equalTo(self.arrowImageView.mas_right).offset(-20);
    }];
    
    self.addressTagLabel.text = @"地址标签";
}

- (UILabel *)addressTagLabel {
    
    if (!_addressTagLabel) {
        _addressTagLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        _addressTagLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _addressTagLabel.numberOfLines = 1;
        [self.contentView addSubview:_addressTagLabel];
    }
    return _addressTagLabel;
}

- (UILabel *)describeLabel {
    
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.numberOfLines = 1;
        _describeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        _describeLabel.textColor = [UIColor lightGrayColor];
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
