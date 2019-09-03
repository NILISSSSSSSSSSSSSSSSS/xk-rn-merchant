/*******************************************************************************
 # File        : XKCommentVideoInfo.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/27
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommentForVideoModel.h"

@implementation XKCommentForVideoModel

@end

@implementation XKVideoInfo

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"videoId" : @"id"};
}

@end

@implementation XKVideoUplolder

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"userId" : @"id"};
}

@end


