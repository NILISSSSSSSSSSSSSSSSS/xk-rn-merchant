//
//  XKWelfareLoseEfficacyBuyCarCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKWelfareBuyCarViewModel.h"
@interface XKWelfareLoseEfficacyBuyCarCell : UITableViewCell
@property (nonatomic, copy)void(^choseBlock)(NSInteger row,UIButton *sender);
- (void)handleDataModel:(XKWelfareBuyCarItem *)model managerModel:(BOOL)manager;
- (void)updateManagerModel:(BOOL)model;
@end
