//
//  XKMineConfigureRecipientEditTagTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineConfigureRecipientItem;
@class XKMineConfigureRecipientEditTagTableViewCell;

@protocol XKMineConfigureRecipientEditTagTableViewCellDelegate <NSObject>

- (void)addressTagCellDidSelected:(XKMineConfigureRecipientEditTagTableViewCell *)cell;

@end

@interface XKMineConfigureRecipientEditTagTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKMineConfigureRecipientEditTagTableViewCellDelegate> delegate;

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem;

@end
