//
//  XKRedEnvelopeInfoHeaderView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/26.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedEnvelopeInfoHeaderView.h"

@interface XKRedEnvelopeInfoHeaderView ()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *redEnvelopeLab;

@end

@implementation XKRedEnvelopeInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.bgImgView = [[UIImageView alloc] init];
        self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.bgImgView];
        UIImage *img = IMG_NAME(@"xk_bg_IM_function_redPacketTop");
        [img resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 30.0, 0.0) resizingMode:UIImageResizingModeStretch];
        self.bgImgView.image = img;
        
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImgView.image = kDefaultHeadImg;
        [self addSubview:self.avatarImgView];
        self.avatarImgView.layer.cornerRadius = 40.0;
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.layer.borderWidth = 1.0;
        self.avatarImgView.layer.borderColor = HEX_RGB(0xffffff).CGColor;
        
        self.redEnvelopeLab = [[UILabel alloc] init];
        self.redEnvelopeLab.text = @"XXX的红包";
        self.redEnvelopeLab.font = XKMediumFont(17.0);
        self.redEnvelopeLab.textColor = HEX_RGB(0x222222);
        self.redEnvelopeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.redEnvelopeLab];
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self);
            make.height.mas_equalTo(iPhoneX_Serious ? 134.0 + 24.0 : 134.0);
        }];
        
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgImgView);
            make.centerY.mas_equalTo(self.bgImgView.mas_bottom);
            make.width.height.mas_equalTo(80.0);
        }];
        
        [self.redEnvelopeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImgView.mas_bottom).offset(15.0);
            make.leading.trailing.mas_equalTo(self);
        }];
    }
    return self;
}

@end
