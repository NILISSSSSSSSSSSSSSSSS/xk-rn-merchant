//
//  XKFriendSyncListModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKFriendSyncListDataItem :NSObject

/**
 朋友备注名称
 */
@property (nonatomic , copy) NSString              * friendRemark;

/**
 密友关系
 */
@property (nonatomic , assign) NSInteger              secretRelation;

/**
 头像
 */
@property (nonatomic , copy) NSString              * avatar;

/**
 朋友ID
 */
@property (nonatomic , copy) NSString              * userId;

/**
 朋友昵称
 */
@property (nonatomic , copy) NSString              * nickname;

/**
 云信账号iD
 */
@property (nonatomic , copy) NSString              * accid;

/**
 朋友备注名称拼音
 */
@property (nonatomic , copy) NSString              * nicknamePy;

/**
 好友关系
 */
@property (nonatomic , assign) NSInteger              friendRelation;

/**
 关注关系[
 */
@property (nonatomic , assign) NSInteger              followRelation;

/**
 朋友备注名称拼音
 */
@property (nonatomic , copy) NSString              * friendRemarkPy;

@end


@interface XKFriendSyncListModel :NSObject
@property (nonatomic , strong) NSArray <XKFriendSyncListDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

@end

NS_ASSUME_NONNULL_END
