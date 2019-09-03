//
//  XKAdressTagStringTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAdressTagStringTableViewCell.h"

@interface XKAdressTagStringTableViewCell ()

@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation XKAdressTagStringTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.delegate addressTagStringCellDidSelected:self tagString:self.tagLabel.text];
    }
}

- (void)configAdressTagStringTableViewCellWithTagString:(NSString *)tagString {
    self.tagLabel.text = tagString;
}

- (void)configureSubviews {
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (UILabel *)tagLabel {
    
    if (!_tagLabel) {
        _tagLabel = [UILabel new];
        _tagLabel.numberOfLines = 1;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        [self.contentView addSubview:_tagLabel];
    }
    return _tagLabel;
}

@end

