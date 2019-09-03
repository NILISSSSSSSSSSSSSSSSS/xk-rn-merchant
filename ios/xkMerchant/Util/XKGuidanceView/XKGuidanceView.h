//
//  XKGuidanceView.h
//  XKSquare
//
//  Created by Lin Li on 2019/1/18.
//  Copyright © 2019 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKGuidanceView : UIView
/**
 初始化数据 一个个显示
 
 @param images 图片字符串
 @param imageframeArr 图片位置
 @param rectArr 矩形透明区位置
 */
- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr TransparentRect:(NSArray *)rectArr;

/**
 初始化数据 不规则显示
 
 @param images 图片字符串
 @param imageframeArr 图片位置 @[[NSValue valueWithCGRect:CGRectMake(20, 205, 170, 50)]]
 @param rectArr 矩形透明区位置
 @param orderArr 顺序 例：@[@2,@1,@3]表示第一个引导图是两个图片，第二个引导图是2个图片，第三个引导图是3个图片，数组的数量表示多少个引导页面，图片数量必须等于orderArr里面数字的总和，这里表示有6个图片
 */
- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr TransparentRect:(NSArray *)rectArr orderArr:(NSArray *)orderArr;

/**
 在指定view上显示蒙版（过渡动画） 不调用用此方法可使用 addSubview:自己添加展示
 */
- (void)showMaskViewInView:(UIView *)view;

/**
 *  销毁蒙版view(默认点击空白区自动销毁)
 */
- (void)dismissMaskView;


/**
 初始化数据 一个个显示

 @param imageName 图片字符串
 @param imageframeValue 图片位置
 @param transparentRectValue 矩形透明区位置
 */
- (void)addImage:(NSString *)imageName imageFrame:(NSValue *)imageframeValue TransparentRect:(NSValue *)transparentRectValue;
@end

NS_ASSUME_NONNULL_END

@interface UIView (Guidance)
/**
 获取当前view在window上的坐标
 */
- (CGRect)getWindowFrame;

@end
