//
//  XKBottomAlertSheetCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/31.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBottomAlertSheetCell.h"
@interface XKBottomAlertSheetCell()

@end

@implementation XKBottomAlertSheetCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.nameLabel];
}

- (void)addUIConstraint {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
    }];
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:17];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
@end
