//
//  XKSysMessageViewModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "XKIMGlobalMethod.h"

NS_ASSUME_NONNULL_BEGIN
typedef  void(^reloadDataBlock)(void);
typedef  void(^selectBlock)(NSIndexPath *indexPath);

@interface XKSysMessageViewModel : NSObject <UITableViewDelegate,UITableViewDataSource,NIMConversationManagerDelegate>
/**dataArray数据*/
@property(nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, assign) BOOL isEdit;
/**刷新*/
@property(nonatomic, copy) reloadDataBlock loadBlock;
@property(nonatomic, copy) selectBlock selectBlock;

- (void)registerCellForTableView:(UITableView *)tableView;

- (void)loadNetWork;

- (void)viewModeldealloc;
@end

NS_ASSUME_NONNULL_END
