/*******************************************************************************
 # File        : XKSecretTipMsgManager.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/29
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
#import <NIMSDK/NIMSDK.h>
@interface XKSecretTipMsgManager : NSObject


+ (instancetype)shareManager;

/**更新密友圈提醒设置*/
- (void)updateSecretTipSetting;

/**更新指定密友圈活跃时间*/
- (void)updateSecretCircleActiveTime:(NSString *)secretId;

/**设置密友透传提醒消息*/
- (void)dealOutsideMessage:(NIMMessage *)message;

/**获取定时提醒消息*/
- (void)fetchUnReadTimerMsgListComplete:(void (^)(void))completionHandler;

- (BOOL)isOutsiderMan:(NSString *)userId;
@end
