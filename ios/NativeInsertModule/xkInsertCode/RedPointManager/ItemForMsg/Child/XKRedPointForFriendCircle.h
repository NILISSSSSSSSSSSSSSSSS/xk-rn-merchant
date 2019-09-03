/*******************************************************************************
 # File        : XKRedPointForFriendCircle.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/27
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRedPointItem.h"

static NSString *XKRedPointForFriendCircleNoti = @"XKRedPointForFriendCircleNoti";

@class XKUnReadTip;
@interface XKRedPointForFriendCircle : XKRedPointItem <XKRedPointChildItemProtocol>

/**新动态状态*/
@property(nonatomic, assign) BOOL newsTalkStatus;
/**未读相关提醒状态*/
@property(nonatomic, assign) BOOL unReadTipStatus;
@property(nonatomic, strong) XKUnReadTip *unReadTip;

- (void)cleanNewsTalkStatus;
- (void)cleanUnReadTipStatus;

@end

@interface XKUnReadTip :NSObject

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy) NSString *avatar;

@end
