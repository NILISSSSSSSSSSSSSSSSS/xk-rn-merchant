//
//  XKPayAlertSheetView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKPayAlertSheetView : UIView
@property (nonatomic, strong) void(^payResult)(BOOL result);

+ (void)showWithResultBlock:(void(^)(NSInteger index))choseBlock;

- (void)dismissSelf;


@end
