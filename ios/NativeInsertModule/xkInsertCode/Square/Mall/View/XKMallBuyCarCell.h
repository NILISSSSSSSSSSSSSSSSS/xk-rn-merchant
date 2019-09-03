//
//  XKMallBuyCarCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallBuyCarViewModel.h"
@interface XKMallBuyCarCell : UITableViewCell
@property (nonatomic, copy)void(^ticketClickBlock)(NSInteger row, UIButton *sender);
@property (nonatomic, copy)void(^choseClickBlock)(NSInteger row, UIButton *sender);
@property (nonatomic, copy)void(^calculateBlock)(NSInteger row,NSInteger currentCount);
- (void)handleDataModel:(XKMallBuyCarItem *)model managerModel:(BOOL)manager;
@end
