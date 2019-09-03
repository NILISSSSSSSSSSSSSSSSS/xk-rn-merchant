//
//  XKLotteryTicketAnnouncementTipsView.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketAnnouncementTipsView.h"

@interface XKLotteryTicketAnnouncementTipsView ()

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *statusImgView;

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIButton *confirmBtn;
 
@end

@implementation XKLotteryTicketAnnouncementTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setBackgroundImage:IMG_NAME(@"xk_img_lotteryTicket_tips_close") forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = HEX_RGB(0xFFFFFF);
    [self addSubview:self.containerView];
    self.containerView.layer.cornerRadius = 12.0;
    
    self.statusImgView = [[UIImageView alloc] init];
    self.statusImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.containerView addSubview:self.statusImgView];
    
    self.contentLab = [[UILabel alloc] init];
    self.contentLab.numberOfLines = 0;
    self.contentLab.font = XKRegularFont(14.0);
    [self.containerView addSubview:self.contentLab];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.titleLabel.font = XKMediumFont(17.0);
    [self.confirmBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:XKMainTypeColor] forState:UIControlStateNormal];
    [self.containerView addSubview:self.confirmBtn];
    self.confirmBtn.layer.cornerRadius = 4.0;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.clipsToBounds = YES;
    [self.confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateViews {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_right);
        make.bottom.mas_equalTo(self.containerView.mas_top).offset(-16.0);
        make.width.height.mas_equalTo(24.0);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(270.0);
//        make.height.mas_equalTo(267.0);
    }];
    
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25.0);
        make.centerX.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(96.0);
    }];
    
    [self.contentLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusImgView.mas_bottom).offset(18.0);
        make.leading.mas_equalTo(15.0);
        make.trailing.mas_equalTo(-15.0);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(30.0);
        make.leading.mas_equalTo(15.0);
        make.trailing.mas_equalTo(-15.0);
        make.height.mas_equalTo(35.0);
        make.bottom.mas_equalTo(-25.0);
    }];
}

- (void)closeBtnAction:(UIButton *)sender {
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

- (void)confirmBtnAction:(UIButton *) sender {
    if (self.confirmBtnBlock) {
        self.confirmBtnBlock();
    }
}

- (void)setViewType:(XKLotteryTicketAnnouncementTipsViewType)viewType {
    if (viewType == XKLotteryTicketAnnouncementTipsViewTypeWin) {
        self.statusImgView.image = IMG_NAME(@"xk_img_lotteryTicket_tips_win");
    } else if (viewType == XKLotteryTicketAnnouncementTipsViewTypeLose) {
        self.statusImgView.image = IMG_NAME(@"xk_img_lotteryTicket_tips_lose");
    }
}

- (void)setContentStr:(NSAttributedString *)contentStr {
    _contentStr = contentStr;
    self.contentLab.attributedText = _contentStr;
    [self layoutIfNeeded];
    if (CGRectGetHeight(self.contentLab.frame) > self.contentLab.font.pointSize * 2.0) {
        self.contentLab.textAlignment = NSTextAlignmentLeft;
    } else {
        self.contentLab.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setConfirmBtnTitle:(NSString *)confirmBtnTitle {
    _confirmBtnTitle = confirmBtnTitle;
    [self.confirmBtn setTitle:_confirmBtnTitle forState:UIControlStateNormal];
}

@end
