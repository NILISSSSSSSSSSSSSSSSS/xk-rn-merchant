//
//  XKSendMineCouponViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

@class XKSendMineCouponViewController;

@protocol XKSendMineCouponViewControllerDelegate <NSObject>

/**
 * 选择会员卡、优惠券回调方法
 *
 * @params viewController 控制器
 *
 * @params selectedArray 已选数组，包含会员卡（XKMineCouponPackageCardItem）、优惠券（XKMineCouponPackageCouponItem）
 *
 */
- (void)sendMineCouponViewController:(XKSendMineCouponViewController *)viewController selectedArray:(NSArray *)selectedArray;

@end

@interface XKSendMineCouponViewController : BaseViewController

@property (nonatomic, weak) id<XKSendMineCouponViewControllerDelegate> delegate;

@end
