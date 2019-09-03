//
//  XKUnionPersonalInfoViewModel.h
//  XKSquare
//
//  Created by Lin Li on 2019/5/6.
//  Copyright © 2019 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnionPersonalDataModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef  void(^reloadDataBlock)(BOOL);
typedef  void(^selectBlock)(UITableView *tableView,NSIndexPath *indexPath);

@interface XKUnionPersonalInfoViewModel : NSObject <UITableViewDelegate,UITableViewDataSource>

/**刷新*/
@property(nonatomic, copy) reloadDataBlock loadBlock;

@property(nonatomic, copy) selectBlock selectBlock;

@property(nonatomic, strong) XKUnionPersonalDataModel *model;

- (void)registerCellForTableView:(UITableView *)tableView;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
