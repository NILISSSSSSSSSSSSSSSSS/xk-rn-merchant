/*******************************************************************************
 # File        : XKCheckFolderSectionHeaderView.h
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

@interface XKCheckFolderSectionHeaderView : UITableViewHeaderFooterView

/**<##>*/
@property(nonatomic, assign) NSInteger section;

@property(nonatomic, strong) XKVisiblelAuthorityInfo *info;

/**<##>*/
@property(nonatomic, copy) void(^clickBlock)(NSInteger section);

@end
