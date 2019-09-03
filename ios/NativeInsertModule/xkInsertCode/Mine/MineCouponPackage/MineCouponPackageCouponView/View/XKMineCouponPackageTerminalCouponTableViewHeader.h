//
//  XKMineCouponPackageTerminalCouponTableViewHeader.h
//  XKSquare
//
//  Created by RyanYuan on 2018/12/4.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKMineCouponPackageCouponModelDataItem;

@interface XKMineCouponPackageTerminalCouponTableViewHeader : UITableViewHeaderFooterView

- (void)configHeaderViewWithModel:(XKMineCouponPackageCouponModelDataItem *)model;

@end

NS_ASSUME_NONNULL_END
