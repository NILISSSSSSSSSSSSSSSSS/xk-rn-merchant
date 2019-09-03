//
//  XKMineConfigureRecipientEditRegionTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineConfigureRecipientEditRegionTableViewCell;
@class XKMineConfigureRecipientItem;

@protocol XKMineConfigureRecipientEditRegionTableViewCellDelegate <NSObject>

- (void)regionCellDidSelected:(XKMineConfigureRecipientEditRegionTableViewCell *)cell;

@end

@interface XKMineConfigureRecipientEditRegionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKMineConfigureRecipientEditRegionTableViewCellDelegate> delegate;

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem;

@end
