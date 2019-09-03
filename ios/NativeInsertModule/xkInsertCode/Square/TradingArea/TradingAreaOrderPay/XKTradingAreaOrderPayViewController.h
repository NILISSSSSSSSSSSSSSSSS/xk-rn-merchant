//
//  XKTradingAreaOrderPayViewController.h
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
@class OrderItems;

typedef enum : NSUInteger {
    PayViewType_add,//加购（非主订单）
    PayViewType_service,//服务、酒店、服务加购（结合isMainOrder判断）
    PayViewType_offline,//现场消费 （主订单）
    PayViewType_takeoutSend,//外卖送货上门 （主订单）
    PayViewType_takeoutSelfTake,//外卖送到店自提 （主订单）
} PayViewType;

@interface XKTradingAreaOrderPayViewController : BaseViewController

@property (nonatomic, assign) PayViewType             type;
@property (nonatomic, copy  ) NSArray<OrderItems *>   *itemsArr;

//PayViewType_service 时才传
@property (nonatomic, assign) BOOL                    isMainOrder;// 用来区分是否是主单
@property (nonatomic, copy  ) NSString                *appointRange;//预约时间

@end
