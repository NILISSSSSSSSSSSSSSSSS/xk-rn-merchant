/*******************************************************************************
 # File        : IAPResultVerificationController.h
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2019/1/16
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
#import "AppleProductSuccessCacheModel.h"

@interface IAPResultVerificationController : BaseViewController

/**支付信息*/
@property(nonatomic, strong) AppleProductSuccessCacheModel *payInfo;
/**结果
 status 0 成功  1 验证失败  2 还没验证就返回了
 */
@property(nonatomic, copy) void(^result)(NSInteger status,AppleProductSuccessCacheModel *info);

@end
