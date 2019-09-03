/*******************************************************************************
 # File        : XKOrderEvalutionCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/5
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "XKMallOrderViewModel.h"
@class XKOrderEvaModel;

@interface XKOrderEvalutionCell : UITableViewCell

/**刷新*/
@property(nonatomic, copy) void(^refreshTableView)(void);
/**<##>*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**<##>*/
@property(nonatomic, strong) XKOrderEvaModel *model;
@end
