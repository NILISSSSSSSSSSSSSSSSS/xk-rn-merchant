/*******************************************************************************
 # File        : XKCollectShopModel.m
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

#import "XKCollectShopModel.h"

@interface XKCollectShopModelTarget()
@end
@implementation XKCollectShopModelTarget

@end


@implementation XKCollectShopModelDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end


@implementation XKCollectShopModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKCollectShopModelDataItem class]};
}

@end


