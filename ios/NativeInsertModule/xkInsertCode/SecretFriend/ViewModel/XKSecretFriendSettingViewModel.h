/*******************************************************************************
 # File        : XKSecretFriendSettingViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "XKFriendDetailInfo.h"
@interface XKSecretFriendSettingViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

/**刷新block*/
@property(nonatomic, copy) void(^refreshData)(void);
/**刷新block*/
@property(nonatomic, copy) void(^refreshTableView)(void);
/**用户信息*/
@property(nonatomic, strong) XKFriendDetailInfo *detailInfo;

/**用户id*/
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *secretId;

- (void)requestDetailComplete:(void(^)(NSString *error,id data))complete;
- (void)registerCellForTableView:(UITableView *)tableView;

@end
