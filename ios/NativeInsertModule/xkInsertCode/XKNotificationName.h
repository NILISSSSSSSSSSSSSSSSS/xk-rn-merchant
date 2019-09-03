//
//  XKNotificationName.h
//  XKSquare
//
//  Created by hupan on 2018/7/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#ifndef XKNotificationName_h
#define XKNotificationName_h



static NSString *const XKToolsBottomSheetViewDismissNotification = @"XKToolsBottomSheetViewDismissNotification";
static NSString *const XKFriendChatListViewControllerRefreshDataNotification = @"XKFriendChatListViewControllerRefreshDataNotification";                                    //刷新可友p2p消息列表界面
static NSString *const XKTeamChatListViewControllerRefreshDataNotification = @"XKTeamChatListViewControllerRefreshDataNotification";                                      //刷新可友群聊消息列表界面
static NSString *const XKCustomerServerListViewControllerRefreshDataNotification = @"XKCustomerServerListViewControllerRefreshDataNotification";                                                                          //刷新baseChatVC视图
static NSString *const XKSecretChatListViewControllerrRefreshDataNotification = @"XKSecretChatListViewControllerrRefreshDataNotification";                                    //刷新密友列表消息
static NSString *const XKTabbarMessageP2PRedPointChangeNotification = @"XKTabbarMessageP2PRedPointChangeNotification";                                      //刷新可友单消息列表界面
static NSString *const XKTabbarMessageGroupRedPointChangeNotification = @"XKTabbarMessageGroupRedPointChangeNotification";                                      //刷新可友群聊消息列表界面
static NSString *const XKTabbarMessageCusServerRedPointChangeNotification = @"XKTabbarMessageCusServerRedPointChangeNotification";                                      //刷新客服消息列表界面
static NSString *const XKTabbarMessageSystemRedPointChangeNotification = @"XKTabbarMessageSystemRedPointChangeNotification";                                      //刷新系统通知消息列表界面






static NSString *const XKKYFriendGroupChange = @"XKKYFriendGroupChange";                                      // 可友分组变化

static NSString *const XKSecretFriendGroupChange = @"XKSecretFriendGroupChange";                                      // 密友分组变化

static NSString *const XKCollectionSendAddCount    = @"XKCollectionSendAddCount";                      //增加发送收藏的数量

static NSString *const XKCollectionSendreduceCount = @"XKCollectionSendreduceCount";                      //减少发送收藏的数量

static NSString *const XKCollectionSendCleanCount  = @"XKCollectionSendCleanCount";                    //清空发送收藏的数量

// 屏幕点击通知
static NSString *const XKScreenTouchesNotificationName = @"XKWindowTouchesNotificationName";
static NSString *const XKScreenAllTouchesNotificationName = @"XKScreenAllTouchesNotificationName";



#import <XKComponentNotification.h>


#endif /* XKNotificationName_h */
