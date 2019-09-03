/*******************************************************************************
 # File        : CommonSegmentControl.h
 # Project     : testDemo
 # Author      : fakepinge
 # Created     : 2017/5/3
 # Corporation : 成都晓可有限公司
 # Description :
 多段选择器
 -------------------------------------------------------------------------------
 # Date        : 2017.05.03
 # Author      : fakepinge
 # Notes       :
 多段选择器
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface CommonSegmentControl : UIView

/**
 * 标题
 * 支持字符串
 */
@property (nonatomic, readonly, copy) NSArray * _Nonnull itemArray;
/**
 * segment的背景色
 * 不设置的话会采用默认值
 */
@property (nonatomic, strong) UIColor * _Nullable segmentBackgroundColor;
/**
 * segment的字体颜色
 * 不设置的话采用默认值
 */
@property (nonatomic, strong) UIColor * _Nullable titleColor;
/**
 * segment选中时的字体颜色
 * 不设置的话采用默认值
 */
@property (nonatomic, strong) UIColor * _Nullable selectColor;
/**
 * segment标题的字体
 * 不设置的采用默认值
 */
@property (nonatomic, strong) UIFont  * _Nullable titleFont;

/**
 * segment标题的字体
 * 不设置的采用默认值
 */
@property (nonatomic, strong) UIFont  * _Nullable selectFont;

/**
 * segment的下划线的颜色
 * 不设置的采用默认的红色
 */
@property (nonatomic, strong) UIColor * _Nullable lineColor;
/**
 * 自定义下标
 * 不设置 默认0
 */
@property (nonatomic, assign) NSInteger selectedIndex;
/**
 * segment的下划线的宽度
 * 不设置的采用和item等宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 用的时候注意 lineWidthArray和linewidth互斥的只能设置一个 lineWidthArray优先级高
 * segment的下划线的宽度数组，处理下划线宽度不同的情况
 * 不设置的采用lineWidth
 */
@property (nonatomic, strong) NSArray * _Nullable lineWidthArray;

/**
 * segment下划线动画的时间
 * 不设置的话默认0.5s
 */
@property (nonatomic, assign) CGFloat duration;

/**
 初始化

 @param frame segment的frame
 @param items items 标题数组
 @param superView segment要添加的view
 @return 返回segment
 */
+ (instancetype _Nonnull)segmentWithFrame:(CGRect)frame items:(NSArray * _Nonnull)items toSuperView:(UIView * _Nullable)superView swipView:(UIView * _Nullable)swipView;

/**
 初始化
 
 @param frame segment的frame
 @param items items 标题数组
 @param superView segment要添加的view
 @return 返回segment
 */
- (instancetype _Nonnull)initWithFrame:(CGRect)frame items:(NSArray * _Nonnull)items toSuperView:(UIView * _Nullable)superView swipView:(UIView * _Nullable)swipView;

/**
 *  添加点击事件
 *
 *  @param target 调用对象
 *  @param action 方法
 */
- (void)addTarget:(_Nonnull id)target action:(SEL _Nonnull)action;

/**
 设置红点提示文本
 
 @param badgeValue 红点文本，无红点传入nil
 @param index 位置
 @param bgColor 背景颜色
 @param textColor 文本颜色
 */
- (void)setBadgeValue:(NSString * _Nullable)badgeValue index:(NSInteger)index bgColor:(UIColor * _Nullable)bgColor textColor:(UIColor * _Nullable)textColor;

@end

