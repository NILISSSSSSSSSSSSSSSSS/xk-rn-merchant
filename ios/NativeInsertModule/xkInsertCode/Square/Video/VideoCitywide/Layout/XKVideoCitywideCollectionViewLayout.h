//
//  XKVideoCitywideCollectionViewLayout.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XKVideoCitywideCollectionViewLayoutType) {
    XKVideoCitywideCollectionViewLayoutTypeVertical = 0,      /**< 垂直瀑布流 */
    XKVideoCitywideCollectionViewLayoutTypeHorizontal,        /**< 水平瀑布流 */
};

@interface XKVideoCitywideCollectionViewLayout : UICollectionViewLayout

/**
 *  瀑布流类型 : 分为水平瀑布流 和 垂直瀑布流
 */
@property (nonatomic, assign) XKVideoCitywideCollectionViewLayoutType type;

/**
 *  区头高度，默认为0
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 *  行高(水平瀑布流时)，默认为100
 */
@property (nonatomic, assign) CGFloat rowHeight;
/**
 *  单元格宽度(垂直瀑布流时自动计算)
 */
@property (nonatomic, assign, readonly) CGFloat itemWidth;
/**
 *  列数 : 默认为3
 */
@property (nonatomic, assign) NSInteger numberOfColumns;

/**
 *  内边距 : 每一列之间的间距 (top, left, bottom, right)默认为{10, 10, 10, 10};
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 *  每一行之间的间距 : 默认为10
 */
@property (nonatomic, assign) CGFloat rowGap;

/**
 *  每一列之间的间距 : 默认为10
 */
@property (nonatomic, assign) CGFloat columnGap;

/**
 *  高度数组 : 存储所有item的高度
 */
@property (nonatomic, strong) NSArray *itemHeights;

/**
 *  宽度数组 : 存储所有item的宽度
 */
@property (nonatomic, strong) NSArray *itemWidths;

@end
