//
//  XKVideoCitywideCollectionHeaderView.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoCitywideCollectionHeaderView.h"

@interface XKVideoCitywideCollectionHeaderView()

@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation XKVideoCitywideCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HEX_RGB(0xF6F6F6);
        
        // 底部视图
        UIControl *bgControl = [UIControl new];
        bgControl.xk_openClip = YES;
        bgControl.xk_radius = 8;
        bgControl.xk_clipType = XKCornerClipTypeAllCorners;
        bgControl.backgroundColor = [UIColor whiteColor];
        [bgControl addTarget:self action:@selector(clickBgControl:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgControl];
        [bgControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        // 定位图片
        UIImageView *locationImageView = [UIImageView new];
        locationImageView.image = [UIImage imageNamed:@"xk_btn_welfare_location"];
        [bgControl addSubview:locationImageView];
        [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgControl.mas_left).offset(12);
            make.centerY.equalTo(bgControl.mas_centerY);
            make.width.equalTo(@(12));
            make.height.equalTo(@(16));
        }];
        
        // 定位文字
        UILabel *locationLabel = [UILabel new];
        locationLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
        locationLabel.textColor = [UIColor lightGrayColor];
        [bgControl addSubview:locationLabel];
        [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationImageView.mas_right).offset(8);
            make.centerY.equalTo(locationImageView.mas_centerY);
        }];
        self.locationLabel = locationLabel;
        
        // 箭头
        UIImageView *arrowsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"]];
        [bgControl addSubview:arrowsImageView];
        [arrowsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgControl.mas_right).offset(-10);
            make.centerY.equalTo(bgControl.mas_centerY);
            make.width.height.equalTo(@(12));
        }];
    }
    return self;
}

- (void)configHeaderViewWithCityName:(NSString *)cityName {
    self.locationLabel.text = cityName;
}

- (void)clickBgControl:(UIControl *)control {
    [self.delegate headerView:self clickBgControl:control];
}

@end
