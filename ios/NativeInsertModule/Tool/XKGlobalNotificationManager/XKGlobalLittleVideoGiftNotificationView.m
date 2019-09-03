//
//  XKGlobalLittleVideoGiftNotificationView.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGlobalLittleVideoGiftNotificationView.h"
#import "XKLittleVideoGiftNotificationModel.h"

@interface XKGlobalLittleVideoGiftNotificationView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) YYLabel *contentLab;

@property (nonatomic, strong) UIButton *checkBtn;


@property (nonatomic, strong) XKLittleVideoGiftNotificationModel *littleVideoGift;

@end

@implementation XKGlobalLittleVideoGiftNotificationView

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

- (void)configViewWithLittleVideoGift:(XKLittleVideoGiftNotificationModel *)littleVideoGift {
    _littleVideoGift = littleVideoGift;
    
    if (_littleVideoGift.senderAvatar && _littleVideoGift.senderAvatar.length) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:_littleVideoGift.senderAvatar] placeholderImage:kDefaultHeadImg];
    } else {
        self.avatarImgView.image = kDefaultHeadImg;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:_littleVideoGift.senderName];
    [nameStr addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, nameStr.length)];
    [nameStr addAttribute:NSForegroundColorAttributeName value:XKMainTypeColor range:NSMakeRange(0, nameStr.length)];
    [nameStr yy_setTextHighlightRange:NSMakeRange(0, nameStr.length) color:XKMainTypeColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    }];
    NSMutableAttributedString *sendStr = [[NSMutableAttributedString alloc] initWithString:@"送给你"];
    [nameStr addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, nameStr.length)];
    [nameStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x222222) range:NSMakeRange(0, nameStr.length)];
    
    UIImageView *giftImgView = [[UIImageView alloc] init];
    if (_littleVideoGift.giftImg && _littleVideoGift.giftImg.length) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:_littleVideoGift.senderAvatar] placeholderImage:kDefaultPlaceHolderImg];
    } else {
        self.avatarImgView.image = kDefaultPlaceHolderImg;
    }
    giftImgView.frame = CGRectMake(0.0, 0.0, 30, 30);
    NSMutableAttributedString *giftStr = [NSMutableAttributedString yy_attachmentStringWithContent:giftImgView contentMode:UIViewContentModeScaleAspectFit attachmentSize:giftImgView.frame.size alignToFont:[UIFont systemFontOfSize:20] alignment:YYTextVerticalAlignmentCenter];
    
    NSMutableAttributedString *numStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"x%tu", _littleVideoGift.giftNum]];
    [numStr addAttribute:NSFontAttributeName value:XKRegularFont(14.0) range:NSMakeRange(0, numStr.length)];
    [numStr addAttribute:NSForegroundColorAttributeName value:XKMainRedColor range:NSMakeRange(0, numStr.length)];
    
    [str appendAttributedString:nameStr];
    [str appendAttributedString:sendStr];
    [str appendAttributedString:giftStr];
    [str appendAttributedString:numStr];
    
    self.contentLab.attributedText = str;
}

- (void)checkBtnAction:(UIButton *)sender {
    if (self.checkBtnBlock) {
        self.checkBtnBlock();
    }
}

@end
