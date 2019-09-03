/*******************************************************************************
 # File        : XKSignatureViewController.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/18
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
typedef void(^signatureBlock)(NSString *signature);

@interface XKSignatureViewController : BaseViewController
@property (nonatomic, copy) signatureBlock block;
/**签名*/
@property(nonatomic, copy) NSString *signatureStr;

- (void)signatureBlock:(signatureBlock)block;
@end
