//
//  XKMineConfigureRecipientEditDefaultTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineConfigureRecipientItem;

@interface XKMineConfigureRecipientEditDefaultTableViewCell : UITableViewCell

- (void)configTableViewCell:(XKMineConfigureRecipientItem *)recipientItem isForceDefault:(BOOL)isForceDefault;

@end
