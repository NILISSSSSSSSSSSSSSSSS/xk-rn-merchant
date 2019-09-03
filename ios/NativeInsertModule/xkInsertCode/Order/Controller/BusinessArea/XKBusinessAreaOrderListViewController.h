//
//  XKBusinessAreaOrderListViewController.h
//  XKSquare
//
//  Created by hupan on 2018/11/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    AreaOrderType_PICK = 0, //待接单
    AreaOrderType_PAY, //待支付
    AreaOrderType_USE, //待消费
    AreaOrderType_PREPARE,//备货中
    AreaOrderType_USEING,//进行中
    AreaOrderType_EVALUATE,//待评价
    AreaOrderType_FINISH,//已完成
    AreaOrderType_REFUND,//售后中
    AreaOrderType_CLOSED//已关闭
    
} AreaOrderType;

@interface XKBusinessAreaOrderListViewController : BaseViewController

@property (nonatomic, assign) AreaOrderType orderType;

@end
