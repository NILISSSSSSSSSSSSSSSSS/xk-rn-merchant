//
//  XKMallOrderApplyRefundAddressCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderApplyRefundAddressCell.h"

@interface XKMallOrderApplyRefundAddressCell ()

@property (nonatomic, strong) UILabel *leftLabel;


@end

@implementation XKMallOrderApplyRefundAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {

        self.xk_openClip = YES;
        self.xk_radius = 6;
        self.xk_clipType = XKCornerClipTypeAllCorners;
        
    }
    return self;
}

- (void)addCustomSubviews {
    
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];

}

- (void)addUIConstraint {
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.greaterThanOrEqualTo(self.leftLabel.mas_right).offset(10);
    }];

}
#pragma mark lazy

- (UILabel *)leftLabel {
    if(!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = XKRegularFont(14);
        _leftLabel.textColor = UIColorFromRGB(0x222222);
        _leftLabel.text = @"退货地址：";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if(!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = XKRegularFont(12);
        _rightLabel.textColor = UIColorFromRGB(0x555555);
        _rightLabel.numberOfLines = 2;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

@end
