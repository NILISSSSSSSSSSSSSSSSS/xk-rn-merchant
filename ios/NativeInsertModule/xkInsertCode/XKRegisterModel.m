/*******************************************************************************
 # File        : XKRegisterModel.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/17
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRegisterModel.h"


@implementation UserImAccount
@end

@implementation XKRegisterModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             @"nickname":@[@"nickName"]};
}

@end


