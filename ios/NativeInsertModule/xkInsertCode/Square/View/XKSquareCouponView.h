//
//  XKSquareCouponView.h
//  XKSquare
//
//  Created by hupan on 2018/10/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKSquareCardCouponModel;

typedef void(^CloseBlock)(void);

@interface XKSquareCouponView : UIView

@property (nonatomic, copy) NSArray <XKSquareCardCouponModel *>*cardCoupons;

@property (nonatomic, copy) void(^useBtnBlock)(XKSquareCardCouponModel *theCardCoupon);

@property (nonatomic, copy) CloseBlock closeBlock;

@end
