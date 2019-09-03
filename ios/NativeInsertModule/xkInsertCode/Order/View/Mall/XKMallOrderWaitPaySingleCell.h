//
//  XKMainOrderWatiPayCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKMallOrderViewModel.h"

@interface XKMallOrderWaitPaySingleCell : XKBaseTableViewCell
@property (nonatomic, strong)void(^choseBtnBlock)(UIButton *sender,NSIndexPath *index);

@property (nonatomic, strong)void(^moreBtnBlock)(UIButton *sender,NSIndexPath *index);

@property (nonatomic, strong)void(^payBtnBlock)(UIButton *sender,NSIndexPath *index);

- (void)bindData:(MallOrderListDataItem *)item;
@end
