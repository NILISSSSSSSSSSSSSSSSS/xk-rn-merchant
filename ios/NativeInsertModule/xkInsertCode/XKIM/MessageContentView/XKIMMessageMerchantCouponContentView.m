//
//  XKIMMessageMerchantCouponContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageMerchantCouponContentView.h"
#import "XKIMMessageCouponAttachment.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"

@interface XKIMMessageMerchantCouponContentView()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *leftImgView;

@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *limitLab;

@property (nonatomic, strong) UILabel *dateLab;

@property (nonatomic, strong) UILabel *discountLab;

@property (nonatomic, strong) UILabel *lineH;

@property (nonatomic, strong) UILabel *fromLab;

@end


@implementation XKIMMessageMerchantCouponContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.leftImgView];
        [self.containerView addSubview:self.rightImgView];
        [self.leftImgView addSubview:self.titleLab];
        [self.leftImgView addSubview:self.dateLab];
        [self.leftImgView addSubview:self.limitLab];
        [self.rightImgView addSubview:self.discountLab];
        [self addSubview:self.lineH];
        [self addSubview:self.fromLab];
    }
    return self;
}

- (void)layoutSubviews {
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0 * ScreenScale);
        make.leading.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-15.0 * ScreenScale);
        make.height.mas_equalTo(60.0 * ScreenScale);
    }];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.containerView).multipliedBy(2.0 / 3.0);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.leftImgView.mas_right);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13.0 * ScreenScale);
        make.leading.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.leading.trailing.mas_equalTo(self.limitLab);
    }];
    
    [self.limitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLab.mas_bottom);
        make.leading.trailing.mas_equalTo(self.titleLab);
        make.bottom.mas_equalTo(self.leftImgView).offset(-7.0 * ScreenScale);
    }];
    
    [self.discountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 0.0, 0.0, 8.0 * ScreenScale));
    }];
    
    [self.lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(-20.0 * ScreenScale);
        make.height.mas_equalTo(1.0);
    }];
    
    [self.fromLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineH);
        make.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self handleFireView];
}

- (void)refresh:(NIMMessageModel *)data {
    NIMCustomObject *obj = data.message.messageObject;
    XKIMMessageCouponAttachment *coupon = obj.attachment;
    self.titleLab.text = coupon.voucherName;
    self.limitLab.text = coupon.voucherScope && coupon.voucherScope.length ? coupon.voucherScope : @"无";
    self.dateLab.text = [NSString stringWithFormat:@"%@至%@有效", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", coupon.voucherStartTime]], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", coupon.voucherEndTime]]];
    self.discountLab.attributedText = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        if (coupon.voucherSubType == 1) {
            // 折扣券
            confer.text([NSString stringWithFormat:@"%.1f", coupon.voucherValue / 100.0]).font(XKMediumFont(22.0)).textColor(XKMainRedColor);
            confer.text(@"折").font(XKMediumFont(8.0)).textColor(XKMainRedColor);
        } else {
            // 满减券
            UIFont *font;
            if (coupon.voucherValue / 100.0 < 100.0) {
                font = XKMediumFont(16.0);
            } else if (coupon.voucherValue / 100.0 < 1000.0) {
                font = XKMediumFont(14.0);
            } else if (coupon.voucherValue / 100.0 < 10000.0) {
                font = XKMediumFont(12.0);
            } else {
                font = XKMediumFont(10.0);
            }
            confer.text([NSString stringWithFormat:@"%.2f", coupon.voucherValue / 100.0]).font(font).textColor(XKMainRedColor);
            confer.text(@"¥").font(XKMediumFont(8.0)).textColor(XKMainRedColor);
        }
    }];
    self.fromLab.text = @"卡券转赠";
}

#pragma mark - getter setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UILabel alloc] init];
    }
    return _containerView;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.contentMode = UIViewContentModeScaleToFill;
        _leftImgView.image = IMG_NAME(@"xk_bg_im_merchantCoupon_left");
    }
    return _leftImgView;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.contentMode = UIViewContentModeScaleToFill;
        _rightImgView.image = IMG_NAME(@"xk_bg_im_merchantCoupon_right");
    }
    return _rightImgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"标题";
        _titleLab.font = XKMediumFont(12.0);
        _titleLab.textColor = HEX_RGB(0x222222);
    }
    return _titleLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.text = @"有效期";
        _dateLab.font = XKRegularFont(8.0);
        _dateLab.textColor = HEX_RGB(0x777777);
    }
    return _dateLab;
}

- (UILabel *)limitLab {
    if (!_limitLab) {
        _limitLab = [[UILabel alloc] init];
        _limitLab.text = @"使用范围";
        _limitLab.font = XKRegularFont(10.0);
        _limitLab.textColor = HEX_RGB(0x222222);
    }
    return _limitLab;
}

- (UILabel *)discountLab {
    if (!_discountLab) {
        _discountLab = [[UILabel alloc] init];
        _discountLab.textAlignment = NSTextAlignmentCenter;
    }
    return _discountLab;
}

- (UILabel *)lineH {
    if (!_lineH) {
        _lineH = [[UILabel alloc] init];
        _lineH.backgroundColor = XKSeparatorLineColor;
    }
    return _lineH;
}

- (UILabel *)fromLab {
    if (!_fromLab) {
        _fromLab = [[UILabel alloc] init];
        _fromLab.text = @"来源";
        _fromLab.font = XKRegularFont(10.0);
        _fromLab.textColor = HEX_RGB(0x999999);
    }
    return _fromLab;
}

@end
