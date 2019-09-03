//
//  XKDiscountTicketTableViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallBuyCarViewModel.h"
@interface XKDiscountTicketTableViewCell : UITableViewCell
@property (nonatomic, copy)void(^choseClickBlock)(UIButton *sender, NSIndexPath *index);
@property (nonatomic, copy)void(^detailClickBlock)(UIButton *sender);
@property (nonatomic, strong) NSIndexPath  *index;
- (void)bindData:(XKMallBuyCarItem *)item;
@end
