/*******************************************************************************
 # File        : XKNewFriendApplyCell.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
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
#import "XKBaseHeadTitleDesView.h"
#import "XKNewFriendApplyInfo.h"

@interface XKNewFriendApplyCell : XKBaseTableViewCell

/**<##>*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**<##>*/
@property(nonatomic, strong) XKNewFriendApplyInfo *model;
/**操作按钮点击事件*/
@property(nonatomic, copy) void(^operationClick)(NSIndexPath *indexPath);
/**头像按钮点击事件*/
@property(nonatomic, copy) void(^headClick)(NSIndexPath *indexPath);

@end
