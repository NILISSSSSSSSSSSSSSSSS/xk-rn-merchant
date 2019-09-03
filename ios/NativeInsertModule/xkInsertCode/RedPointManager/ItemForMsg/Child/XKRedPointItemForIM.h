/*******************************************************************************
 # File        : XKTabBarMsgForIMRedItem.h
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
#import "XKRedPointItem.h"

/*
 负责TabBar《消息》中的聊天消息已读未读红点状态管理
*/

// 通知用于去改变与该状态直接相关的界面。 如需改变tabBar红点 使用父类block->redStatusChange通知上层tabBar
static NSString *XKRedPointItemForIMNoti = @"XKRedPointItemForIMNoti";

@interface XKRedPointItemForIM : XKRedPointItem<XKRedPointChildItemProtocol>

/**单聊红点状态*/
@property(nonatomic, assign) BOOL p2pRedStatus;
/**群聊红点状态*/
@property(nonatomic, assign) BOOL groupRedStatus;
/**联盟商群群聊红点状态*/
@property(nonatomic, assign) BOOL unionGroupRedStatus;
/**店铺客服红点状态*/
@property(nonatomic, assign) BOOL shopSerRedStatus;
/**晓可客服群聊红点状态*/
@property(nonatomic, assign) BOOL xkSerRedStatus;

@end
