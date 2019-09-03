//
//  UITableViewCell+XKBaseTableViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "UITableViewCell+XKBaseTableViewCell.h"

@implementation UITableViewCell (XKBaseTableViewCell)
- (void)cutCornerForType:(XKCornerCutType)type WithCellFrame:(CGRect)cellFrame {
    switch (type) {
        case XKCornerCutTypeFitst:
        {
          [self cutCornerWithRoundedRect:cellFrame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        }
            break;
        case XKCornerCutTypeLast:
        {
          [self cutCornerWithRoundedRect:cellFrame byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        }
            break;
        case XKCornerCutTypeOnly:
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
