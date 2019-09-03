/*******************************************************************************
 # File        : XKSecretClockMsg.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/28
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "XKSecretTipEditController.h"

@interface XKSecretClockMsg : NSObject <YYModel>

/**<##>*/
@property(nonatomic, assign) BOOL timerSwitch;
@property(nonatomic, strong) NSMutableArray <XKSecretTipMsg *>*mappingMsgs;

@end
