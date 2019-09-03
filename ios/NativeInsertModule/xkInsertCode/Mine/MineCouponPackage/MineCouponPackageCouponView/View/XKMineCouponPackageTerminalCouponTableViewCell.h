//
//  XKMineCouponPackageTerminalCouponTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineCouponPackageCouponItem;
@class XKMineCouponPackageTerminalCouponTableViewCell;

@protocol XKMineCouponPackageTerminalCouponTableViewCellDelegate <NSObject>

- (void)terminalCouponTableViewCell:(XKMineCouponPackageTerminalCouponTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCouponItem *)couponItem;

@end

/** 商户券 & 过期商户券Cell */
@interface XKMineCouponPackageTerminalCouponTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<XKMineCouponPackageTerminalCouponTableViewCellDelegate> delegate;

- (void)configCellWithModel:(XKMineCouponPackageCouponItem *)model;
- (void)configOverdueCellWithModel:(XKMineCouponPackageCouponItem *)model;

- (void)showSelectButton;
- (void)hiddenSelectButton;

- (void)showCountChangeView;
- (void)hiddenCountChangeView;

- (void)showCountLabel;
- (void)hiddenCountLabel;

@end
