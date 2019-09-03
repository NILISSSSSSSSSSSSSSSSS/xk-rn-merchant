/*******************************************************************************
 # File        : XKFriendTalkRecordModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/5
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkRecordModel.h"
#import "XKContactCacheManager.h"

@implementation XKFriendTalkRecordModel

- (void)setReleaseUserId:(NSString *)releaseUserId {
    _releaseUserId = releaseUserId;
    XKContactModel *user = [XKContactCacheManager queryContactWithUserId:_releaseUserId];
    _releaseUser = user;
}

@end
