//
//  XKMineConfigureRecipientEditLinkmanTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineConfigureRecipientEditLinkmanTableViewCell;
@class XKMineConfigureRecipientItem;

@protocol XKMineConfigureRecipientEditLinkmanTableViewCellDelegate <NSObject>

- (void)linkmanCell:(XKMineConfigureRecipientEditLinkmanTableViewCell *)cell clickAddressBookControl:(UIControl *)sender;

@end

@interface XKMineConfigureRecipientEditLinkmanTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKMineConfigureRecipientEditLinkmanTableViewCellDelegate> delegate;

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem;

@end
