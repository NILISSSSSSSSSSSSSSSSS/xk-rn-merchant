//
//  XKRedPointManager+config.m
//  XKSquare
//
//  Created by Jamesholy on 2018/11/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedPointManager+config.h"
#import "XKTabBarMsgRedPointItem.h"
#import <NIMKit.h>
#import "XKIMGlobalMethod.h"

static NSString *const XKRedPointTabKeyForMsg = @"XKRedPointTabKeyForMsg"; // 消息界面红点

@interface XKRedPointManager()<NIMConversationManagerDelegate>
@end

@implementation XKRedPointManager (config)

+ (void)configAllItem {
    // 配置消息管理tabBar
    id<XKRedPointTabBarItemProtocol> msgItem = [[XKTabBarMsgRedPointItem alloc] init];
    [XKRedPointManager addRedPointTabbarItem:msgItem forKey:XKRedPointTabKeyForMsg];
    [[XKRedPointManager shareManager] addIMSessionDelegate];
}

- (void)addIMSessionDelegate {
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}


+ (XKTabBarMsgRedPointItem *)getMsgTabBarRedPointItem {
    return (XKTabBarMsgRedPointItem *)[XKRedPointManager getRedPointTabBarItemForKey:XKRedPointTabKeyForMsg];
}

#pragma mark -- NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    [self recentSessionRefreshRedPoint:recentSession unreadCount:totalUnreadCount];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    [self recentSessionRefreshRedPoint:recentSession unreadCount:totalUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount
{
    [self recentSessionRefreshRedPoint:recentSession unreadCount:totalUnreadCount];
}

-(void)recentSessionRefreshRedPoint:(NIMRecentSession *)recentSession unreadCount:(NSInteger )totalUnreadCount{
    if (recentSession.session.sessionType == NIMSessionTypeP2P) {
        // 单聊分了p2p消息 和系统消息
        
        if ([recentSession.session.sessionId containsString:@"system_"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:XKTabbarMessageSystemRedPointChangeNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter]postNotificationName:XKTabbarMessageP2PRedPointChangeNotification object:nil];
        }
    } else if (recentSession.session.sessionType == NIMSessionTypeTeam) {
         [[NSNotificationCenter defaultCenter]postNotificationName:XKTabbarMessageGroupRedPointChangeNotification object:nil];
    }
}

@end
