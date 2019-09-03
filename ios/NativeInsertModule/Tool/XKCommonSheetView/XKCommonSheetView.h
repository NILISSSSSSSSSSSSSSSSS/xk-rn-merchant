//
//  XKCommonSheetView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AnimationWay_bottomSheet,
    AnimationWay_centerShow,
} AnimationWay;

@interface XKCommonSheetView : UIView
/**
 内容视图 要动画得 实现addSubview 以及 contentView两个方法
 */
@property (nonatomic, weak) UIView           *contentView;
@property (nonatomic, assign) AnimationWay   animationWay;
@property (nonatomic, assign) BOOL           addBottomSafeHeight;
@property (nonatomic, assign) BOOL           showing;
//设置蒙版距离下部高度（不设置就默认铺满）
@property (nonatomic, assign) CGFloat        shieldBottomHeight;

@property (nonatomic, copy  ) void(^dismissBlock)(void);

- (void)showWithNoShield;//没有黑色背景
- (void)show;//有黑色背景
- (void)showForShare;//高斯模糊
- (void)dismissShare;
- (void)dismiss;

@end
