//
//  XKPersonalInformationViewModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKPersonalDataModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef  void(^reloadDataBlock)(void);
typedef  void(^selectBlock)(UITableView *tableView,NSIndexPath *indexPath);

@interface XKPersonalInformationViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>
/**刷新*/
@property(nonatomic, copy) reloadDataBlock loadBlock;

@property(nonatomic, copy) selectBlock selectBlock;

@property(nonatomic, strong) XKPersonalDataModel *model;

- (void)registerCellForTableView:(UITableView *)tableView;

- (void)loadData;
@end

NS_ASSUME_NONNULL_END
