//
//  XKMineCouponPackageTerminalCardTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKMineCouponPackageCardItem;
@class XKMineCouponPackageTerminalCardTableViewCell;

@protocol XKMineCouponPackageTerminalCardTableViewCellDelegate <NSObject>

- (void)terminalCardTableViewCell:(XKMineCouponPackageTerminalCardTableViewCell *)tableViewCell updateModel:(XKMineCouponPackageCardItem *)cardItem;

@end

/** 商户卡 & 过期商户卡 */
@interface XKMineCouponPackageTerminalCardTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<XKMineCouponPackageTerminalCardTableViewCellDelegate> delegate;

- (void)configCellWithModel:(XKMineCouponPackageCardItem *)model;
- (void)configOverdueCellWithModel:(XKMineCouponPackageCardItem *)model;

- (void)showSelectButton;
- (void)hiddenSelectButton;

- (void)showCountChangeView;
- (void)hiddenCountChangeView;

- (void)showCountLabel;
- (void)hiddenCountLabel;

@end

NS_ASSUME_NONNULL_END
