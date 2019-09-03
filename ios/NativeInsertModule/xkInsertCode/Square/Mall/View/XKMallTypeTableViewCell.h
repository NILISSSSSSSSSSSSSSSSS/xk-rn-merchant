//
//  XKMallTypeTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKMallTypeTableViewCell : UITableViewCell

- (void)setTitle:(NSString *)title titleColor:(UIColor *)color;
- (void)setSelectedBackGroundViewColor:(UIColor *)color;
- (void)showSelectedView:(BOOL)selected;

@end
