//
//  XKRegionPickerViewController.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKRegionPickerModel.h"

@class XKRegionPickerViewController;

@protocol XKRegionPickerViewControllerDelegate <NSObject>

/**
 *  地区选择回调方法
 *
 *  @param model 已选地区model
 */
- (void)regionPickerViewController:(XKRegionPickerViewController *)pickerViewController didSelectedRegion:(XKRegionPickerModel *)model;

@end

@interface XKRegionPickerViewController : UIViewController

@property (nonatomic, weak) id<XKRegionPickerViewControllerDelegate> delegate;

/**
 *  模态弹出地区选择器
 *
 *  @param viewController 调用控制器
 *
 *  @return 地区选择器
 */
+ (XKRegionPickerViewController *)showRegionPickerViewWithController:(UIViewController *)viewController;

/**
 *  模态弹出地区选择器
 *
 *  @param viewController 调用控制器
 *
 *  @param model 已选地区model
 *
 *  @return 地区选择器
 */
+ (XKRegionPickerViewController *)showRegionPickerViewWithController:(UIViewController *)viewController regionPickerModel:(XKRegionPickerModel *)model;

@end
