//
//  XKWelfareShareView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKWelfareShareView : UIView
@property (nonatomic, strong) void(^closeBlock)(UIButton *sender);
@property (nonatomic, strong) void(^shareBlock)(UIButton *sender);
@property (nonatomic, copy) NSString  *urlStr;
@end
