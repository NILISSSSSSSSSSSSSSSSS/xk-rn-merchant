//
//  XKCustomerServiceManageAddViewController.h
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BaseViewController.h"
#import "XKContactModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKGroupChatManageAddViewController : BaseViewController


@property(nonatomic, copy) NSString *teamId;
@property(nonatomic, copy) NSString *merchantType;
@property(nonatomic, copy) void(^addBlock)(NSArray <XKContactModel *>*users);

@end

NS_ASSUME_NONNULL_END
