//
//  XKIMMessageCustomTipContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageCustomTipContentView.h"
#import "XKIMMessageCustomTipAttachment.h"
#import "XKIMMessageRedEnvelopeTipAttachment.h"

@implementation XKIMMessageCustomTipContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bubbleImageView.hidden = YES;
        [self addSubview:self.tipLabView];
        [self.tipLabView addSubview:self.tipLab];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = data.message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
        // 红包提示消息
        XKIMMessageRedEnvelopeTipAttachment *attachment = object.attachment;
        self.tipLab.attributedText = [attachment tipStr];
    } else if ([object.attachment isKindOfClass:[XKIMMessageCustomTipAttachment class]]) {
        // 自定义提示消息
        XKIMMessageCustomTipAttachment *attachment = object.attachment;
        self.tipLab.attributedText = [attachment tipStr];
    }
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(SCREEN_WIDTH - [NIMKit sharedKit].config.maxNotificationTipPadding * 2.0 - 12.0 * ScreenScale * 2, CGFLOAT_MAX);
    container.linePositionModifier = self.tipLab.linePositionModifier;
    container.insets = self.tipLab.textContainerInset;
    container.maximumNumberOfRows = self.tipLab.numberOfLines;
    
    //创建layout
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:self.tipLab.attributedText];
    [self.tipLabView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(layout.textBoundingSize.width + 12.0 * ScreenScale * 2);
        make.height.mas_equalTo(layout.textBoundingSize.height + 6.0 * ScreenScale * 2);
    }];
    self.tipLabView.xk_radius = (layout.textBoundingSize.height + 6.0 * ScreenScale * 2) / 2.0;
    self.tipLabView.xk_clipType = XKCornerClipTypeAllCorners;
    self.tipLabView.xk_openClip = YES;
    [self.tipLabView xk_forceClip];
}

- (void)onTouchUpInside:(id)sender {
    
}

- (void)layoutSubviews {
    [self.tipLabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6.0 * ScreenScale);
        make.bottom.mas_equalTo(-6.0 * ScreenScale);
        make.leading.mas_equalTo(12.0 * ScreenScale);
        make.trailing.mas_equalTo(-12.0 * ScreenScale);
    }];
}

#pragma mark - getter setter

- (UIView *)tipLabView {
    if (!_tipLabView) {
        _tipLabView = [[UIView alloc] init];
        _tipLabView.backgroundColor = HEX_RGB(0xDDDDDD);
    }
    return _tipLabView;
}

- (YYLabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[YYLabel alloc] init];
        _tipLab.numberOfLines = 0;
    }
    return _tipLab;
}

@end
