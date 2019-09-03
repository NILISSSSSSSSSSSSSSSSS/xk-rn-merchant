//
//  XKLotteryTicketAnnouncementFooter.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketAnnouncementFooter : UIView

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) void(^confirmBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
