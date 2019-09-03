//
//  BaseViewController.h
//  eptcoininfo
//
//  Created by 胡廉伟 on 2018/3/7.
//  Copyright © 2018年 Eptonic. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RNBaseView : UIView
/**
 入口 1 为订单主页面进入 此时需要隐藏导航栏   默认0位正常进入
 */
@property (nonatomic, assign) NSInteger  entryType;
@property (nonatomic, strong) void(^refreshListBlock)(void);
/**
 导航栏颜色状态
 强行改颜色 不用关心图片和原本文字颜色
 基类layoutsubview里会根据风格统一改变所有颜色
 */
@property(nonatomic, assign) BaseNavStyle navStyle;
@property (nonatomic, strong) UIView *navigationView;
/*圆角view  tableview的**/
@property (nonatomic, strong)UIView *tableHeaderView;
@property (nonatomic, strong)UIView *tableFooterView;

/**透明的头尾视图*/
@property (nonatomic, strong)UIView *clearHeaderView;
@property (nonatomic, strong)UIView *clearFooterView;
- (void)setMidBtnWithImage:(UIImage *)image;

/**内容视图 使用自定义的navigationView时，hud框加在self.view上时，网络请求无响应时会导致无法点击返回。
 so视图布局请放置在containView里面 hud加在框也加在此处 。
 containView使用masonry布局 视图顶部距离self.view顶部偏移导航栏高度。
 如没有导航栏或者自定义其他导航栏改变containView y值 可使用masonry更新mas_top约束
 */
@property(nonatomic, strong, readonly) UIView *containView;

/**
 用于网络出错提示
 */
@property(nonatomic, strong) XKEmptyPlaceView *emptyTipView;
@property (nonatomic, strong) UIScrollView  *bgScrollView;
/**
 隐藏NavigationBar
 */
- (void)hideNavigation;
/**
 隐藏NavigationBar底部的线
 */
- (void)hideNavigationSeperateLine;

/**
 隐藏返回按钮
 */
- (void)hiddenBackButton:(BOOL)hidden;
/**
 隐藏右侧按钮
 */
- (void)hiddenRightButton:(BOOL)hidden;
/**
 设置Navigation标题

 @param string 标题
 @param color 颜色
 */
- (void)setNavTitle:(NSString *)string WithColor:(UIColor *)color;

/**
 设置Navigation富文本标题

 @param attributedTitle 富文本
 */
- (void)setNavAttributedTitle:(NSAttributedString *)attributedTitle;

/**
 设置返回按钮

 @param image 返回图标 传nil为默认
 @param string 返回文字 传nil为空
 */
- (void)setBackButton:(UIImage *)image andName:(NSString *)string;


/**
 设置导航栏customview
 
 @param view view
 @param rect rect
 */
- (void)setNaviCustomView:(UIView *)view withframe:(CGRect)rect;

/**
 设置导航栏左边view

 @param view view
 @param rect rect
 */
- (void)setLeftView:(UIView *)view withframe:(CGRect)rect;

/**
 设置导航栏中间view
 
 @param view view
 @param rect rect
 */
- (void)setMiddleView:(UIView *)view withframe:(CGRect)rect;

/**
 设置导航栏右边view
 
 @param view view
 @param rect rect
 */
- (void)setRightView:(UIView *)view withframe:(CGRect)rect;

/**
 重写时用
 */
- (void)backBtnClick;

/**
 处理默认数据
 */
- (void)handleData;

/**
 处理自定义视图
 */
- (void)addCustomSubviews;

- (void)resetMJHeaderFooter:(RefreshDataStatus)refreshStatus tableView:(UIScrollView *)tableView dataArray:(NSArray *)dataArry;


@end
