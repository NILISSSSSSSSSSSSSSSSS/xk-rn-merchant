//
//  XKWelfareOrderWaitOpenCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKWelfareBuyCarSumView.h"
#import "XKWelfareBuyCarViewModel.h"
@interface XKWelfareOrderWaitOpenCell : XKBaseTableViewCell
@property (nonatomic, strong)UIButton *choseBtn;
@property (nonatomic, strong)UIButton *loseBtn;
@property (nonatomic, strong)XKWelfareBuyCarSumView *sumView;

@property (nonatomic, strong)XKWelfareBuyCarItem  *buyCarModel;

@property (nonatomic, copy)void(^calculateBlock)(NSInteger row,NSInteger currentCount);
@property (nonatomic, copy)void(^choseBlock)(NSInteger row,UIButton *sender);
//订单详情 列表进入
- (void)bindData:(WelfareOrderDataItem *)item;
//购物车列表
- (void)handleDataModel:(XKWelfareBuyCarItem *)model hasLose:(BOOL)hasLose manangeModel:(BOOL)manangeModel;
//详情进入
- (void)bindItem:(XKWelfareBuyCarItem *)item;
@end
