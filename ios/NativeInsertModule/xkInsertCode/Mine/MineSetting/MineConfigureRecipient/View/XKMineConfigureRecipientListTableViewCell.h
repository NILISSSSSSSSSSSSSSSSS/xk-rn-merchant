//
//  XKMineConfigureRecipientListTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineConfigureRecipientListTableViewCell;
@class XKMineConfigureRecipientItem;

@protocol XKMineConfigureRecipientListTableViewCellDelegate <NSObject>

- (void)configureRecipientList:(XKMineConfigureRecipientListTableViewCell *)cell clickEditingButton:(UIButton *)sender;

@end

@interface XKMineConfigureRecipientListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<XKMineConfigureRecipientListTableViewCellDelegate> delegate;

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem;
- (void)showCellSeparator;
- (void)hiddenCellSeparator;

@end
