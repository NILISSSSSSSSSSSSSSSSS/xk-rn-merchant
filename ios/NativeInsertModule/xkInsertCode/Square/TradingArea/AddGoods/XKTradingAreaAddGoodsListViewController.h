//
//  XKTradingAreaAddGoodsListViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    GoodsListType_addGoods,//加购
    GoodsListType_payAddGoods,//加购支付
    GoodsListType_refundGoods,//退加购商品  /*暂无这种情况*/
    GoodsListType_lookGoods,//查看商品
} GoodsListType;

@interface XKTradingAreaAddGoodsListViewController : BaseViewController

@property (nonatomic, assign) GoodsListType listType;
@property (nonatomic, copy  ) NSArray *goodsArr;//二维数组 (payAddGoods时是包含orderItems的模型)

@property (nonatomic, copy  ) NSString *itemId;//addGoods时传
@property (nonatomic, copy  ) NSString *orderId;//addGoods时传
@property (nonatomic, copy  ) NSString *shopId;//addGoods时传
@property (nonatomic, copy  ) NSString *seatName;//lookGoods时传

@end
