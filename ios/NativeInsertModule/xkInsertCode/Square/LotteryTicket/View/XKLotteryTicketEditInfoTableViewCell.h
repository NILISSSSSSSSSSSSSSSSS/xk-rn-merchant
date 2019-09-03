//
//  XKLotteryTicketEditInfoTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLotteryTicketEditInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UITextField *contentTF;

- (void)configCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

- (void)setCellLineHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
