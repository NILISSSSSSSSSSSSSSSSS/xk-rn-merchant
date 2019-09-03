/*******************************************************************************
 # File        : XKGoodsCommentModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGoodsCommentModel.h"
#import "XKGoodsCommentCell.h"

@implementation XKGoodsCommentModel {
    NSString *_displayTime;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"commentId"  : @"id"};
}

- (void)setCreatedAt:(NSString *)createdAt {
    _createdAt = createdAt;
    if (_createdAt.length != 0) {
        _displayTime = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:_createdAt];
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
