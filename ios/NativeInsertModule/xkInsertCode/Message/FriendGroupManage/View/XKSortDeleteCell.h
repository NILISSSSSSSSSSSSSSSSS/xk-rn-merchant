/*******************************************************************************
 # File        : XKSortDeleteCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/9
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKBaseTableViewCell.h"

@interface XKSortDeleteCell : XKBaseTableViewCell
/**可删除状态*/
@property(nonatomic, assign) BOOL canDelete;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong, readonly) UILabel *titleLabel;
/**删除点击*/
@property(nonatomic, copy) void(^deleteClick)(NSIndexPath *indexPath);

@end
