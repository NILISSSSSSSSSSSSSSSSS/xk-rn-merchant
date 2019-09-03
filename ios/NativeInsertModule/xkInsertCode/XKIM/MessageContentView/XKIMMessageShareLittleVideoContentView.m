//
//  XKIMMessageShareLittleVideoContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageShareLittleVideoContentView.h"
#import "XKIMMessageShareLittleVideoAttachment.h"
#import "XKVideoDisplayMediator.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"

@interface XKIMMessageShareLittleVideoContentView()

@end

@implementation XKIMMessageShareLittleVideoContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.videoCoverImgView];
        [self.videoCoverImgView addSubview:self.videoPlayImgView];
        [self addSubview:self.authorImgView];
        [self addSubview:self.authorLab];
        [self addSubview:self.videoDespLab];
        [self addSubview:self.lineH];
        [self addSubview:self.fromLab];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageShareLittleVideoAttachment *attachment = object.attachment;
    if (attachment.videoIconUrl && attachment.videoIconUrl.length) {
        [self.videoCoverImgView sd_setImageWithURL:[NSURL URLWithString:attachment.videoIconUrl]];
    } else {
        self.videoCoverImgView.image = kDefaultPlaceHolderRectImg;
    }
    if (attachment.videoAuthorAvatarUrl && attachment.videoAuthorAvatarUrl.length) {
        [self.authorImgView sd_setImageWithURL:[NSURL URLWithString:attachment.videoAuthorAvatarUrl]];
    } else {
        self.authorImgView.image = kDefaultHeadImg;
    }
    self.authorLab.text = attachment.videoAuthorName;
    self.videoDespLab.text = attachment.videoDescription;
    if (data.message.isOutgoingMsg) {
        self.fromLab.text = @"我的分享";
    } else {
        self.fromLab.text = @"可友分享";
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [self.videoCoverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * ScreenScale);
        make.leading.mas_equalTo(10 * ScreenScale);
        make.width.height.mas_equalTo(60.0 * ScreenScale);
    }];
    
    [self.videoPlayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.videoCoverImgView);
        make.width.height.mas_equalTo(20.0 * ScreenScale);
    }];
    
    [self.authorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoCoverImgView);
        make.left.mas_equalTo(self.videoCoverImgView.mas_right).offset(10.0 * ScreenScale);
        make.width.height.mas_equalTo(25.0 * ScreenScale);
    }];

    [self.authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.authorImgView.mas_right).offset(5.0 * ScreenScale);
        make.centerY.mas_equalTo(self.authorImgView);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.videoDespLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.authorImgView.mas_bottom).offset(9.0 * ScreenScale);
        make.leading.mas_equalTo(self.authorImgView);
        make.trailing.mas_equalTo(self.authorLab);
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
//    NIMCustomObject *object = self.model.message.messageObject;
//    XKIMMessageShareLittleVideoAttachment *attachment = object.attachment;
//    [XKVideoDisplayMediator displaySelectedVideoIdWithViewController:[self getCurrentUIVC] videoId:attachment.videoId];
}

#pragma mark - getter setter

- (UIImageView *)videoCoverImgView {
    if (!_videoCoverImgView) {
        _videoCoverImgView = [[UIImageView alloc] init];
        _videoCoverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _videoCoverImgView.xk_openClip = YES;
        _videoCoverImgView.xk_radius = 8;
        _videoCoverImgView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _videoCoverImgView;
}

- (UIImageView *)videoPlayImgView {
    if (!_videoPlayImgView) {
        _videoPlayImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_btn_IM_Message_videoPlay")];
    }
    return _videoPlayImgView;
}

- (UIImageView *)authorImgView {
    if (!_authorImgView) {
        _authorImgView = [[UIImageView alloc] init];
        _authorImgView.contentMode = UIViewContentModeScaleAspectFill;
        _authorImgView.xk_openClip = YES;
        _authorImgView.xk_radius = 12.5 * ScreenScale;
        _authorImgView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return _authorImgView;
}

- (UILabel *)authorLab {
    if (!_authorLab) {
        _authorLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(12) textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _authorLab.numberOfLines = 1;
        _authorLab.textAlignment = NSTextAlignmentLeft;
    }
    return _authorLab;
}

- (UILabel *)videoDespLab {
    if (!_videoDespLab) {
        _videoDespLab = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKRegularFont(10) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _videoDespLab.numberOfLines = 2;
    }
    return _videoDespLab;
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
