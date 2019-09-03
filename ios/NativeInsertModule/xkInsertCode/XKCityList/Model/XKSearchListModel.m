/*******************************************************************************
 # File        : XKSearchListModel.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/25
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSearchListModel.h"

@implementation XKSearchListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKSearchDataItem class]
             };
}
@end

@implementation XKSearchDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end

