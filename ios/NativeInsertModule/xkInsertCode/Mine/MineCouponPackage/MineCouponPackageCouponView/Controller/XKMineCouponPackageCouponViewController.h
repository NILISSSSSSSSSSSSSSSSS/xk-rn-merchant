//
//  XKMineCouponPackageCouponViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKMineCouponPackageCouponViewControllerType) {
    XKMineCouponPackageCouponViewControllerTypeNormalCompanyCoupon = 0,        /**< 可用晓可券包列表 */
    XKMineCouponPackageCouponViewControllerTypeNormalTerminalCoupon,           /**< 可用商户券包列表 */
    XKMineCouponPackageCouponViewControllerTypeOverdueCompanyCoupon,           /**< 过期晓可券包列表 */
    XKMineCouponPackageCouponViewControllerTypeOverdueTerminalCoupon           /**< 过期商户券包列表 */
};

@interface XKMineCouponPackageCouponViewController : BaseViewController

@property (nonatomic, assign) XKMineCouponPackageCouponViewControllerType type;

@end
