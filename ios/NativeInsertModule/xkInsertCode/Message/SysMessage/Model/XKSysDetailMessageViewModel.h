//
//  XKSysDetailMessageViewModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef  void(^reloadDataBlock)(void);
typedef  void(^selectBlock)(NSIndexPath *indexPath);

@interface XKSysDetailMessageViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>
/**刷新*/
@property(nonatomic, copy) reloadDataBlock loadBlock;
@property(nonatomic, copy) selectBlock selectBlock;
/**控制器类型*/
@property(nonatomic, assign) XKSysMessageControllerType type;
@property(nonatomic, assign) RefreshDataStatus refreshStatus;
@property(nonatomic, strong) NSMutableArray  *dataArray;

- (void)registerCellForTableView:(UITableView *)tableView;

- (void)requestIsRefresh:(BOOL)isRefresh complete:(void (^)(NSString *error, NSArray *dataArray))complete;

@end

NS_ASSUME_NONNULL_END
