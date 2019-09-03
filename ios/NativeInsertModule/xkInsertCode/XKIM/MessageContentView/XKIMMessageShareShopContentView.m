//
//  XKIMMessageShareShopContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageShareShopContentView.h"
#import "XKCommonStarView.h"
#import "XKIMMessageShareShopAttachment.h"
#import "XKStoreRecommendViewController.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"

@interface XKIMMessageShareShopContentView()

@end

@implementation XKIMMessageShareShopContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.shopCoverImgView];
        [self addSubview:self.shopNameLab];
        [self addSubview:self.shopDespLab];
        [self addSubview:self.starView];
        [self addSubview:self.starLab];
        [self addSubview:self.distanceLab];
        [self addSubview:self.lineV];
        [self addSubview:self.tradingQuantityLab];
        [self addSubview:self.lineH];
        [self addSubview:self.fromLab];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageShareShopAttachment *attachment = object.attachment;
    if (attachment.storeIconUrl && attachment.storeIconUrl.length) {
        [self.shopCoverImgView sd_setImageWithURL:[NSURL URLWithString:attachment.storeIconUrl]];
    } else {
        self.shopCoverImgView.image = kDefaultPlaceHolderRectImg;
    }
    self.shopNameLab.text = attachment.storeName;
    self.shopDespLab.text = attachment.storeDescription;
    self.starView.scorePercent = attachment.storeScore / 5.0;
    self.starLab.text = [NSString stringWithFormat:@"%tu分", (NSUInteger)attachment.storeScore];

    double distance = [[XKBaiduLocation shareManager] getDistanceFromCurrentLocationWithLatitude:attachment.storeLatitude longitude:attachment.storeLongitude];
    if (distance > 1000.0) {
        self.distanceLab.text = [NSString stringWithFormat:@"距离：%.1fkm", distance / 1000.0];
    } else {
        self.distanceLab.text = [NSString stringWithFormat:@"距离：%tum", (NSUInteger)distance];
    }
    self.tradingQuantityLab.text = attachment.storeSalesVolume >= 10000 ? [NSString stringWithFormat:@"成交量：%.1fw单", attachment.storeSalesVolume / 10000.0] : [NSString stringWithFormat:@"成交量：%tu单", attachment.storeSalesVolume];
    if (data.message.isOutgoingMsg) {
        self.fromLab.text = @"我的分享";
    } else {
        self.fromLab.text = @"可友分享";
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [self.shopCoverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * ScreenScale);
        make.leading.mas_equalTo(10 * ScreenScale);
        make.width.height.mas_equalTo(60.0 * ScreenScale);
    }];
    
    [self.shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopCoverImgView);
        make.left.mas_equalTo(self.shopCoverImgView.mas_right).offset(7.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.shopDespLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopNameLab.mas_bottom);
        make.leading.trailing.mas_equalTo(self.shopNameLab);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.starLab);
        make.leading.mas_equalTo(self.shopDespLab);
        make.width.mas_equalTo(60.0 * ScreenScale);
        make.height.mas_equalTo(10.0 * ScreenScale);
    }];
    
    [self.starLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopDespLab.mas_bottom);
        make.left.mas_equalTo(self.starView.mas_right).offset(5.0 * ScreenScale);
        make.centerY.mas_equalTo(self.starView);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.starLab.mas_bottom);
        make.leading.mas_equalTo(self.starView);
        make.right.mas_equalTo(self.lineV.mas_left).offset(-5.0 * ScreenScale);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.distanceLab);
        make.width.mas_equalTo(1.0);
    }];
    
    [self.tradingQuantityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineV.mas_right).offset(5.0 * ScreenScale);
        make.bottom.mas_equalTo(self.lineV);
        make.width.mas_equalTo(self.distanceLab);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.fromLab.mas_top);
        make.height.mas_equalTo(1.0);
    }];
    
    [self.fromLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(20 * ScreenScale);
    }];
    
    [self handleFireView];
}

- (void)onTouchUpInside:(id)sender {
    NIMCustomObject *obj = self.model.message.messageObject;
    XKIMMessageShareShopAttachment *shop = obj.attachment;
    XKStoreRecommendViewController *vc = [[XKStoreRecommendViewController alloc] init];
    vc.shopId = shop.storeId;
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter setter

- (UIImageView *)shopCoverImgView {
    if (!_shopCoverImgView) {
        _shopCoverImgView = [[UIImageView alloc] init];
        _shopCoverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _shopCoverImgView.xk_openClip = YES;
        _shopCoverImgView.xk_radius = 8;
        _shopCoverImgView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _shopCoverImgView;
}

- (UILabel *)shopNameLab {
    if (!_shopNameLab) {
        _shopNameLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _shopNameLab.numberOfLines = 1;
    }
    return _shopNameLab;
}

- (UILabel *)shopDespLab {
    if (!_shopDespLab) {
        _shopDespLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _shopNameLab.numberOfLines = 1;
    }
    return _shopDespLab;
}

- (XKCommonStarView *)starView {
    if (!_starView) {
        _starView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60 * ScreenScale, 10.0 * ScreenScale) numberOfStars:5];
    }
    return _starView;
}

- (UILabel *)starLab {
    if (!_starLab) {
        _starLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"0分" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    }
    return _starLab;
}

- (UILabel *)distanceLab {
    if (!_distanceLab) {
        _distanceLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
    }
    return _distanceLab;
}

- (UILabel *)lineV {
    if (!_lineV) {
        _lineV = [[UILabel alloc] init];
        _lineV.backgroundColor = XKSeparatorLineColor;
    }
    return _lineV;
}

- (UILabel *)tradingQuantityLab {
    if (!_tradingQuantityLab) {
        _tradingQuantityLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _tradingQuantityLab.textAlignment = NSTextAlignmentRight;
    }
    return _tradingQuantityLab;
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
        _fromLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
    }
    return _fromLab;
}

@end
