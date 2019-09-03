/*******************************************************************************
 # File        : XKRedPointItemForSys.m
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

#import "XKRedPointItemForSys.h"

#import <NIMSDK/NIMSDK.h>
#import "XKIMGlobalMethod.h"

@implementation XKRedPointItemForSys
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetItemRedPointStatus) name:XKTabbarMessageSystemRedPointChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetItemRedPointStatus {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSArray *list = [XKIMGlobalMethod getLatestSysChatListArray];
        NSInteger unreadCount = 0;
        for (NIMRecentSession *recentSession in list) {
            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:recentSession.session.sessionId];
            if (recentSession.unreadCount > 0 && user.notifyForNewMsg) {
                unreadCount = recentSession.unreadCount + unreadCount;
            }
        }
        self.hasRedPoint = unreadCount == 0 ? NO : YES;
        [self updateUIForSepical];
    });
}

- (void)updateUIForSepical {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:XKRedPointItemForSysNoti object:nil];
        EXECUTE_BLOCK(self.redStatusChange,self);
    });
}

@end
