//
//  XKPayForMallViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

@interface XKPayForMallViewController : BaseViewController
@property (nonatomic, strong) void(^payResult)(BOOL success);
@end
