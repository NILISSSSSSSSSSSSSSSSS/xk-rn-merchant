//
//  XKLotteryTicketChooseNumberCollectionViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketChooseNumberCollectionViewCell.h"
#import "XKLotteryTicketBallVIew.h"

@interface XKLotteryTicketChooseNumberCollectionViewCell ()

@property (nonatomic, strong) XKLotteryTicketBallVIew *ball;

@end

@implementation XKLotteryTicketChooseNumberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        self.ball = [[XKLotteryTicketBallVIew alloc] init];
        [self.contentView addSubview:self.ball];
        [self.ball mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configCellWithNumber:(NSUInteger)number {
    self.ball.title = [NSString stringWithFormat:@"%02tu", number];
}

- (void)setCellSelected:(BOOL)selected tintColor:(nonnull UIColor *)tintColor {
    
    self.ball.ballSelected = selected;
    self.ball.ballColor = tintColor;
}

@end
