/*******************************************************************************
 # File        : XKCollectWelfareModel.m
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

#import "XKCollectWelfareModel.h"

@implementation Target

@end


@implementation XKCollectWelfareDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end


@implementation XKCollectWelfareModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKCollectWelfareDataItem class]};
}
@end
