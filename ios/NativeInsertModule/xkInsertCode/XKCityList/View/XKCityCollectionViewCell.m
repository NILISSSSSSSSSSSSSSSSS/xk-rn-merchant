//
//  XKCityCollectionViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityCollectionViewCell.h"
@interface XKCityCollectionViewCell()

@end
@implementation XKCityCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        self.backgroundColor = HEX_RGB(0xFFFFFF);
        label.backgroundColor = HEX_RGB(0xFFFFFF);
        label.textColor = HEX_RGB(0x666666);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:13];
        [self addSubview:label];
        //定位图标
        UIImageView * locationImageV = [[UIImageView alloc]init];
        locationImageV.image = [UIImage imageNamed:@"xk_ic_login_location"];
        [self addSubview:locationImageV];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@60);
            make.height.equalTo(@40);
            make.center.equalTo(self);
        }];
        
        [locationImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).offset(3);
            make.width.equalTo(@11);
            make.height.equalTo(@15);
            make.centerY.equalTo(self);
        }];
        self.locationImageView = locationImageV;
        self.locationImageView.hidden = YES;
        self.label = label;
    }
    return self;
}

// 设置collectionView cell的border
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBA(155, 155, 165, 0.5).CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

- (void)setModel:(XKCityListModel *)model {
    self.model = model;
}
@end
