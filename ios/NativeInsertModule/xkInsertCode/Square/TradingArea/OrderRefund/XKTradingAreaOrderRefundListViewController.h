//
//  XKTradingAreaOrderRefundListViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
@class OrderItems;

@interface XKTradingAreaOrderRefundListViewController : BaseViewController

@property (nonatomic, copy  ) NSArray<OrderItems *> *arr;
@property (nonatomic, copy  ) NSString   *shopName;


@end
