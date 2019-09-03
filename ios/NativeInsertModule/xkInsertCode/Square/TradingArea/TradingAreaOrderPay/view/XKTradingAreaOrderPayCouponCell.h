//
//  XKTradingAreaOrderPayCouponCell.h
//  XKSquare
//
//  Created by hupan on 2018/11/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKTradingAreaOrderCouponModel;

typedef void(^ChooseCouponBlock)(void);

@interface XKTradingAreaOrderPayCouponCell : UITableViewCell

@property (nonatomic, copy  ) ChooseCouponBlock  chooseCouponBlock;

- (void)setValueWithModel:(XKTradingAreaOrderCouponModel *)model totalPrice:(CGFloat)totalPrice reducePrice:(CGFloat)reducePrice depositPrice:(CGFloat)depositPrice couponNum:(NSInteger)couponNum;

@end
