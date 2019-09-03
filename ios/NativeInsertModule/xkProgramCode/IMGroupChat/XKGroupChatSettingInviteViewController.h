//
//  XKCustomerServiceManageListViewController.h
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKGroupChatSettingInviteViewController : BaseViewController

/**<##>*/
@property(nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString  *merchantType;

/**用户管理*/
@property(nonatomic, copy) void(^userListChange)(void);

@end

NS_ASSUME_NONNULL_END
