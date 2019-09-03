//
//  XKAddBankCardViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddBankCard)(void);

@interface XKAddBankCardViewController : BaseViewController

@property (nonatomic, copy  ) AddBankCard  addBankCard;

@end
