//
//  XKWelfareOrderViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

@interface XKWelfareOrderViewController : BaseViewController
/**
 入口 1 为订单主页面进入 此时需要隐藏导航栏   默认0位正常进入
 */
@property (nonatomic, assign) NSInteger  entryType;
@end
