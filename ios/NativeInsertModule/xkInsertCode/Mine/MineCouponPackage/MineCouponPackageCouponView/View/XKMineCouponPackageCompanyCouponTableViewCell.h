//
//  XKMineCouponPackageCompanyCouponTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineCouponPackageCouponItem;
@class XKMineCouponPackageCompanyCouponTableViewCell;

@protocol XKMineCouponPackageCompanyCouponTableViewCellDelegate <NSObject>

- (void)companyCouponTableViewCell:(XKMineCouponPackageCompanyCouponTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCouponItem *)couponItem;

@end

/** 晓可券 & 过期晓可券Cell */
@interface XKMineCouponPackageCompanyCouponTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<XKMineCouponPackageCompanyCouponTableViewCellDelegate> delegate;

- (void)configCellWithModel:(XKMineCouponPackageCouponItem *)model;
- (void)configOverdueCellWithModel:(XKMineCouponPackageCouponItem *)model;

- (void)showSelectButton;
- (void)hiddenSelectButton;

- (void)showCountChangeView;
- (void)hiddenCountChangeView;

- (void)showCountLabel;
- (void)hiddenCountLabel;

@end
