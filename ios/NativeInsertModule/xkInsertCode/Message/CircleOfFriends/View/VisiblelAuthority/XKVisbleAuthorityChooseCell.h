/*******************************************************************************
 # File        : XKVisbleAuthorityChooseCell.h
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

#import <UIKit/UIKit.h>
#import "XKVisiblelAuthorityInfo.h"

@interface XKVisbleAuthorityChooseCell : UITableViewCell

/**<##>*/
@property(nonatomic, strong) NSIndexPath *indexPath;
/**<##>*/
@property(nonatomic, copy) void(^infoBtnBlock)(NSIndexPath *indexPath);
/***/
@property(nonatomic, copy) XKVisiblelAuthorityItem *item;

@end
