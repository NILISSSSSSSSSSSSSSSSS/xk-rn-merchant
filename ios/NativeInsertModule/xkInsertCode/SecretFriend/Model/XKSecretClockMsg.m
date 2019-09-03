/*******************************************************************************
 # File        : XKSecretClockMsg.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/28
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretClockMsg.h"

@implementation XKSecretClockMsg

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"mappingMsgs" : [XKSecretTipMsg class]};
}

@end
