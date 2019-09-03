/*******************************************************************************
 # File        : XKReceiptInfoController.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
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
#import "XKReceiptInfoModel.h"

@interface XKReceiptInfoController : BaseViewController

/**id*/
@property(nonatomic, copy) NSString *receiptId;

/**回调*/
@property(nonatomic, copy) void(^infoChange)(void);
@end
