//
//  XKCoinRechargeStatusViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSInteger {
    RechargeStatusVC_success,
    RechargeStatusVC_fail,
} RechargeStatusVC;

@interface XKCoinRechargeStatusViewController : BaseViewController

@property (nonatomic, assign) RechargeStatusVC rechargeStatusVC;

@end
