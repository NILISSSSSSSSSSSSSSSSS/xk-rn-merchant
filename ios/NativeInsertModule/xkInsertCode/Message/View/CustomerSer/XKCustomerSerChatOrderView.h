//
//  XKCustomerSerChatOrderView.h
//  XKSquare
//
//  Created by william on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKCustomerSerChatOrderView : UIView

@property (nonatomic, copy) void(^closeBtnBlock)(void);

@property (nonatomic, copy) void(^sendBtnBlock)(NSArray *array);

@end
