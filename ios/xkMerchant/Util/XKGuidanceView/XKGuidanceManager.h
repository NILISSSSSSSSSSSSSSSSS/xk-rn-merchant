//
//  XKGuidanceManager.h
//  XKSquare
//
//  Created by Lin Li on 2019/1/19.
//  Copyright © 2019 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XKGuidanceManagerType) {
    XKGuidanceManagerXKCloseFriendPersonalInformationViewController             = 0,        // 密友个人资料
    XKGuidanceManagerXKSecretChatSettingViewController                          = 1,        // 聊天详情
    XKGuidanceManagerXKSecretChatViewController                                 = 2,        // 密友聊天界面
    XKGuidanceManagerXKSecretTipEditController                                  = 3,        // 提醒消息
    XKGuidanceManagerXKSecretTipSettingController                               = 4,        // 选择投射对象
    XKGuidanceManagerXKSecretFriendRootViewController                           = 5,        // 设置提醒
    XKGuidanceManagerXKSecretFriendRootViewController2                          = 6,        // 密友首页更多
    XKGuidanceManagerXKPrivacySettingViewController                             = 7,        // 隐私设置
    XKGuidanceManagerXKPrivacyCreateSecretFriendCircleViewController            = 8,        // 新建密友圈
    XKGuidanceManagerXKMallBuyCarCountViewController                            = 9,        // 确认订单
    XKGuidanceManagerXKSubscriptionViewController                               = 10,
        //首页内容订阅
};

@interface XKGuidanceManager : NSObject
/**
 控制是否显示GuidanceView
 */
+ (void)configShowGuidanceViewType:(XKGuidanceManagerType)type TransparentRectArr:(NSArray * )transparentRectArr;

@end

NS_ASSUME_NONNULL_END
