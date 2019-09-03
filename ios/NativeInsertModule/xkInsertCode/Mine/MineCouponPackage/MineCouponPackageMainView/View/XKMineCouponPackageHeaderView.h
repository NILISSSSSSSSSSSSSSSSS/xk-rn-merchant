//
//  XKMineCouponPackageHeaderView.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineCouponPackageHeaderView;

@protocol XKMineCouponPackageHeaderViewDelegate <NSObject>

- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickCard:(UIControl *)sender;
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickCoupon:(UIControl *)sender;
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickRecentControl:(UIControl *)sender;
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickOldControl:(UIControl *)sender;
- (void)headerView:(XKMineCouponPackageHeaderView *)headerView clickCardOrCouponTypeButton:(UIButton *)button;

@end

@interface XKMineCouponPackageHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<XKMineCouponPackageHeaderViewDelegate> delegate;

- (void)configHeaderViewWithCountDictionary:(NSDictionary *)dataDict;

@end
