//
//  XKLotteryTicketNumbersTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, XKLotteryTicketNumbersCellType) {
    XKLotteryTicketNumbersCellTypeText = 1 << 0,
    XKLotteryTicketNumbersCellTypeImg = 1 << 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketNumbersTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) XKLotteryTicketNumbersCellType cellType;

- (void)configBallsViewWithNums:(NSArray <NSNumber *>*)nums;

@end

NS_ASSUME_NONNULL_END
