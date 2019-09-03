//
//  XKReceiveCouponModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKReceiveCouponModel : NSObject

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString *couponName;

@property (nonatomic, copy) NSString *couponType;

@property (nonatomic, assign) NSUInteger validTime;

@property (nonatomic, assign) NSUInteger invalidTime;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) NSString *shopPic;

@property (nonatomic, copy) NSString *condition;


@property (nonatomic, assign) BOOL isReceived;

@end

NS_ASSUME_NONNULL_END
