//
//  UICollectionViewCell+XKBaseCollectionViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, XKCornerCutTypeCell) {
    XKCornerCutTypeFitstCell,//作为第一个cell
    XKCornerCutTypeLastCell,//作为最后一个cell
    XKCornerCutTypeOnlyCell //只有一个cell
};
@interface UICollectionViewCell (XKBaseCollectionViewCell)
/**
 裁圆角
 */
- (void)cutCornerForType:(XKCornerCutTypeCell)type WithCellFrame:(CGRect)cellFrame;


/**
 从圆角恢复/避免复用
 */
- (void)restoreFromCorner;
@end
