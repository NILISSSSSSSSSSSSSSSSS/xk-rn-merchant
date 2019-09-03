//
//  XKVideoDisplayViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoDisplayMediator;

@interface XKVideoDisplayViewController : UIViewController

- (void)Action_displayVideoWithParams:(NSDictionary *)params;
- (UIView *)getTransitonFromView;
- (UIView *)getTransitonToView;

@end
