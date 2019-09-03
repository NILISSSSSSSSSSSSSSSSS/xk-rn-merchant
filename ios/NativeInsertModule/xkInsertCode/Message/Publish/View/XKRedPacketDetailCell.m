//
//  XKRedPacketDetailCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedPacketDetailCell.h"

@interface XKRedPacketDetailCell ()
@property (nonatomic, strong) UIImageView  *headerImgView;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, strong) UILabel  *countLabel;
@property (nonatomic, strong) UIButton   *hotView;
@end

@implementation XKRedPacketDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.bgContainView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6;

    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    
    [self.bgContainView addSubview:self.headerImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.timeLabel];
    [self.bgContainView addSubview:self.countLabel];
    [self.bgContainView addSubview:self.hotView];
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.centerY.equalTo(self.bgContainView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.top.equalTo(self.headerImgView.mas_top);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.top.equalTo(self.headerImgView.mas_top);
        make.right.lessThanOrEqualTo(self.countLabel.mas_left).offset(-70);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.top.equalTo(self.headerImgView.mas_top);
        make.size.mas_equalTo(CGSizeMake(55, 16));
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headerImgView.image = kDefaultHeadImg;
        _headerImgView.layer.cornerRadius = 4.f;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XKRegularFont(14);
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.text = @"林小姐Msdus";
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = XKRegularFont(12);
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel.text = @"10-23 08:23";
    }
    return _timeLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = XKRegularFont(14);
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = UIColorFromRGB(0x222222);
        _countLabel.text = @"10 币";
    }
    return _countLabel;
}

- (UIButton *)hotView {
    if (!_hotView) {
        _hotView = [[UIButton alloc] init];
        [_hotView setBackgroundColor:UIColorFromRGB(0xFFB741)];
        [_hotView setTitleColor:[UIColor whiteColor] forState:0];
        _hotView.titleLabel.font = XKRegularFont(10);
        [_hotView setTitle:@"手气最佳" forState:0];
        _hotView.layer.cornerRadius = 8.f;
        _hotView.layer.masksToBounds = YES;
    }
    return _hotView;
}
@end
