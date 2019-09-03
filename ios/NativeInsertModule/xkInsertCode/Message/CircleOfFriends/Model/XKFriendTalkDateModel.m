/*******************************************************************************
 # File        : XKFriendTalkDateModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/27
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkDateModel.h"
#import "XKFriendsTalkDateCell.h"

@implementation XKFriendTalkDateModel

- (Class<XKFriendTalkHeightCalculatePrococol>)getCalculateClass {
    return [XKFriendsTalkDateCell class];
}

@end
