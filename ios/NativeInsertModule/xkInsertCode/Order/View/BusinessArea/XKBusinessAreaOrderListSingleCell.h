//
//  XKBusinessAreaOrderListSingleCell.h
//  XKSquare
//
//  Created by hupan on 2018/11/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
@class AreaOrderListModel;

typedef enum : NSUInteger {
    SingleCellType_PICK = 0, //待接单
    SingleCellType_PAY, //待支付
    SingleCellType_USE, //待消费
    SingleCellType_PREPARE,//备货中
    SingleCellType_USEING,//进行中
    SingleCellType_EVALUATE,//待评价
    SingleCellType_FINISH,//已完成
    SingleCellType_REFUND,//退款中
    SingleCellType_CLOSED//已关闭
} SingleCellType;


@interface XKBusinessAreaOrderListSingleCell : XKBaseTableViewCell
@property (nonatomic, strong) NSIndexPath  *index;

@property (nonatomic, strong)void(^selectedBlock)( NSIndexPath *index);

@property (nonatomic, strong)void(^payBlock)( NSIndexPath *index);

@property (nonatomic, strong)void(^evluateBlock)( NSIndexPath *index);

@property (nonatomic, assign) SingleCellType cellType;

- (void)bindData:(AreaOrderListModel *)item;

@end
