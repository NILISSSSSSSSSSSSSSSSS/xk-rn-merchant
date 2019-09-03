//
//  XKMallOrderPayResultViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderBaseViewController.h"
#import "XKMallOrderViewModel.h"
@interface XKMallOrderPayResultViewController : XKMallOrderBaseViewController
@property (nonatomic, assign) NSInteger  payResult;
@property (nonatomic, strong) MallOrderListDataItem  *item;
@end
