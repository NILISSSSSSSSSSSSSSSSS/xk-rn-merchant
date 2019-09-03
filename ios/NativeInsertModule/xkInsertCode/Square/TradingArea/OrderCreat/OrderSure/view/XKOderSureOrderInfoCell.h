//
//  XKOderSureOrderInfoCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
typedef void(^ChooseCouponPackageBlock)(NSString *CouponId);*/
typedef void(^OrderValueBlock)(NSString *seatName, NSString *peopleNum, NSString *tipStr, CGFloat totalPrice, BOOL refresh);

@interface XKOderSureOrderInfoCell : UITableViewCell
/*
@property (nonatomic, copy  ) ChooseCouponPackageBlock  chooseCouponBlock;*/
@property (nonatomic, copy  ) OrderValueBlock           orderValueBlock;
@property (nonatomic, copy  ) void(^chooseBookingNum)(void);

- (void)setValueWithSeatName:(NSString *)seatName peopleNum:(NSString *)peopleNum tipStr:(NSString *)tipStr totalPrice:(CGFloat)totalPrice;

@end
