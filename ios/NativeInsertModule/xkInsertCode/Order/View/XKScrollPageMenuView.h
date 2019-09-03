//
//  XMScrollPageMenu.h
//  KuaiPin
//
//  Created by 21_xm on 16/5/10.
//  Copyright © 2016年 21_xm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMTopButtonsView;
@protocol XMTopButtonsViewDelegate <NSObject>

- (void)topView:(XMTopButtonsView *)topView didSelectedBtnAtIndex:(NSInteger)index;

@end

@interface XMTopButtonsView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id <XMTopButtonsViewDelegate> delegate;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger selectedPageIndex;

@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *slider;
@property (nonatomic, assign) CGFloat height;
//1 滚动  0点击
@property (nonatomic, assign) NSInteger type;

// 标题文字
/** 上面的标题默认颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 上面的标题选中后颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 上面的标题文字大小 */
@property (nonatomic, strong) UIFont *titleFont;
/** 上面的标题选中后文字大小 */
@property (nonatomic, strong) UIFont *titleSelectedFont;
/** 每一行所显示的按钮个数 */
@property (nonatomic, assign) NSInteger numberOfTitles;


// 滑块
/** 文字下面滑块的颜色 */
@property (nonatomic, strong) UIColor *sliderColor;
/** 文字下面滑块Size */
@property (nonatomic, assign) CGSize sliderSize;


@property (nonatomic, strong) NSMutableArray *btns;

@end

@interface XKScrollPageMenuView : UIView

@property (nonatomic, weak) XMTopButtonsView *topView;
/** 背景scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic, strong) NSArray *childViews;
/** 上面的标题需要显示的问题的数组 */
@property (nonatomic, strong) NSArray *titles;
/** 默认选中的页面 */
@property (nonatomic, assign) NSInteger selectedPageIndex;
/** 选中的回调 */
@property (nonatomic, copy) void(^selectedBlock)(NSInteger index);
/** 每一行所显示的按钮个数 */
@property (nonatomic, assign) NSInteger numberOfTitles;
/** 上面滚动标题的整体高度 */
@property (nonatomic, assign) CGFloat titleBarHeight;


// 标题文字
/** 上面的标题默认颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 上面的标题选中后颜色 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/** 上面的标题默认文字大小 */
@property (nonatomic, strong) UIFont *titleFont;
/** 上面的标题选中后文字大小 */
@property (nonatomic, strong) UIFont *titleSelectedFont;
/** 上面的背景色 */
@property (nonatomic, strong) UIColor  *topBgColor;

// 滑块
/** 文字下面滑块的颜色 */
@property (nonatomic, strong) UIColor *sliderColor;
/** 文字下面滑块frame */
@property (nonatomic, assign) CGSize sliderSize;



/**
 是否显示/隐藏红点
 
 @param index 位置
 @param hidden 是否显示
 */
- (void)operationRedTipForIndex:(NSInteger)index isHidden:(BOOL)hidden;
@end
