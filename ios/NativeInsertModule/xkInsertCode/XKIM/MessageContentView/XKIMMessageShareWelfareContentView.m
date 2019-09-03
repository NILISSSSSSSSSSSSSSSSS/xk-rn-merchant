//
//  XKIMMessageShareWelfareContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageShareWelfareContentView.h"
#import "XKIMMessageShareWelfareAttachment.h"
#import "XKWelfareGoodsDetailViewController.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
#import "xkMerchantEmitterModule.h"

@interface XKIMMessageShareWelfareContentView()

@end

@implementation XKIMMessageShareWelfareContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.welfareImgView];
        [self addSubview:self.welfareNameLab];
        [self addSubview:self.welfareDespLab];
        [self addSubview:self.prizeLab];
        [self addSubview:self.lineH];
        [self addSubview:self.fromLab];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageShareWelfareAttachment *attachment = object.attachment;
    if (attachment.welfareIconUrl && attachment.welfareIconUrl.length) {
        [self.welfareImgView sd_setImageWithURL:[NSURL URLWithString:attachment.welfareIconUrl]];
    } else {
        self.welfareImgView.image = kDefaultPlaceHolderRectImg;
    }
    self.welfareNameLab.text = attachment.welfareName;
    self.welfareDespLab.text = [NSString stringWithFormat:@"产品规格：%@", attachment.welfareDescription];
    self.prizeLab.attributedText = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
      confer.text([NSString stringWithFormat:@"%.2f", attachment.welfarePrice / 100.0]).font(XKRegularFont(10.0)).textColor(HEX_RGB(0xEE6161));
        confer.text(@"消费券").font(XKRegularFont(10.0)).textColor(HEX_RGB(0x777777));
    }];
    if (data.message.isOutgoingMsg) {
        self.fromLab.text = @"我的分享";
    } else {
        self.fromLab.text = @"可友分享";
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [self.welfareImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * ScreenScale);
        make.leading.mas_equalTo(10 * ScreenScale);
        make.width.height.mas_equalTo(60.0 * ScreenScale);
    }];

    [self.welfareNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.welfareImgView);
        make.left.mas_equalTo(self.welfareImgView.mas_right).offset(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.welfareDespLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.welfareNameLab);
        make.bottom.mas_equalTo(self.prizeLab.mas_top);
    }];
    
    [self.prizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.welfareNameLab);
        make.bottom.mas_equalTo(self.welfareImgView);
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
    XKIMMessageShareWelfareAttachment *welfare = obj.attachment;
//    XKWelfareGoodsDetailViewController *vc = [[XKWelfareGoodsDetailViewController alloc] init];
//    vc.jSequenceId = welfare.sequenceId;
//    vc.goodsId = welfare.goodsId;
//    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  [xkMerchantEmitterModule RNJumpToWelfareDetailWithSequenceId:welfare.sequenceId goodsId:welfare.goodsId];
}

#pragma mark - getter setter

- (UIImageView *)welfareImgView {
    if (!_welfareImgView) {
        _welfareImgView = [[UIImageView alloc] init];
        _welfareImgView.contentMode = UIViewContentModeScaleAspectFill;
        _welfareImgView.xk_openClip = YES;
        _welfareImgView.xk_radius = 8;
        _welfareImgView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _welfareImgView;
}

- (UILabel *)welfareNameLab {
    if (!_welfareNameLab) {
        _welfareNameLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _welfareNameLab.numberOfLines = 2;
        _welfareNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _welfareNameLab;
}

- (UILabel *)welfareDespLab {
    if (!_welfareDespLab) {
        _welfareDespLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _welfareDespLab.numberOfLines = 1;
    }
    return _welfareDespLab;
}

- (UILabel *)prizeLab {
    if (!_prizeLab) {
        _prizeLab = [[UILabel alloc] init];
        _prizeLab.numberOfLines = 1;
    }
    return _prizeLab;
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
