//
//  XKReceiveXKCouponTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKReceiveCouponModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKReceiveXKCouponTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

- (void)configCellWithModel:(XKReceiveCouponModel *) XKCoupon;

@property (nonatomic, copy) void(^receiveBtnBlock)(XKReceiveCouponModel *coupon);

@end

NS_ASSUME_NONNULL_END
