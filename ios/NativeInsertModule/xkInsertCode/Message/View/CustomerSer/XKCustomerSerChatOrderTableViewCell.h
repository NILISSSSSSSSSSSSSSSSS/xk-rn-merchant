//
//  XKCustomerSerChatOrderTableViewCell.h
//  XKSquare
//
//  Created by william on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelfareOrderDataItem;
@class MallOrderListDataItem;

@interface XKCustomerSerChatOrderTableViewCell : UITableViewCell

- (void)configCellWithWelfareOrder:(WelfareOrderDataItem *)welfareOrder;

- (void)configCellWithPlatformOrder:(MallOrderListDataItem *)platformOrder;

- (void)setCellSelected:(BOOL) selected;

@end
