/*******************************************************************************
 # File        : XKGroupDetailController.h
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

#import "XKContactBaseController.h"

@interface XKGroupDetailController : XKContactBaseController
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *groupName;
@end
