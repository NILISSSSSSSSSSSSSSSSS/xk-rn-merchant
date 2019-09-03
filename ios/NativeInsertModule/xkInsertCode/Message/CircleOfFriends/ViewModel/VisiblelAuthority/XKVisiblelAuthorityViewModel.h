/*******************************************************************************
 # File        : XKVisiblelAuthorityViewModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
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
#import "XKVisiblelAuthorityInfo.h"

@interface XKVisiblelAuthorityViewModel : NSObject <UITableViewDataSource, UITableViewDelegate>

/**<##>*/
@property(nonatomic, copy) void(^reloadData)(void);
/**数据源*/
@property(nonatomic, strong) NSMutableArray <XKVisiblelAuthorityInfo *>*dataArray;

/**第二次传入数据为完整数据时不用请求了 直接用数据*/
- (void)setInitData:(XKVisiblelAuthorityResult *)result;

- (void)registerCellForTableView:(UITableView *)tableView;

/**请求分组信息*/
- (void)requestGroupsComplete:(void(^)(NSString *err,id data))complete;

@end
