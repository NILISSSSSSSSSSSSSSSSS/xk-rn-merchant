//
//  XKTradingAreaGoodsDetailViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    GoodsType_offline,//现场购买
    GoodsType_online,//外卖
    GoodsType_sever,//服务
    GoodsType_hotel,//酒店
} GoodsType;

@interface XKTradingAreaGoodsDetailViewController : BaseViewController
@property (nonatomic, copy  ) NSString   *goodsId;
@property (nonatomic, copy  ) NSString   *shopId;

@property (nonatomic, assign) BOOL        isAdd;//是否是加购
@property (nonatomic, copy  ) NSString    *itemId;//加购时传
@property (nonatomic, copy  ) NSString    *orderId;//加购时传

@end
