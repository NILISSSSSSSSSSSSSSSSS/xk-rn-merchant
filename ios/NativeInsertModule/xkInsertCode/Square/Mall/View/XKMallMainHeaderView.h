//
//  XKMallMainHeaderView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallMainHeaderView : UIView
@property (nonatomic, copy) void (^layoutBlock)(UIButton *sender);
@end
