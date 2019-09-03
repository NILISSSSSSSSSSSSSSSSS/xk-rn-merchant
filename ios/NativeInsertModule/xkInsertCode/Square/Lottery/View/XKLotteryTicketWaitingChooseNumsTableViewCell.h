//
//  XKLotteryTicketWaitingChooseNumsTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketWaitingChooseNumsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, copy) void(^confirmBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
