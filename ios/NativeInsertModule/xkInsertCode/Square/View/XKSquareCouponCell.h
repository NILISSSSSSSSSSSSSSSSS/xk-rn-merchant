//
//  XKSquareCouponCell.h
//  XKSquare
//
//  Created by hupan on 2018/10/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKSquareCardCouponModel;

@interface XKSquareCouponCell : UITableViewCell

@property (nonatomic, copy) void(^useBtnBlock)(XKSquareCardCouponModel *theCardCoupon);

- (void)configCellWithCardCouponModel:(XKSquareCardCouponModel *)cardCoupon;

@end
