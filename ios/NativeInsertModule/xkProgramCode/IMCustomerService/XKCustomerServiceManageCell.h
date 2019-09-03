//
//  XKCustomerServiceManageCell.h
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKBaseTableViewCell.h"
#import "XKContactModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XKCustomerServiceManageCell : XKBaseTableViewCell
- (void)managerModel:(BOOL)isManage;
/**<##>*/
@property(nonatomic, strong) XKContactModel *user;
@end

NS_ASSUME_NONNULL_END
