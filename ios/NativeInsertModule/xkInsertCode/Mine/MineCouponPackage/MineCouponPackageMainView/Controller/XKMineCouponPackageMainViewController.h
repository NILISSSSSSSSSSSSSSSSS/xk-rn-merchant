//
//  XKMineCouponPackageMainViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKMineCouponPackageMainViewControllerCurrentTimeType) {
    XKMineCouponPackageMainViewControllerCurrentTimeTypeRecent= 0,       /**< 最近领取 */
    XKMineCouponPackageMainViewControllerCurrentTimeTypeOld              /**< 即将失效 */
};

typedef NS_ENUM(NSInteger, XKMineCouponPackageMainViewControllerFilterType) {
    XKMineCouponPackageMainViewControllerFilterTypeCompanyCard = 0,        /**< 晓可卡 */
    XKMineCouponPackageMainViewControllerFilterTypeTerminalCard,           /**< 商户卡 */
    XKMineCouponPackageMainViewControllerFilterTypeCompanyCoupon,          /**< 晓可券 */
    XKMineCouponPackageMainViewControllerFilterTypeTerminalCoupon,         /**< 商户券 */
};

@interface XKMineCouponPackageMainViewController : BaseViewController

@property (nonatomic, assign) XKMineCouponPackageMainViewControllerCurrentTimeType currentTimeType;
@property (nonatomic, assign) XKMineCouponPackageMainViewControllerFilterType currentFilterType;

@end
