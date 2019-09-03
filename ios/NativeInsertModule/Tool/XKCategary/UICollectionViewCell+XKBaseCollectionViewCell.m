//
//  UICollectionViewCell+XKBaseCollectionViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UICollectionViewCell+XKBaseCollectionViewCell.h"

@implementation UICollectionViewCell (XKBaseCollectionViewCell)
- (void)cutCornerForType:(XKCornerCutTypeCell)type WithCellFrame:(CGRect)cellFrame {
    switch (type) {
        case XKCornerCutTypeFitstCell:
        {
            [self cutCornerWithRoundedRect:cellFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        }
            break;
        case XKCornerCutTypeLastCell:
        {
            [self cutCornerWithRoundedRect:cellFrame byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        }
            break;
        case XKCornerCutTypeOnlyCell:
        {
            [self cutCornerWithRoundedRect:cellFrame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
        }
            break;
            
        default:
            break;
    }
}

- (void)restoreFromCorner {
    self.layer.mask = nil;
}
@end
