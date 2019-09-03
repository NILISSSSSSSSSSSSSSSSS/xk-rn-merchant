//
//  XKTradingAreaPayStatusViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSInteger {
    PayStatusVC_success,//支付失败
    PayStatusVC_fail,//支付成功
    PayStatusVC_share,//分享
} PayStatusVC;

@interface XKTradingAreaPayStatusViewController : BaseViewController

@property (nonatomic, assign) PayStatusVC  payStatus;

@end
