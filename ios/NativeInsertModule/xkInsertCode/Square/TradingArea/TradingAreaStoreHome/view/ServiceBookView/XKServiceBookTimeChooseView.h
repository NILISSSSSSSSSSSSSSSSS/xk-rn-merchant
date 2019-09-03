//
//  XKServiceBookTimeChooseView.h
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)(void);
typedef void(^SureBlock)(NSString *time);//2018-09-09 12:34:00
typedef void(^HotelChooseTimeBlock)(NSString *time);//time  2018-09-08

@interface XKServiceBookTimeChooseView : UIView

@property (nonatomic, copy  ) CancelBlock             cancelBlock;
@property (nonatomic, copy  ) SureBlock               sureBlock;
@property (nonatomic, copy  ) HotelChooseTimeBlock    timeBlock;


- (void)setCustomDatePickModel:(UIDatePickerMode)datePickerMode minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;

@end
