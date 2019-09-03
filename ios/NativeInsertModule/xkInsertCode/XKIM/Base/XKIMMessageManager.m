//
//  XKIMMessageManager.m
//  XKSquare
//
//  Created by william on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKIMMessageManager.h"
#import <NIMSDK/NIMSDK.h>
#import "XKIMGlobalMethod.h"
@interface XKIMMessageManager()<NIMConversationManagerDelegate>

@end
@implementation XKIMMessageManager

+ (instancetype)shareManager {
    static XKIMMessageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XKIMMessageManager alloc] init];
    });
    return instance;
}

-(void)configDelegate{
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}

-(void)dellocManager{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    [self handleNotificationWithRecentSession:recentSession];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    [self handleNotificationWithRecentSession:recentSession];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    [self handleNotificationWithRecentSession:recentSession];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    [self handleNotificationWithRecentSession:nil];
}

- (void)allMessagesDeleted{
    [self handleNotificationWithRecentSession:nil];
}

- (void)allMessagesRead{
    [self handleNotificationWithRecentSession:nil];
}

-(void)handleNotificationWithRecentSession:(NIMRecentSession *)recentSession{
    if (recentSession.session.sessionType == NIMSessionTypeP2P) {
        [[NSNotificationCenter defaultCenter]postNotificationName:XKFriendChatListViewControllerRefreshDataNotification object:recentSession];
        [[NSNotificationCenter defaultCenter]postNotificationName:XKSecretChatListViewControllerrRefreshDataNotification object:recentSession];
    }
    else{
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
        if ([XKIMGlobalMethod isCutomerServerSession:team]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:XKCustomerServerListViewControllerRefreshDataNotification object:recentSession];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:XKTeamChatListViewControllerRefreshDataNotification object:recentSession];
        }
    }
}
@end
