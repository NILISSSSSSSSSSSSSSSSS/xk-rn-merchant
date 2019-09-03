//
//  XKMallApplyAfterSaleListCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKMallOrderViewModel.h"
#import "XKMallOrderDetailViewModel.h"
@interface XKMallApplyAfterSaleListCell : XKBaseTableViewCell
@property (nonatomic, strong)void(^choseBtnBlock)(UIButton *sender, NSIndexPath *index);

@property (nonatomic, strong)void(^moreBtnBlock)(UIButton *sender, NSIndexPath *index);

@property (nonatomic, strong)void(^payBtnBlock)(UIButton *sender, NSIndexPath *index);
/**
 详情售后
 
 @param obj 商品
 */
- (void)bindDetailItem:(XKMallOrderDetailGoodsItem *)obj;

/**
 列表售后

 @param obj 商品
 */
- (void)bindListItem:(MallOrderListObj*)obj;
@end
