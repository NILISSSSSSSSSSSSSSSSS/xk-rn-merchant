//
//  XKBusinessAreaWaitUseManyCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
@class AreaOrderListModel;

@interface XKBusinessAreaWaitUseManyCell : XKBaseTableViewCell

@property (nonatomic, strong)void(^selectedBlock)( NSIndexPath *index);

- (void)bindData:(AreaOrderListModel *)item;

@end
