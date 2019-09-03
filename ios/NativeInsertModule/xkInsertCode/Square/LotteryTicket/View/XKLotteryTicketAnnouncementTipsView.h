//
//  XKLotteryTicketAnnouncementTipsView.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XKLotteryTicketAnnouncementTipsViewType) {
    XKLotteryTicketAnnouncementTipsViewTypeWin = 1 << 0,
    XKLotteryTicketAnnouncementTipsViewTypeLose = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketAnnouncementTipsView : UIView

@property (nonatomic, assign) XKLotteryTicketAnnouncementTipsViewType viewType;

@property (nonatomic, strong) NSAttributedString *contentStr;

@property (nonatomic, copy) NSString *confirmBtnTitle;

@property (nonatomic, copy) void(^closeBtnBlock)(void);

@property (nonatomic, copy) void(^confirmBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
