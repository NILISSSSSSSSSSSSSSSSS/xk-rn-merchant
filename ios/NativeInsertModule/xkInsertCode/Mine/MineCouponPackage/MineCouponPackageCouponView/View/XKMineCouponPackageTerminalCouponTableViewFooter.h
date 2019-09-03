//
//  XKMineCouponPackageTerminalCouponTableViewFooter.h
//  XKSquare
//
//  Created by RyanYuan on 2018/12/4.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKMineCouponPackageTerminalCouponTableViewFooter;
@class XKMineCouponPackageCouponModelDataItem;

@protocol XKMineCouponPackageTerminalCouponTableViewFooterDelegate <NSObject>

- (void)tableViewFooter:(XKMineCouponPackageTerminalCouponTableViewFooter *)footer updateModel:(XKMineCouponPackageCouponModelDataItem *)model;

@end

@class XKMineCouponPackageCouponModelDataItem;

@interface XKMineCouponPackageTerminalCouponTableViewFooter : UITableViewHeaderFooterView

@property (nonatomic, weak) id<XKMineCouponPackageTerminalCouponTableViewFooterDelegate> delegate;

- (void)configFooterViewWithModel:(XKMineCouponPackageCouponModelDataItem *)model;

@end

NS_ASSUME_NONNULL_END
