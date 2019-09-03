/*******************************************************************************
 # File        : XKCommentBaseInfo.m
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

#import "XKCommentBaseInfo.h"

@implementation XKCommentBaseInfo {
    NSString *_displayTime;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"commentId"  : @"id"};
}

- (void)setCreatedAt:(NSString *)createdAt {
    _createdAt = createdAt;
    if (_createdAt.length != 0) {
        _displayTime = [XKTimeSeparateHelper backYMDHMSStringByStrigulaSegmentWithTimestampString:_createdAt];
    }
}

- (NSString *)getDisplayTime {
    return _displayTime;
}

- (NSArray *)imgsArray {
    if (_imgsArray == nil) {
        NSMutableArray *arr = @[].mutableCopy;
        if (self.video && self.video.url.length != 0) {
            [arr addObject:self.video];
        }
        for (NSString *url in self.pictures) {
            XKMediaInfo *info = [XKMediaInfo new];
            info.isPic = YES;
            info.mainPic = url;
            [arr addObject:info];
        }
        _imgsArray = arr.copy;
    }
    return _imgsArray;
}

@end

@implementation XKMediaInfo

@end
