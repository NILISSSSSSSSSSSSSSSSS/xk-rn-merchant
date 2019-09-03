//
//  XKAutoScrollView.h
//  XKSquare
//
//  Created by hupan on 2018/8/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKAutoScrollView;
@class XKAutoScrollImageItem;

typedef void(^XKBannerViewTapBlock)(NSInteger type, NSString *jumpStr);

@protocol XKAutoScrollViewDelegate <NSObject>
@optional
- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didScrollIndex:(NSInteger)index;
- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index;

@end


@interface XKAutoScrollView : UIView


@property (nonatomic, weak) id<XKAutoScrollViewDelegate> delegate;
@property (nonatomic, copy  ) XKBannerViewTapBlock       tapBlock;
@property (nonatomic, assign) CGFloat                    customCornerRadius;


/**
 创建scrollView

 @param frame frame
 @param delegate delegate
 @param isShowPageControl isShowPageControl
 @param isAuto isAuto
 @return return scrollView
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<XKAutoScrollViewDelegate>)delegate
            isShowPageControl:(BOOL)isShowPageControl
                       isAuto:(BOOL)isAuto;


/**
 设置滚动的数据

 @param items items description
 */
- (void)setScrollViewItems:(NSArray *)items;

/**
 创建scrollView
 
 @param frame frame
 @param delegate delegate
 @param items items
 @param isShowPageControl isShowPageControl
 @param isAuto isAuto
 @return return scrollView
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<XKAutoScrollViewDelegate>)delegate
                   imageItems:(NSArray *)items
            isShowPageControl:(BOOL)isShowPageControl
                       isAuto:(BOOL)isAuto;


/**
 创建scrollView
 
 @param frame frame
 @param delegate delegate
 @param items items
 @param isShowPageControl isShowPageControl
 @return return scrollView
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<XKAutoScrollViewDelegate>)delegate
                   imageItems:(NSArray *)items
            isShowPageControl:(BOOL)isShowPageControl;




@end
