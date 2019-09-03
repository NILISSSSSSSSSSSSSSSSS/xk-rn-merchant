//
//  XKCustomerServiceHistoryListViewController.h
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, XKCustomerServiceType) {
  XKCustomerServiceTypeNormal  = 0, 
  XKCustomerServiceTypeAbnormal
};
NS_ASSUME_NONNULL_BEGIN

@interface XKCustomerServiceHistoryListViewController : BaseViewController
/**当前控制器状态*/
@property(nonatomic, assign) XKCustomerServiceType serviceType;
@end

NS_ASSUME_NONNULL_END
