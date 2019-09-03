/*******************************************************************************
 # File        : XKGroupQRCodeController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/30
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BaseViewController.h"

@interface XKGroupQRCodeController : BaseViewController

@property(nonatomic, copy) NSString *groupIconUrl;
@property(nonatomic, copy) NSString *groupName;
@property(nonatomic, copy) NSString *groupQrStr;

@end
