//
//  XKMineCouponPackageCouponModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKMineCouponPackageCouponItem :NSObject
@property (nonatomic, copy) NSString *couponId;
@property (nonatomic, assign) NSInteger invalidTime;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *couponType;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, assign) NSInteger validTime;
@property (nonatomic, copy) NSString *userCouponId;
@property (nonatomic, assign) NSInteger cards;
@property (nonatomic, assign) BOOL isSelected;  /** 是否被选中 */
@property (nonatomic, assign) NSInteger selectedCount; /** 选取数量 */
@end

@interface XKMineCouponPackageCouponModelDataItem :NSObject
@property (nonatomic, strong) NSArray <XKMineCouponPackageCouponItem *> *coupons;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopUrl;
@property (nonatomic, assign) BOOL isNeedSimplify;
@property (nonatomic, assign) BOOL isShowingAll;
@end

@interface XKMineCouponPackageCouponModel :NSObject
@property (nonatomic, strong) NSArray <XKMineCouponPackageCouponModelDataItem *> *data;
@property (nonatomic, assign) NSInteger total;
@end
