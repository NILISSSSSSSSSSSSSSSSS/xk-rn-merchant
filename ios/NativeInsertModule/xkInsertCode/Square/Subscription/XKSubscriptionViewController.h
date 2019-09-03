//
//  XKSubscriptionViewController.h
//  XKSquare
//
//  Created by hupan on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RefreshBlock)(void);

@interface XKSubscriptionViewController : BaseViewController

@property (nonatomic, copy  ) RefreshBlock  refreshBlock;

@end
