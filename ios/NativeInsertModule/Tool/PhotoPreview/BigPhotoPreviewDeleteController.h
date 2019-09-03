/*******************************************************************************
 # File        : BigPhotoPreviewDeleteController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BigPhotoPreviewBaseController.h"

@interface BigPhotoPreviewDeleteController : BigPhotoPreviewBaseController

/**删除事件*/
@property(nonatomic, copy) void(^deleteComplete)(NSInteger index);
@end
