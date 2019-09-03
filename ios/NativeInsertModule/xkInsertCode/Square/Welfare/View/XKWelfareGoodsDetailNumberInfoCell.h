//
//  XKWelfareGoodsDetailNumberInfoCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/1.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKWelfareOrderDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKWelfareGoodsDetailNumberInfoCell : XKBaseTableViewCell
- (void)bindDataModel:(XKWelfareOrderDetailViewModel *)model;
@end

NS_ASSUME_NONNULL_END
