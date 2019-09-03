//
//  XKPlatFormTicketTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKLotteryTicketModel;

@interface XKPlatFormTicketTableViewCell : UITableViewCell

- (void)configCellWithLotteryTicketModel:(XKLotteryTicketModel *) lotteryTicket;

@end

NS_ASSUME_NONNULL_END
