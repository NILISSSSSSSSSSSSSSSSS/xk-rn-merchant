//
//  XKPerfectPersonalViewModel.h
//  XKSquare
//
//  Created by Lin Li on 2019/4/28.
//  Copyright © 2019 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKPersonalDataModel.h"
#import "XKSecretCircleDetailModel.h"
#import "XKPushMessageTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef  void(^reloadDataBlock)(void);
typedef  void(^selectBlock)(UITableView *tableView,NSIndexPath *indexPath);
typedef  void(^upSwitchChangeBLock)(BOOL isOn);

@interface XKPerfectPersonalViewModel : NSObject <UITableViewDelegate,UITableViewDataSource>
/**nameArray*/
@property(nonatomic, strong) NSArray *cellNameArr;

/**控制器类型*/
@property(nonatomic, assign) perfectPersonalType vcType;

/**secretId*/
@property(nonatomic, copy) NSString *secretId;

/**刷新*/
@property(nonatomic, copy) reloadDataBlock                 loadBlock;

/**cell的点击*/
@property(nonatomic, copy) selectBlock                     selectBlock;

/**Switch的回调*/
@property(nonatomic, copy) upSwitchChangeBLock             upSwitchChangeBLock;

@property(nonatomic, strong) XKSecretCircleDetailModel    *model;

/**引导图的cell*/
@property(nonatomic, strong) XKPushMessageTableViewCell *currentGuidanceCell;
/**
 注册cell
 */
- (void)registerCellForTableView:(UITableView *)tableView;

/**
 请求数据
 */
- (void)getData;
@end

NS_ASSUME_NONNULL_END
