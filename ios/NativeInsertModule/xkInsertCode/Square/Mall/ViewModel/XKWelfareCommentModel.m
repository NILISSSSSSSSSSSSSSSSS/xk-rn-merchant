/*******************************************************************************
 # File        : XKWelfareCommentModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/22
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKWelfareCommentModel.h"

@implementation XKWelfareCommentModel
{
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
    if ([super imgsArray] == nil) {
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
        self.imgsArray = arr;
    }
    return [super imgsArray];
}



@end
