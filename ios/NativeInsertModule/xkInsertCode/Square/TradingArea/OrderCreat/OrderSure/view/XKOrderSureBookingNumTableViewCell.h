//
//  XKOrderSureBookingNumTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseBookingNumDelegate <NSObject>

- (void)chooseBookingNumber:(NSString *)oldNumber;

@end

@interface XKOrderSureBookingNumTableViewCell : UITableViewCell

@property (nonatomic, weak  ) id<ChooseBookingNumDelegate> delegate;

- (void)setValueWithSeatNames:(NSString *)seatNames;

@end
