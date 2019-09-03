/*******************************************************************************
 # File        : XKCollectVideoModel.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/26
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCollectVideoModel.h"
@implementation XKCollectVideoModelTarget
@end


@implementation XKCollectVideoModelDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end


@implementation XKCollectVideoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKCollectVideoModelDataItem class]};
}
@end
