//
//  XKMallOrderDetailWaitSendInfoCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderDetailViewModel.h"
@interface XKMallOrderDetailWaitSendInfoCell : UITableViewCell
//type 0 订单编号  1支付方式
- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model WithType:(NSInteger)type;
@end
