//
//  UITableViewCell+XKBaseTableViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, XKCornerCutType) {
    XKCornerCutTypeFitst,//作为第一个cell
    XKCornerCutTypeLast,//作为最后一个cell
    XKCornerCutTypeOnly //只有一个cell
};
@interface UITableViewCell (XKBaseTableViewCell)
/**
 裁圆角
 */
- (void)cutCornerForType:(XKCornerCutType)type WithCellFrame:(CGRect)cellFrame;


/**
 从圆角恢复/避免复用
 */
- (void)restoreFromCorner;

/**
 停止刷新
 */
- (void)stopRefreshing;


@end
