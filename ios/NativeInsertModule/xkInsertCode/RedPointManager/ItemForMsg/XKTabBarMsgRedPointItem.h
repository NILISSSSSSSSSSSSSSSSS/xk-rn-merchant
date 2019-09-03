/*******************************************************************************
 # File        : XKTabBarMsgRedPointItem.h
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

#import <Foundation/Foundation.h>
#import "XKRedPointProtocol.h"
#import "XKRedPointItemForIM.h"
#import "XKRedPointForFriendCircle.h"
#import "XKRedPointItemForSys.h"
#import "XKRedPointItemForNewFriend.h"
/*
负责TabBar《消息》的红点管理
*/

@interface XKTabBarMsgRedPointItem : NSObject <XKRedPointTabBarItemProtocol>

/**im聊天消息红点管理项*/
@property(nonatomic, strong) XKRedPointItemForIM *imItem;
/**可友圈红点管理项*/
@property(nonatomic, strong) XKRedPointForFriendCircle *friendCicleItem;
/**系统消息红点管理项*/
@property(nonatomic, strong) XKRedPointItemForSys *sysItem;
/**新朋友红点管理项*/
@property(nonatomic, strong) XKRedPointItemForNewFriend *newFriendItem;

@end
