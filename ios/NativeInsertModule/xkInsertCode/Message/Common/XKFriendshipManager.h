/*******************************************************************************
 # File        : XKFriendshipManager.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/29
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
#import "XKContactModel.h"
@interface XKFriendshipManager : NSObject

/**
 添加好友
 @param userId 被添加者id
 @param successApply 回调 （添加好友会跳转新界面  成功发出好友申请会回调此block 弹框内部处理）
 */
+ (void)addFriend:(NSString *)userId successApply:(void(^)(void))successApply;

/**
 添加密友

 @param userId 被添加者id
 @param secretId 密友圈id
 @param successApply 回调 （添加密友会跳转新界面  成功发出密友申请会回调此block 弹框内部处理）
 */
+ (void)addSecretFriend:(NSString *)userId withSecretId:(NSString *)secretId successApply:(void(^)(void))successApply;

/**
 添加密友  是可友的情况 不用验证 直接添加
 
 @param userId 被添加者id
 @param secretId 密友圈id
 @param complete 回调
 */
+ (void)addSecretFriendWithoutAgree:(NSString *)userId needDeleteFriend:(BOOL)delete withSecretId:(NSString *)secretId complete:(void(^)(NSString *error,id data))complete;

/**
 好友申请处理

 @param allow 是否允许
 @param applyId 申请记录id
 @param complete 回调
 */
+ (void)requestOperateFriendApply:(BOOL)allow applyId:(NSString *)applyId complete:(void(^)(NSString *error,id data))complete;


/**
 修改密友所属组/移除组

 @param groupId 为空代表移除
 @param userId 用户id
 @param secretId 密友圈id
 @param complete 回调
 */
+ (void)requestChangeSecretFriendGroup:( NSString * _Nullable )groupId userId:(NSString *)userId withSecretId:(NSString *)secretId complete:(void(^)(NSString *error,id data))complete;

/**
 修改可友所属组/移除组
 @param groupId 为空代表移除
 @param userId 用户id
 @param complete 回调
 */
+ (void)requestChangeFriendGroup:( NSString * _Nullable )groupId userId:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;


/**
 设置朋友圈查看权限
 @param authorityType 0 不看他的朋友圈  1 不让他看我的朋友圈
 @param allow 是否允许
 @param friendId 朋友id
 @param complete complete description
 */
+ (void)requestSetFriendCircleAuthorityType:(NSInteger)authorityType allow:(BOOL)allow friendId:(NSString *)friendId complete:(void(^)(NSString *error,id data))complete;

/**关注某人*/
+ (void)requestFocus:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;
/**取关某人*/
+ (void)requestNoFocus:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;
/**关注复合接口*/
+ (void)requestFocus:(BOOL)focus userId:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;

/**加入黑名单*/
+ (void)requestAddBlackList:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;
/**移除黑名单*/
+ (void)requestRemoveBlackList:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;
/**黑名单复合接口*/
+ (void)requestBlackListStatus:(BOOL)add userId:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;

/**删除可友*/
+ (void)requestDeleteFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;
/**删除密友*/
+ (void)requestDeleteSecretFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;
/**删除密友 并删除可友  同时为密友的情况*/
+ (void)requestDeleteSecretFriendBothDeleteFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;
/**删除密友 并转为可友  单密友的情况*/
+ (void)requestDeleteSecretFriendBothReturnFriend:(NSString *)userId complete:(void(^)(NSString *error,id data))complete;

/**
 从服务器搜索列表中过滤出陌生人  如果仅搜出一个人并且 是自己好友的话 singleIsMyFriend为Yes
 
 @param users 服务器数据
 @param userKey 搜索词
 @param result 回调
 */
+ (void)filterStrangerUserWithUsers:(NSArray <XKContactModel *>*)users userKey:(NSString *)userKey result:(void (^)(NSArray *users,BOOL singleIsMyFriend))result;

@end
