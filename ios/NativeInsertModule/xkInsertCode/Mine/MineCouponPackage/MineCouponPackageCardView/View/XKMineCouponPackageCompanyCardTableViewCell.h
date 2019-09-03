//
//  XKMineCouponPackageCompanyCardTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKMineCouponPackageCardItem;
@class XKMineCouponPackageCompanyCardTableViewCell;

@protocol XKMineCouponPackageCompanyCardTableViewCellDelegate <NSObject>

- (void)companyCardTableViewCell:(XKMineCouponPackageCompanyCardTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCardItem *)cardItem;

@end

/** 晓可卡 & 过期晓可卡 */
@interface XKMineCouponPackageCompanyCardTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<XKMineCouponPackageCompanyCardTableViewCellDelegate> delegate;

- (void)configCellWithModel:(XKMineCouponPackageCardItem *)cardItem;
- (void)configOverdueCellWithModel:(XKMineCouponPackageCardItem *)cardItem;

- (void)showSelectButton;
- (void)hiddenSelectButton;

- (void)showCountChangeView;
- (void)hiddenCountChangeView;

- (void)showCountLabel;
- (void)hiddenCountLabel;

@end

NS_ASSUME_NONNULL_END
