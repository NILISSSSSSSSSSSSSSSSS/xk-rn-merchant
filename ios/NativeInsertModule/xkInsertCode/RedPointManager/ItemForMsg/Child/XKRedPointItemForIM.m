/*******************************************************************************
 # File        : XKTabBarMsgForIMRedItem.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/27
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKRedPointItemForIM.h"
#import "CYLTabBarController.h"
#import <NIMSDK/NIMSDK.h>
#import "XKIMGlobalMethod.h"
#import "XKSecretFrientManager.h"
#import "XKSecretTipMsgManager.h"
@implementation XKRedPointItemForIM

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetItemRedPointStatus) name:XKTabbarMessageP2PRedPointChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetItemRedPointStatus) name:XKTabbarMessageGroupRedPointChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetItemRedPointStatus {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSArray *p2pMessages = [XKIMGlobalMethod getLatestP2PChatListArray];
      NSArray *groupMessages = [[NSArray arrayWithArray:[XKIMGlobalMethod getLatestGroupChatListArray]] arrayByAddingObjectsFromArray:[XKIMGlobalMethod getLatestServerChatListArray]];
        __block NSInteger p2pUnreadCount = 0;
        NSInteger teamUnreadCount = 0;
        NSInteger unionTeamUnreadCount = 0;
        NSInteger xkSerUnreadCount = 0;
        NSInteger shopSerUnreadCount = 0;
        for (NIMRecentSession *recentSession in p2pMessages) {
            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:recentSession.session.sessionId];
           XKShowMessagesScene messageScene =  [XKSecretFrientManager showMessagesSceneWithUserID:recentSession.session.sessionId];
            if (recentSession.unreadCount > 0 && user.notifyForNewMsg) {
                if (messageScene == XKShowMessagesSceneNomal || messageScene == XKShowMessagesSceneAll) {
                    p2pUnreadCount = recentSession.unreadCount + p2pUnreadCount;
                }
                
                else if ([XKSecretFrientManager showMessagesSceneWithUserID:recentSession.session.sessionId] == XKShowMessagesSceneRespective) {
                    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
                    option.limit = recentSession.unreadCount;
                    option.order = NIMMessageSearchOrderDesc;
                    option.messageTypes = @[@(NIMMessageTypeCustom)];
                    dispatch_semaphore_t signal = dispatch_semaphore_create(0); // 变同步 才能锁住哦
                    [[NIMSDK sharedSDK].conversationManager searchMessages:recentSession.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
                        for (NIMMessage *message in messages) {
                            if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
                                p2pUnreadCount ++;
                                break;
                            }
                        }
                        dispatch_semaphore_signal(signal);
                    }];
                    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);

                } else if (messageScene == XKShowMessagesSceneSecret) { // 特殊考虑密友投射的情况。
                  if ([[XKSecretTipMsgManager shareManager] isOutsiderMan:recentSession.session.sessionId]) {
                    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
                    option.limit = recentSession.unreadCount;
                    option.order = NIMMessageSearchOrderDesc;
                    option.messageTypes = @[@(NIMMessageTypeCustom)];
                    dispatch_semaphore_t signal = dispatch_semaphore_create(0); // 变同步 才能锁住哦
                    [[NIMSDK sharedSDK].conversationManager searchMessages:recentSession.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
                      for (NIMMessage *message in messages) {
                        if ([XKIMGlobalMethod isSecretTipMsgType:message]) {
                          p2pUnreadCount ++;
                          break;
                        }
                      }
                      dispatch_semaphore_signal(signal);
                    }];
                    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
                  }
                }
                else{
                  // 小视频陌生人消息才加此逻辑
                  //                    NSString* dictJsonString = [NSString stringWithFormat:@"%@",recentSession.lastMessage.messageObject];
                  //                    NSDictionary *dict = [dictJsonString xk_jsonToDic];
                  //                    NSString *group = dict[@"group"];
                  //                    if (group  && [group integerValue] == 3) {
                  //                        p2pUnreadCount ++;
                  //                        break;
                  //                    }
                  
                }
            }
        }
        
        for (NIMRecentSession *recentSession in groupMessages) {
            if (recentSession.session.sessionType == NIMSessionTypeTeam){
                NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recentSession.session.sessionId];
              if ([team.intro isEqualToString:@"2"]) { // 联盟商群
                if (recentSession.unreadCount > 0 && team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
                  unionTeamUnreadCount = recentSession.unreadCount + unionTeamUnreadCount;
                }
              } else if ([team.intro isEqualToString:@"3"]) { // 晓可客服
                if (recentSession.unreadCount > 0 && team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
                  xkSerUnreadCount = recentSession.unreadCount + xkSerUnreadCount;
                }
              }  else if ([team.intro isEqualToString:@"4"]) { // 店铺客服
                if (recentSession.unreadCount > 0 && team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
                  shopSerUnreadCount = recentSession.unreadCount + shopSerUnreadCount;
                }
              } else {
                if (recentSession.unreadCount > 0 && team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
                  teamUnreadCount = recentSession.unreadCount + teamUnreadCount;
                }
              }
            }
        }
        self.p2pRedStatus = p2pUnreadCount == 0 ? NO : YES;
        self.unionGroupRedStatus = unionTeamUnreadCount == 0 ? NO : YES;
        self.xkSerRedStatus = xkSerUnreadCount == 0 ? NO : YES;
        self.shopSerRedStatus = shopSerUnreadCount == 0 ? NO : YES;
        self.groupRedStatus = teamUnreadCount == 0 ? NO : YES;
        self.hasRedPoint = self.p2pRedStatus || self.groupRedStatus;
        [self updateUIForSepical];
    });
}

- (BOOL)getItemPointStatus {
    return self.hasRedPoint;
}

- (void)cleanItemRedPoint {
    self.hasRedPoint = NO;
    self.p2pRedStatus = NO;
    self.groupRedStatus = NO;
    self.unionGroupRedStatus = NO;
    self.xkSerRedStatus = NO;
    self.shopSerRedStatus = NO;
    [self updateUIForSepical];
}

- (void)updateUIForSepical {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:XKRedPointItemForIMNoti object:nil];
        EXECUTE_BLOCK(self.redStatusChange,self);
    });
}

@end
