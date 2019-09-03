//
//  XKConsumeCouponListTableViewCell.h
//  XKSquare
//
//  Created by william on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKConsumeCouponCellModel.h"
@interface XKConsumeCouponListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView            *backWhiteView;
@property (nonatomic, strong) XKConsumeCouponCellModel  *dataModel;
- (void)hiddenLineView:(BOOL)hidden;

@end
