//
//  XKMallOrderDetailTicketTableViewCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/21.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKMallOrderDetailViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKMallOrderDetailInfoTableViewCell : XKBaseTableViewCell
//type 0 是发票  1 是金额
- (void)handleWaitPayOrderDetailModel:(XKMallOrderDetailViewModel *)model WithType:(NSInteger)type;

/**
 下载发票的回调
 */
@property (nonatomic, copy)void(^downLoadBlock)(UIButton *sender);
@end

NS_ASSUME_NONNULL_END
