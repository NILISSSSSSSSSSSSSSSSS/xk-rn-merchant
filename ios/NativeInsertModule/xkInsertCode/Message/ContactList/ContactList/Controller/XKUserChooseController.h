/*******************************************************************************
 # File        : XKUserChooseController.h
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
#import "XKContactModel.h"

@interface XKUserChooseController : BaseViewController

/**传入的选择数据*/
@property(nonatomic, copy) NSArray <XKContactModel *>*dataArray;

/**按钮的确认回调*/
@property(nonatomic, copy) void(^sureClickBlock)(NSArray <XKContactModel *>*contacts,XKUserChooseController *listVC);

@end
