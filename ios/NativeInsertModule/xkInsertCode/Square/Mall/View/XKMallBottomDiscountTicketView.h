//
//  XKMallBottomDiscountTicketView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallBuyCarViewModel.h"
@interface XKMallBottomDiscountTicketView : UIView
- (instancetype)initWithTicketArr:(NSArray *)ticketArr titleStr:(NSString *)title;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, copy)void(^choseBlock)(XKMallBuyCarItem *item);
@end
