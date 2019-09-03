//
//  XKMainOrderAfterSaleViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderBaseViewController.h"
#import "XKMallOrderViewModel.h"
@interface XKMallOrderAfterSaleViewController : XKMallOrderBaseViewController
- (void)updateModelWithItem:(MallOrderListDataItem *)item;
@end
