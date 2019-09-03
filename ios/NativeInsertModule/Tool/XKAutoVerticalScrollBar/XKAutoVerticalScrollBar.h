//
//  XKAutoVerticalScrollBar.h
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XKAutoVerticalScrollDelegate

@optional
// 点击代理
- (void)noticeScrollDidClickAtIndex:(NSInteger)index content:(NSString *)content;

@end


@interface XKAutoVerticalScrollBar : UIView

@property (nonatomic, weak) id<XKAutoVerticalScrollDelegate> delegate;

// 滚动文字数组
@property (nonatomic, strong) NSArray        *contents;

// 文字停留时长，默认4S
@property (nonatomic, assign) NSTimeInterval timeInterval;

// 文字滚动时长，默认0.3S
@property (nonatomic, assign) NSTimeInterval scrollTimeInterval;

@end
