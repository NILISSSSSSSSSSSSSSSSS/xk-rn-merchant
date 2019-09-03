//
//  XKVideoHomePageCollectionViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoHomePageCollectionViewCell.h"

@interface XKVideoHomePageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation XKVideoHomePageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    
    self.backgroundColor = HEX_RGB(0xF6F6F6);
    
    // control
    UIControl *control = [UIControl new];
    control.backgroundColor = [UIColor whiteColor];
    control.frame = self.contentView.frame;
    [self.contentView addSubview:control];
    
    // 图片
    self.imageView = [UIImageView new];
    self.imageView.xk_openClip = YES;
    self.imageView.xk_radius = 5;
    self.imageView.xk_clipType = XKCornerClipTypeAllCorners;
    self.imageView.backgroundColor = HEX_RGB(0xF6F6F6);
    self.imageView.image = [UIImage imageNamed:@"xk_ic_defult_head"];
    [self.contentView addSubview:self.imageView];
    self.imageView.frame = self.contentView.frame;
    
    // 标题
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:11.0];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(-32);
        make.left.equalTo(self.imageView.mas_left).offset(5);
        make.right.equalTo(self.imageView.mas_right);
        make.height.equalTo(@(32));
    }];
    
    // 定位
    self.locationLabel = [UILabel new];
    self.locationLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:11.0];
    self.locationLabel.textColor = [UIColor whiteColor];
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.numberOfLines = 2;
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(-20);
        make.right.equalTo(self.imageView.mas_right).offset(-5);
    }];
    
    // 定位图片
    UIImageView *locationImageView = [UIImageView new];
    locationImageView.image = [UIImage imageNamed:@"xk_btn_welfare_location"];
    [self.contentView addSubview:locationImageView];
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locationLabel.mas_left).offset(-3);
        make.centerY.equalTo(self.locationLabel.mas_centerY);
        make.width.equalTo(@(9));
        make.height.equalTo(@(12));
    }];
}

@end
