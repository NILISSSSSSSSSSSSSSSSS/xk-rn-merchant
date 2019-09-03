//
//  XKPersonDetailInfoViewController.h
//  XKSquare
//
//  Created by william on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

// 个人中心

#import "BaseViewController.h"

@class XKPesonalDetailInfoModel;

@interface XKPersonDetailInfoViewController : BaseViewController

/**是否是密友业务
 会判断是否添加可友还是添加密友 等等
 */
@property(nonatomic, assign) BOOL isSecret;
@property(nonatomic, copy) NSString *secretId;

/**是否是是接收申请的状态
 界面有申请信息和接受申请按钮
 */
@property(nonatomic, assign) BOOL isAcceptApply;
@property(nonatomic, copy) NSString *applyInfo;
@property(nonatomic, copy) NSString *applyId;

/**是否是是商户群设置禁言的业务
 */
@property(nonatomic, assign) BOOL isOfficalTeam;
@property(nonatomic, copy) NSString *teamId;


// 添加了好友的回调
@property(nonatomic, copy) void(^addFriend)(NSString *applyId);
//接收状态下被拉入黑名单的回调
@property(nonatomic, copy) void(^addBlackList)(NSString *userId);
@property(nonatomic, copy) void(^deleteBlock)(NSString *userId);
//用户状态改变的回调
@property(nonatomic, copy) void(^hasStatusChangedBlock)(XKPesonalDetailInfoModel *personalInfo);
/**userId 传入自己的id为个人主页 */
@property(nonatomic, copy) NSString *userId;

@end
