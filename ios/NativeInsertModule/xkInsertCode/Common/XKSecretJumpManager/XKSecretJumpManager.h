/*******************************************************************************
 # File        : XKSecretJumpManager.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/31
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
#import "XKSecretCircleInfo.h"


@interface XKSecretJumpManager : NSObject

/**全局是否能jump*/
+ (void)canJump:(BOOL)canJump;

@end


@interface UITextField (SecretJump)

/**该输入框设置能jump*/
- (void)enableSecretJump:(BOOL)canJump;

@end

@interface UISearchBar (SecretJump)

/**该输入框设置能jump*/
- (void)enableSecretJump:(BOOL)canJump;

@end

