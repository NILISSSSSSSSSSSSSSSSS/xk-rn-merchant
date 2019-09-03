//
//  XKBusinessAreaWaitPayManyCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
@class AreaOrderListModel;

@interface XKBusinessAreaWaitPayManyCell : XKBaseTableViewCell

@property (nonatomic, strong)void(^payBtnBlock)(UIButton *sender,NSIndexPath *index);
@property (nonatomic, strong)void(^selectedBlock)( NSIndexPath *index);

- (void)bindData:(AreaOrderListModel *)item;

@end
