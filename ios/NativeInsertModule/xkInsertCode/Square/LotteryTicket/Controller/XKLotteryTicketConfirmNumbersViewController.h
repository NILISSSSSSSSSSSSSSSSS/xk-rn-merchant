//
//  XKLotteryTicketConfirmNumbersViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketConfirmNumbersViewController : BaseViewController
// 选的号码
@property (nonatomic, copy) NSArray <NSNumber *>*selectedNums;
// 注数
@property (nonatomic, assign) NSUInteger selectedLotteryTicketNum;

@end

NS_ASSUME_NONNULL_END
