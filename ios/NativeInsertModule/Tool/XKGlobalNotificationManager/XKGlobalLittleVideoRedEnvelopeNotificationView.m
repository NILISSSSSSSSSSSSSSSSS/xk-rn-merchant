//
//  XKGlobalLittleVideoRedEnvelopeNotificationView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGlobalLittleVideoRedEnvelopeNotificationView.h"
#import "XKLittleVideoRedEnvelopeNotificationModel.h"

@interface XKGlobalLittleVideoRedEnvelopeNotificationView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) YYLabel *contentLab;

@property (nonatomic, strong) UIButton *checkBtn;


@property (nonatomic, strong) XKLittleVideoRedEnvelopeNotificationModel *littleVideoRedEnvelope;

@end

@implementation XKGlobalLittleVideoRedEnvelopeNotificationView

- (void)initializeViews {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    self.containerView.alpha = 0.95;
    self.containerView.layer.cornerRadius = 8.0;
    self.containerView.layer.shadowColor = HEX_RGBA(0x000000, 0.25).CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.containerView.layer.shadowRadius = 8.0;
    self.containerView.layer.shadowOpacity = 1.0;
    
    self.avatarImgView = [[UIImageView alloc] initWithImage:kDefaultHeadImg];
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.containerView addSubview:self.avatarImgView];
    self.avatarImgView.layer.cornerRadius = 4.0;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.clipsToBounds = YES;
    
    self.contentLab = [[YYLabel alloc] init];
    self.contentLab.numberOfLines = 1;
    self.contentLab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self.containerView addSubview:self.contentLab];
    
    self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkBtn.titleLabel.font = XKRegularFont(14.0);
    [self.checkBtn setTitle:@"点击查看" forState:UIControlStateNormal];
    [self.checkBtn setTitleColor:HEX_RGB(0x777777) forState:UIControlStateNormal];
    [self.containerView addSubview:self.checkBtn];
    [self.checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0));
    }];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15.0);
        make.centerY.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(32.0);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImgView);
        make.left.mas_equalTo(self.avatarImgView.mas_right).offset(10.0);
        make.right.mas_equalTo(self.checkBtn.mas_left).offset(-10.0);
    }];
    
    [self.checkBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15.0);
        make.top.bottom.mas_equalTo(self.containerView);
    }];
}

- (void)configViewWithLittleVideoRedEnvelope:(XKLittleVideoRedEnvelopeNotificationModel *)littleVideoRedEnvelope {
    _littleVideoRedEnvelope = littleVideoRedEnvelope;
    if (_littleVideoRedEnvelope.senderAvatar && _littleVideoRedEnvelope.senderAvatar.length) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:_littleVideoRedEnvelope.senderAvatar] placeholderImage:kDefaultHeadImg];
    } else {
        self.avatarImgView.image = kDefaultHeadImg;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:_littleVideoRedEnvelope.senderName];
    [nameStr addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, nameStr.length)];
    [nameStr addAttribute:NSForegroundColorAttributeName value:XKMainTypeColor range:NSMakeRange(0, nameStr.length)];
    [nameStr yy_setTextHighlightRange:NSMakeRange(0, nameStr.length) color:XKMainTypeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    }];
    NSMutableAttributedString *sendStr = [[NSMutableAttributedString alloc] initWithString:@"送给你一个红包"];
    [nameStr addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, nameStr.length)];
    [nameStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x222222) range:NSMakeRange(0, nameStr.length)];
    
    UIImageView *redEnvelopeImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_ic_globalNotification_redEnvelope")];
    redEnvelopeImgView.frame = CGRectMake(0.0, 0.0, 30, 30);
    NSMutableAttributedString *redEnvelopeStr = [NSMutableAttributedString yy_attachmentStringWithContent:redEnvelopeImgView contentMode:UIViewContentModeScaleAspectFit attachmentSize:redEnvelopeImgView.frame.size alignToFont:[UIFont systemFontOfSize:20] alignment:YYTextVerticalAlignmentCenter];
    
    [str appendAttributedString:nameStr];
    [str appendAttributedString:sendStr];
    [str appendAttributedString:redEnvelopeStr];

    self.contentLab.attributedText = str;
}

- (void)checkBtnAction:(UIButton *)sender {
    if (self.checkBtnBlock) {
        self.checkBtnBlock();
    }
}

@end
