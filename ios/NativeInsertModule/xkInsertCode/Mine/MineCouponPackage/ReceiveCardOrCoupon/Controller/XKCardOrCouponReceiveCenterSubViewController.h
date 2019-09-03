//
//  XKCardOrCouponReceiveCenterSubViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKReceiveCardModel;
@class XKReceiveCouponModel;

typedef NS_OPTIONS(NSUInteger, XKCardOrCouponReceiveCenterSubVCType) {
    XKCardOrCouponReceiveCenterSubVCTypeXKCard = 1 << 0,            // 晓可卡
    XKCardOrCouponReceiveCenterSubVCTypeMerchantCard = 1 << 1,      // 商户卡
    XKCardOrCouponReceiveCenterSubVCTypeXKCoupon = 1 << 2,          // 晓可券
    XKCardOrCouponReceiveCenterSubVCTypeMerchantCoupon = 1 << 3,    // 商户券
};

NS_ASSUME_NONNULL_BEGIN

@interface XKCardOrCouponReceiveCenterSubViewController : UIViewController

@property (nonatomic, assign) XKCardOrCouponReceiveCenterSubVCType vcType;

@property (nonatomic, copy) void(^receiveCardBtnBlock)(XKReceiveCardModel *card);

@property (nonatomic, copy) void(^receiveCouponBtnBlock)(XKReceiveCouponModel *card);

@end

NS_ASSUME_NONNULL_END
