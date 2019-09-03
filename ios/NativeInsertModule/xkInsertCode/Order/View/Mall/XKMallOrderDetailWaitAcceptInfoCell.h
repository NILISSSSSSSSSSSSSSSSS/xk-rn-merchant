//
//  XKMallOrderDetailWaitAcceptInfoCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderDetailViewModel.h"
@interface XKMallOrderDetailWaitAcceptInfoCell : UITableViewCell
//type 0 订单编号  1支付方式 2 物流公司
- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model withType:(NSInteger)type;
@end
