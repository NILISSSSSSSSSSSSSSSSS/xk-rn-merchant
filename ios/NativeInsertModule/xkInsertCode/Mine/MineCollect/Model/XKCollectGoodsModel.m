/*******************************************************************************
 # File        : XKCollectGoodsModel.m
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

#import "XKCollectGoodsModel.h"

@implementation XKCollectGoodsTarget
@end


@implementation XKCollectGoodsDataItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id",
             };
}
@end


@implementation XKCollectGoodsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [XKCollectGoodsDataItem class]};
}
@end

