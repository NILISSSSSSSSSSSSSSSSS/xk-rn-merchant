//
//  XKClearVideoDisplayViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKClearVideoDisplayViewController : UIViewController

- (void)Action_displayVideoWithParams:(NSDictionary *)params;
- (UIView *)getTransitonFromView;
- (UIView *)getTransitonToView;

@end
