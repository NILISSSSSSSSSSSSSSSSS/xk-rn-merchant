//
//  XKLotteryTicketAnnouncementHeader.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketAnnouncementHeader.h"

@interface XKLotteryTicketAnnouncementHeader ()

@property (nonatomic, strong) UIImageView *lotteryTicketImgView;

@property (nonatomic, strong) UILabel *lotteryTicketLab;

@property (nonatomic, strong) UILabel *lotteryTicketInfoLab;

@property (nonatomic, strong) UILabel *line;

@end

@implementation XKLotteryTicketAnnouncementHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    self.lotteryTicketImgView = [[UIImageView alloc] init];
    self.lotteryTicketImgView.image = IMG_NAME(@"xk_img_lotteryTicket_aaLotteryTicket");
    [self.containerView addSubview:self.lotteryTicketImgView];
    
    self.lotteryTicketLab = [[UILabel alloc] init];
    [self.containerView addSubview:self.lotteryTicketLab];
    
    self.lotteryTicketInfoLab = [[UILabel alloc] init];
    self.lotteryTicketInfoLab.font = XKRegularFont(14.0);
    [self.containerView addSubview:self.lotteryTicketInfoLab];
    
    self.line = [[UILabel alloc] init];
    self.line.backgroundColor = XKSeparatorLineColor;
    [self.containerView addSubview:self.line];
}

- (void)updateViews {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10.0, 10.0, 0.0, 10.0)).priorityHigh();
    }];
    
    [self.lotteryTicketImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10.0);
        make.centerY.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(40.0);
    }];
    
    [self.lotteryTicketLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lotteryTicketImgView);
        make.left.mas_equalTo(self.lotteryTicketImgView.mas_right).offset(15.0);
        make.trailing.mas_equalTo(-10.0);
    }];
    
    [self.lotteryTicketInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lotteryTicketImgView);
        make.left.mas_equalTo(self.lotteryTicketImgView.mas_right).offset(15.0);
        make.trailing.mas_equalTo(-10.0);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(self.containerView);
        make.height.mas_equalTo(1.0);
    }];
}

@end
