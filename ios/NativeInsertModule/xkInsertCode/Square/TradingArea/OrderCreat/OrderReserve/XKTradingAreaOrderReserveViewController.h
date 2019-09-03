//
//  XKTradingAreaOrderReserveViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"
@class GoodsSkuVOListItem;

typedef enum : NSUInteger {
    OrderReserveVC_service,//普通服务
    OrderReserveVC_hotel,//酒店
} OrderReserveVC;

@interface XKTradingAreaOrderReserveViewController : BaseViewController

@property (nonatomic, assign) OrderReserveVC              reserveVCType;

//服务类型的需要传时间（非酒店类型）
@property (nonatomic, copy  ) NSString                  *reserveTime;
//商圈商品都是一个模型 这里直接传模型
@property (nonatomic, strong) GoodsSkuVOListItem        *skuItem;

@end
