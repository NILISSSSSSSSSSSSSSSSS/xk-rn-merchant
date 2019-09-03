//
//  XKMallOrderApplyRefundCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKMallOrderDetailViewModel.h"
#import "XKMallOrderViewModel.h"
@interface XKMallOrderApplyRefundCell : XKBaseTableViewCell
- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailGoodsItem *)model;
//订单退货
- (void)handleOrderObj:(MallOrderListObj *)obj;
@end
