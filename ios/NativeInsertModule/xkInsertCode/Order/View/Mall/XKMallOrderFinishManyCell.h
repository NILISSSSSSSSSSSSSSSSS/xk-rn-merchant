//
//  XKMallOrderWaitFinishManyCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKMallOrderViewModel.h"
@interface XKMallOrderFinishManyCell : XKBaseTableViewCell
@property (nonatomic, strong)void(^moreBtnBlock)(UIButton *sender, NSIndexPath *index);

@property (nonatomic, strong)void(^selectedBlock)( NSIndexPath *index);

- (void)bindData:(MallOrderListDataItem *)item;

@end
