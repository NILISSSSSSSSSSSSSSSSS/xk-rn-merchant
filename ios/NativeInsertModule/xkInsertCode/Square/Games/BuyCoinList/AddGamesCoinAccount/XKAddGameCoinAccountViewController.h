//
//  XKAddGameCoinAccountViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddGameCoinAccount)(void);

@interface XKAddGameCoinAccountViewController : BaseViewController

@property (nonatomic, copy  ) AddGameCoinAccount  addGameCoinAccount;

@end
