//
//  XKMallOrderRefundGoodsCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKFriendCirclePublishViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKMallOrderRefundGoodsCell : XKBaseTableViewCell
/**刷新*/
@property(nonatomic, copy) void(^refreshTableView)(void);
/**<##>*/
@property(nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) XKFriendCirclePublishViewModel  *picModel;
//1 网图 显示的时候用  
@property (nonatomic, assign) NSInteger  entryType;
@end

NS_ASSUME_NONNULL_END
