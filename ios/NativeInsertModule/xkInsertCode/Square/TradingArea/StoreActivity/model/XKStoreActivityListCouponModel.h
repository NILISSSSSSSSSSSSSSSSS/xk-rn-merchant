//
//  XKStoreActivityListCouponModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CouponItemModel;

@interface XKStoreActivityListCouponModel : NSObject

@property (nonatomic , strong) NSArray <CouponItemModel *>    * data;
@property (nonatomic , assign) NSInteger                      total;

@end



@interface CouponItemModel :NSObject

@property (nonatomic , copy) NSString              * couponId;
@property (nonatomic , copy) NSString              * couponName;
@property (nonatomic , copy) NSString              * couponType;
@property (nonatomic , copy) NSString              * invalidTime;
@property (nonatomic , copy) NSString              * message;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * shopId;
@property (nonatomic , copy) NSString              * shopName;
@property (nonatomic , copy) NSString              * shopPic;
@property (nonatomic , copy) NSString              * validTime;
@property (nonatomic , copy) NSString              * condition;
@property (nonatomic , assign) BOOL                whetherDraw;

@end


