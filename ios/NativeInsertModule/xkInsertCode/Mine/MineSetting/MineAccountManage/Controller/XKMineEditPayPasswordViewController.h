//
//  XKMineEditPayPasswordViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKMineEditPayPasswordViewControllerState) {
    XKMineEditPayPasswordViewControllerStateSetPayPassword = 0,     /** 未设置支付密码 */
    XKMineEditPayPasswordViewControllerStateVerifyPayPassword,      /** 已设置支付密码，验证支付密码 */
    XKMineEditPayPasswordViewControllerStateChangePayPassword,      /** 输入新的支付密码 */
    XKMineEditPayPasswordViewControllerStateConfirmPayPassword      /** 确认并提交支付密码 */
};

@interface XKMineEditPayPasswordViewController : BaseViewController

@property (nonatomic, assign) XKMineEditPayPasswordViewControllerState state;
@property (nonatomic, strong) NSString *lastStapInputPasswordString;    /** 首次输入支付密码 */ 

@end
