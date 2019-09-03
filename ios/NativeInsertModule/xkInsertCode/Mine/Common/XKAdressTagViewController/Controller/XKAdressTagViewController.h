//
//  XKAdressTagViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKAdressTagViewController;

@protocol XKAdressTagViewControllerDelegate <NSObject>

/**
 *  地址标签选择回调方法
 *
 *  @param tagString 已选地址标签
 */
- (void)adressTagViewController:(XKAdressTagViewController *)viewController didSelectedTag:(NSString *)tagString;

@end

@interface XKAdressTagViewController : UIViewController

@property (nonatomic, weak) id<XKAdressTagViewControllerDelegate> delegate;

/**
 *  模态弹出地址标签选择器
 *
 *  @param viewController 调用控制器
 *
 *  @return 地址标签选择器
 */
+ (XKAdressTagViewController *)showRegionPickerViewWithController:(UIViewController *)viewController;

/**
 *  模态弹出地址标签选择器
 *
 *  @param viewController 调用控制器
 *
 *  @param tagString 已选地址标签
 *
 *  @return 地址标签选择器
 */
+ (XKAdressTagViewController *)showRegionPickerViewWithController:(UIViewController *)viewController tag:(NSString *)tagString;

@end
