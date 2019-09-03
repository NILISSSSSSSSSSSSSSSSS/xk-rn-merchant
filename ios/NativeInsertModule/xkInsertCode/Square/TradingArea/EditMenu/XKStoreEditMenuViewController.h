//
//  XKStoreEditMenuViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    Type_takeOut,//外卖
    Type_offline,//现场选购
    Type_sever,//服务
    Type_hotel,//酒店
} Type;

@interface XKStoreEditMenuViewController : BaseViewController

//必传参数
@property (nonatomic, assign) Type     type;
@property (nonatomic, copy  ) NSString *shopId;
@property (nonatomic, copy  ) NSString *severCode;

//非必传参数
@property (nonatomic, assign) BOOL     isAdd;//是否是加购
@property (nonatomic, copy  ) NSString *shopName;//加购时不传，非加购时传

@property (nonatomic, copy  ) NSString *itemId;//加购时传
@property (nonatomic, copy  ) NSString *orderId;//加购时传

@end
