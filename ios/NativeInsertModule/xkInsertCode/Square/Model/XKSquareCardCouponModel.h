//
//  XKSquareCardCouponModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/4.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKSquareCardCouponModel : NSObject
// 卡id
@property (nonatomic, copy) NSString *cardId;
// 卡说明
@property (nonatomic, copy) NSString *cardMessage;
// 卡名称
@property (nonatomic, copy) NSString *cardName;
// 卡类型 COUPON 优惠券 MEMBER_CARD 会员卡
@property (nonatomic, copy) NSString *cardType;
// 券类型 DISCOUNT 折扣券 DEDUCTION 抵扣券 FULL_SUB 满减券
@property (nonatomic, copy) NSString *couponType;
// 满减券减多少
@property (nonatomic, copy) NSString *condition;
// 用户领取卡id
@property (nonatomic, copy) NSString *cardCouponId;
// 有效期时间起 时间戳
@property (nonatomic, assign) NSUInteger validTime;
// 有效期时间止 时间戳
@property (nonatomic, assign) NSUInteger invalidTime;
// 价格
@property (nonatomic, assign) CGFloat price;
// 状态 1 可以使用 0 不可以使用
@property (nonatomic, assign) NSUInteger state;

@end

NS_ASSUME_NONNULL_END
