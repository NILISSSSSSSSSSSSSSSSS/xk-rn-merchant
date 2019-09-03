//
//  XKMineCouponPackageCardViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKMineCouponPackageCardViewControllerType) {
    XKMineCouponPackageCardViewControllerTypeNormalCompanyCard = 0,     /**< 可用晓可卡包列表 */
    XKMineCouponPackageCardViewControllerTypeNormalTerminalCard,        /**< 可用商户卡包列表 */
    XKMineCouponPackageCardViewControllerTypeOverdueCompanyCard,        /**< 过期晓可卡包列表 */
    XKMineCouponPackageCardViewControllerTypeOverdueTerminalCard        /**< 过期商户卡包列表 */
};

@interface XKMineCouponPackageCardViewController : BaseViewController

@property (nonatomic, assign) XKMineCouponPackageCardViewControllerType type;

@end
