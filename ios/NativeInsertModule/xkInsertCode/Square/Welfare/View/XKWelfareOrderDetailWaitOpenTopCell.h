//
//  XKWelfareOrderDetailWaitOpenTopCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKWelfareOrderDetailViewModel.h"
#import "XKWelfareOrderListViewModel.h"
@interface XKWelfareOrderDetailWaitOpenTopCell : UITableViewCell
- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model withOrderItem:(WelfareOrderDataItem *)item;
@end
