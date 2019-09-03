//
//  XKMallOrderApplyRefundViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, OrderStatus) {
    OrderStatusWaitSend = 0,
    OrderStatusWaitAccept,
    OrderStatusWaitEvaluate
};
@interface XKMallOrderApplyRefundViewController : BaseViewController

@property (nonatomic, strong) NSArray  *goodsArr;
@property (nonatomic, copy) NSString  *refundType;
@property (nonatomic, copy) NSString  *orderId;
@end
