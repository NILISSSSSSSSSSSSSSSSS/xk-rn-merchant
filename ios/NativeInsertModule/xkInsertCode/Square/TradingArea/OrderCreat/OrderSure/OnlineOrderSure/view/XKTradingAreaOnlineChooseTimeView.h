//
//  XKTradingAreaOnlineChooseTimeView.h
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBlock)(NSString *date, NSString *time);

@interface XKTradingAreaOnlineChooseTimeView : UIView

@property (nonatomic, copy  ) SureBlock  sureBlock;

@end
