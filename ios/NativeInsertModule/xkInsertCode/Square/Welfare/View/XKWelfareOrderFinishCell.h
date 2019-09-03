//
//  XKWelfareOrderFinishOpenCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKWelfareOrderDetailViewModel.h"
@interface XKWelfareOrderFinishCell : XKBaseTableViewCell
@property (nonatomic, strong)UIButton *againBtn;
@property (nonatomic, strong)void(^btnActionBlick)(UIButton *sender);
- (void)bindData:(WelfareOrderDataItem *)item;
/**
 进入管理模式
 */
- (void)updateLayout;

/**
 退出管理模式
 */
- (void)restoreLayout;

- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model;
@end
