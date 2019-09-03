//
//  XKCustomerSerHistoryConsultationViewController.h
//  xkMerchant
//
//  Created by xudehuai on 2019/1/31.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "BaseViewController.h"
#import "XKRNMerchantCustomerConsultationModel.h"

typedef NS_ENUM(NSUInteger, XKCustomerSerHistoryConsultationVCType) {
  XKCustomerSerHistoryConsultationVCTypeSingle, // 查看某个固定的task下的消息记录
  XKCustomerSerHistoryConsultationVCTypeFull, // 查看用户在该店铺下的所有消息记录
};

NS_ASSUME_NONNULL_BEGIN

@interface XKCustomerSerHistoryConsultationViewController : BaseViewController

@property (nonatomic, assign) XKCustomerSerHistoryConsultationVCType vcType;
/**
 XKCustomerSerHistoryConsultationVCTypeSingle 所需
 */
@property (nonatomic, copy) NSString *taskId;
/**
 XKCustomerSerHistoryConsultationVCTypeFull 所需
 */
@property (nonatomic, copy) NSString *customerId;

@end

NS_ASSUME_NONNULL_END
