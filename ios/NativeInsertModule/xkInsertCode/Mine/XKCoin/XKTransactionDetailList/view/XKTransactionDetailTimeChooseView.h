//
//  XKTransactionDetailTimeChooseView.h
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)(void);
typedef void(^SureBlock)(NSString *time1, NSString *time2, NSString *time3, NSInteger way);//time1 按月的日期 time2按日的开始日期 time3按日的结束日期 way(0 按月  1按日)

@interface XKTransactionDetailTimeChooseView : UIView

@property (nonatomic, copy  ) CancelBlock  cancelBlock;
@property (nonatomic, copy  ) SureBlock    sureBlock;

@end
