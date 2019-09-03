//
//  XKIMMessageRedEnvelopeContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageRedEnvelopeContentView.h"
#import "XKIMMessageRedEnvelopeAttachment.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"
NSString *const XKRedRedEnvelopeOpenEvent  = @"XKRedRedEnvelopeOpenEvent";
NSString *const XKRedRedEnvelopeDetailEvent  = @"XKRedRedEnvelopeDetailEvent";


@interface XKIMMessageRedEnvelopeContentView()

@end

@implementation XKIMMessageRedEnvelopeContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.bgImgView];
        [self addSubview:self.titleLab];
        [self addSubview:self.openedLab];
        [self addSubview:self.openBtn];
        [self addSubview:self.detailView];
        [self.detailView addSubview:self.detailLab];
        [self.detailView addSubview:self.arrowImgView];
        self.openedLab.hidden = YES;
        [self.openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        [self.detailView bk_whenTapped:^{
            NIMKitEvent *event = [[NIMKitEvent alloc] init];
            event.eventName = XKRedRedEnvelopeDetailEvent;
            event.messageModel = weakSelf.model;
            event.data = weakSelf;
            [weakSelf.delegate onCatchEvent:event];
        }];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    XKIMMessageRedEnvelopeAttachment *attachment = object.attachment;
    if (attachment.redEnvelopeStartTime == attachment.redEnvelopeEndTime) {
        // 红包未过期
        self.openBtn.hidden = YES;
        self.titleLab.hidden = YES;
        self.openedLab.hidden = NO;
        self.detailView.hidden = YES;
        self.openedLab.text = @"红包已过期";
        self.bgImgView.image = IMG_NAME(@"xk_bg_IM_redEnvelope_disabled");
    } else {
        self.titleLab.text = attachment.redEnvelopeName;
        // 我是否已领取该红包
        BOOL isReceived = data.message.localExt && [data.message.localExt[@"isReceived"] boolValue];
        if (data.message.session.sessionType == NIMSessionTypeP2P) {
            // 单聊红包
            if (data.message.isOutgoingMsg) {
                // 我发出的红包 只显示详情按钮
                self.openBtn.hidden = YES;
                self.openedLab.hidden = YES;
                self.detailView.hidden = NO;
                self.bgImgView.image = IMG_NAME(@"xk_bg_IM_redEnvelope_normal");
            } else {
                // 他们发出的红包
                if (isReceived) {
                    // 红包已拆 显示红包已拆 详情按钮
                    self.openBtn.hidden = YES;
                    self.openedLab.hidden = NO;
                    self.detailView.hidden = NO;
                    self.bgImgView.image = IMG_NAME(@"xk_bg_IM_redEnvelope_opened");
                } else {
                    // 红包未拆 显示拆按钮
                    self.openBtn.hidden = NO;
                    self.openedLab.hidden = YES;
                    self.detailView.hidden = YES;
                    self.bgImgView.image = IMG_NAME(@"xk_bg_IM_redEnvelope_normal");
                }
            }
        } else if (data.message.session.sessionType == NIMSessionTypeTeam) {
            // 群聊红包
            if (isReceived) {
                // 红包已拆 显示红包已拆 详情按钮
                self.openBtn.hidden = YES;
                self.openedLab.hidden = NO;
                self.detailView.hidden = NO;
                self.bgImgView.image = IMG_NAME(@"xk_bg_IM_redEnvelope_opened");
            } else {
                // 红包未拆 显示拆按钮
                self.openBtn.hidden = NO;
                self.openedLab.hidden = YES;
                self.detailView.hidden = YES;
                self.bgImgView.image = IMG_NAME(@"xk_bg_IM_redEnvelope_normal");
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self cutCornerWithRadius:8 color:UIColorFromRGB(0xffffff) lineWidth:0];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgImgView);
        make.leading.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-10.0 * ScreenScale);
    }];
    
    [self.openedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(7.0 * ScreenScale);
        make.leading.trailing.mas_equalTo(self.titleLab);
    }];
    
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailView.mas_top).offset(-5.0 * ScreenScale);
        make.centerX.mas_equalTo(self.bgImgView);
        make.width.mas_equalTo(96.0 * ScreenScale);
        make.height.mas_equalTo(24.0 * ScreenScale);
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10.0 * ScreenScale);
        make.centerX.mas_equalTo(self.bgImgView);
        make.height.mas_equalTo(20.0 * ScreenScale);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.detailView);
        make.centerY.mas_equalTo(self.detailView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.detailLab.mas_right).offset(5.0 * ScreenScale);
        make.centerY.mas_equalTo(self.detailLab);
        make.width.mas_equalTo(5.0 * ScreenScale);
        make.height.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(self.detailView);
    }];
    
    [self handleFireView];
}

- (void)onTouchUpInside:(id)sender {
    
}

- (void)openBtnAction {
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = XKRedRedEnvelopeOpenEvent;
    event.messageModel = self.model;
    event.data = self;
    [self.delegate onCatchEvent:event];
}

#pragma mark - getter setter

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_bg_IM_redEnvelope_normal")];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = XKRegularFont(10.0);
        _titleLab.textColor = HEX_RGB(0xFFEBA3);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)openedLab {
    if (!_openedLab) {
        _openedLab = [[UILabel alloc] init];
        _openedLab.text = @"已拆开";
        _openedLab.font = XKRegularFont(10.0);
        _openedLab.textColor = HEX_RGB(0xFFFFFF);
        _openedLab.textAlignment = NSTextAlignmentCenter;
    }
    return _openedLab;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openBtn.titleLabel.font = XKRegularFont(14.0);
        [_openBtn setTitle:@"拆" forState:UIControlStateNormal];
        [_openBtn setTitleColor:HEX_RGB(0x7C4C4C) forState:UIControlStateNormal];
        _openBtn.backgroundColor = HEX_RGB(0xFECD6B);
        _openBtn.layer.cornerRadius  = 12.0 * ScreenScale;
        _openBtn.layer.masksToBounds = YES;
    }
    return _openBtn;
}

- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
    }
    return _detailView;
}

- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.text = @"查看";
        _detailLab.font = XKRegularFont(9.0);
        _detailLab.textColor = HEX_RGB(0xffffff);
    }
    return _detailLab;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_img_IM_redEnvelope_arrow")];
        _arrowImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _arrowImgView;
}

@end
