//
//  XKLotteryTicketAnnouncementFooter.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketAnnouncementFooter.h"

@implementation XKLotteryTicketAnnouncementFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmBtn.titleLabel.font = XKMediumFont(17.0);
        [self.confirmBtn setTitle:@"" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:HEX_RGB(0x777777) forState:UIControlStateDisabled];
        self.confirmBtn.backgroundColor = XKMainTypeColor;
        [self addSubview:self.confirmBtn];
        [self.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        self.confirmBtn.layer.cornerRadius = 8.0;
        self.confirmBtn.layer.masksToBounds = YES;
        self.confirmBtn.clipsToBounds = YES;
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20.0, 10.0, 20.0, 10.0)).priorityHigh();
        }];
    }
    return self;
}

- (void)confirmBtnAction {
    if (self.confirmBtnBlock) {
        self.confirmBtnBlock();
    }
}

@end
