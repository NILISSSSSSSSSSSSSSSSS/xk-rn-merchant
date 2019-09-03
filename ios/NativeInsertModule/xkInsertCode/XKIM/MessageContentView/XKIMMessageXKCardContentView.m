//
//  XKIMMessageXKCardContentView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageXKCardContentView.h"
#import "XKIMMessageCardAttachment.h"
#import "XKSecretMessageFireOtherModel.h"
#import "XKSecretFrientManager.h"

@interface XKIMMessageXKCardContentView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *limitLab;

@property (nonatomic, strong) UILabel *dateLab;

@property (nonatomic, strong) UILabel *lineH;

@property (nonatomic, strong) UILabel *fromLab;

@end

@implementation XKIMMessageXKCardContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.bubbleImageView.hidden = YES;
        
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.titleLab];
        [self.bgImgView addSubview:self.limitLab];
        [self.bgImgView addSubview:self.dateLab];
        [self addSubview:self.lineH];
        [self addSubview:self.fromLab];
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0 * ScreenScale);
        make.leading.mas_equalTo(10.0 * ScreenScale);
        make.trailing.mas_equalTo(-20.0 * ScreenScale);
        make.height.mas_equalTo(60.0 * ScreenScale);
    }];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8.0 * ScreenScale);
        make.leading.mas_equalTo(15.0 * ScreenScale);
        make.trailing.mas_equalTo(-15.0);
    }];
    
    [self.limitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.leading.trailing.mas_equalTo(self.titleLab);
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.limitLab.mas_bottom);
        make.leading.trailing.mas_equalTo(self.limitLab);
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
    XKIMMessageCardAttachment *card = obj.attachment;
    NSString *cardTypeStr;
    if (card.cardSubType == 1) {
        cardTypeStr = @"会员卡";
    } else {
        cardTypeStr = @"普通卡";
    }
    self.titleLab.attributedText = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(cardTypeStr).font(XKMediumFont(17.0)).textColor(HEX_RGB(0xFFFC7B));
        confer.text(@" ");
        confer.text([NSString stringWithFormat:@"%.2f", card.cardDiscount / 100.0]).font(XKRegularFont(12.0)).textColor(HEX_RGB(0xFFFC7B));
        confer.text(@"折").font(XKRegularFont(8.0)).textColor(HEX_RGB(0xFFFC7B));
    }];
    self.limitLab.text = card.cardScope && card.cardScope.length ? card.cardScope : @"无";
    self.dateLab.text = [NSString stringWithFormat:@"有效期 %@至 %@", [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", card.cardStartTime]], [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:[NSString stringWithFormat:@"%tu", card.cardEndTime]]];
    self.fromLab.text = @"卡券转赠";
}

- (void)onTouchUpInside:(id)sender {
    
}

#pragma mark - getter setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.image = IMG_NAME(@"xk_bg_company_card");
    }
    return _bgImgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
    }
    return _titleLab;
}

- (UILabel *)limitLab {
    if (!_limitLab) {
        _limitLab = [[UILabel alloc] init];
        _limitLab.text = @"使用范围";
        _limitLab.font = XKRegularFont(10.0);
        _limitLab.textColor = HEX_RGB(0xFFFFFF);
    }
    return _limitLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.text = @"有效期";
        _dateLab.font = XKRegularFont(8.0);
        _dateLab.textColor = HEX_RGB(0xFFFFFF);
    }
    return _dateLab;
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
