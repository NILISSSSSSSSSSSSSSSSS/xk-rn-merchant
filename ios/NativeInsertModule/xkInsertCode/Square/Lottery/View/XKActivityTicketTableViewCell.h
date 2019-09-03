//
//  XKActivityTicketTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKLotteryTicketModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKActivityTicketTableViewCell : UITableViewCell

- (void)configCellWithLotteryTicketModel:(XKLotteryTicketModel *) lotteryTicket;

@end

NS_ASSUME_NONNULL_END
