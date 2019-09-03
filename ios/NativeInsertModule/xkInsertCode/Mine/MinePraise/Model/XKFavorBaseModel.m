/*******************************************************************************
 # File        : XKFavorBaseModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
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

#import "XKFavorBaseModel.h"

@implementation XKFavorBaseModel {
    NSString *_time;
}


- (NSString *)getDisplayTime {
    if (_time == nil) {
        _time = [XKTimeSeparateHelper backStringWithFormatString:@"MM-dd HH:mm" timestampStringSecond:self.liker.updatedAt];
    }
    return _time;
}
@end
