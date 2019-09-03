//
//  XKGlobalNotificationView.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKGlobalNotificationView : UIView

- (void)initializeViews;

- (void)updateViews;
// 显示（带动画）
- (void)show;
// 消失（不带动画）
- (void)dismiss;
// 消失（是否带动画）
- (void)dismissWithAnimation:(BOOL)animationFlag;

@end

NS_ASSUME_NONNULL_END
