//
//  XKTradingAreaOrderDetailViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

@interface XKTradingAreaOrderDetailViewController : BaseViewController

@property (nonatomic, copy  ) NSString   *orderId;

//是否是售后订单【只有商圈的售后订单列表才传此参数，其他任何地方都不传】
@property (nonatomic, assign) BOOL       isAfterSaleOrder;

//提供给推送时的刷新
- (void)refreshTradingAreaOrder;

@end
