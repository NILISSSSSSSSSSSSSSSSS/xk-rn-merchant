/*******************************************************************************
 # File        : XKCityListModel.m
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

#import "XKCityListModel.h"

@implementation DataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end


@implementation XKCityListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [DataItem class],
             @"provinceList" : [DataItem class],
             @"districtList" : [DataItem class],
             @"cityList" : [DataItem class]
            };
}
@end

