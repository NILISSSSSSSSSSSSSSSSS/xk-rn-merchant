//
//  XKChangePhonenumViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, XKChangePhonenumViewControllerType) {
    XKChangePhonenumViewControllerTypeChangePhoneNum = 0,   /** 修改绑定手机号（默认） */
    XKChangePhonenumViewControllerTypeSetPhoneNum   /** 首次绑定手机号 */
};

typedef void(^phoneBlock)(NSString *phone);

@interface XKChangePhonenumViewController : BaseViewController

@property (nonatomic, assign) XKChangePhonenumViewControllerType type;
@property (nonatomic, copy) phoneBlock block;
- (void)setPhoneBlock:(phoneBlock)block;

@end
