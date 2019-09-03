//
//  XKRNMerchantCustomerConsultationModel.m
//  xkMerchant
//
//  Created by xudehuai on 2019/2/12.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKRNMerchantCustomerConsultationModel.h"

@implementation XKRNMerchantCustomerConsultationMessageModel

//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
//  return @{@"msg": [XKIMMessageBaseAttachment class]};
//}

@end

@implementation XKRNMerchantCustomerConsultationModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
  return @{@"msg": [XKRNMerchantCustomerConsultationMessageModel class]};
}

@end
