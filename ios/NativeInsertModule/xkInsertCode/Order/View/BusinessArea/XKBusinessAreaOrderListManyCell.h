//
//  XKBusinessAreaOrderListManyCell.h
//  XKSquare
//
//  Created by hupan on 2018/11/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
@class AreaOrderListModel;

typedef enum : NSUInteger {
    ManyCellType_PICK = 0, //待接单
    ManyCellType_PAY, //待支付
    ManyCellType_USE, //待消费
    ManyCellType_PREPARE,//备货中
    ManyCellType_USEING,//进行中
    ManyCellType_EVALUATE,//待评价
    ManyCellType_FINISH,//已完成
    ManyCellType_REFUND,//退款中
    ManyCellType_CLOSED//已关闭
} ManyCellType;

@interface XKBusinessAreaOrderListManyCell : XKBaseTableViewCell

@property (nonatomic, strong) NSIndexPath  *index;

@property (nonatomic, strong)void(^selectedBlock)( NSIndexPath *index);

@property (nonatomic, strong)void(^payBlock)( NSIndexPath *index);

@property (nonatomic, strong)void(^evluateBlock)( NSIndexPath *index);
@property (nonatomic, assign) ManyCellType cellType;

- (void)bindData:(AreaOrderListModel *)item;


@end
