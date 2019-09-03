/*******************************************************************************
 # File        : XKReplyBaseInfo.m
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

#import "XKReplyBaseInfo.h"

@implementation XKReplyBaseInfo {
    NSString *_displayTime;
}

- (void)setCreatedAt:(NSString *)createdAt{
    _createdAt = createdAt;
    if (_createdAt.length != 0) {
        _displayTime = [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:_createdAt];
    }
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"replyId"  : @"id"};
}

- (NSString *)getDisplayTime {
    return _displayTime;
}

@end
