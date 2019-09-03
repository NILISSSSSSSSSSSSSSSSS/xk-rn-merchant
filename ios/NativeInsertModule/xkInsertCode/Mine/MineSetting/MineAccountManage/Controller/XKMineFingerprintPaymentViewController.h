//
//  XKMineFingerprintPaymentViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKMineFingerprintPaymentViewControllerType) {
    XKMineFingerprintPaymentViewControllerTypeTouchId = 0,    /** TouchID */
    XKMineFingerprintPaymentViewControllerTypeFaceId          /** FaceID */
};

typedef NS_ENUM(NSInteger, XKMineFingerprintPaymentViewControllerState) {
    XKMineFingerprintPaymentViewControllerStateNotAvailable = 0,    /** 未开通指纹支付 */
    XKMineFingerprintPaymentViewControllerStateOpened               /** 已开通指纹支付 */
};

@interface XKMineFingerprintPaymentViewController : BaseViewController

@property (nonatomic, assign) XKMineFingerprintPaymentViewControllerType type;
@property (nonatomic, assign) XKMineFingerprintPaymentViewControllerState state;

@end
