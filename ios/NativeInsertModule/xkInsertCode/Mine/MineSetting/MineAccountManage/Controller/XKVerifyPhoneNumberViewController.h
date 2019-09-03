//
//  XKVerifyPhoneNumberViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKVerifyPhoneNumberViewControllerState) {
    XKVerifyPhoneNumberViewControllerStateSetPayPassword = 0,     /** 未设置支付密码，验证后设置 */
    XKVerifyPhoneNumberViewControllerStateChangePayPassword,      /** 忘记支付密码，验证后设置新的支付密码 */
};

@interface XKVerifyPhoneNumberViewController : BaseViewController

@property (nonatomic, assign) XKVerifyPhoneNumberViewControllerState state;
@property (nonatomic, copy) NSString *phoneNum;

@end
