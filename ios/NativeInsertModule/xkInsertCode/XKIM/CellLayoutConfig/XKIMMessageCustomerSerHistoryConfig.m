//
//  XKIMMessageCustomerSerHistoryConfig.m
//  xkMerchant
//
//  Created by xudehuai on 2019/2/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "XKIMMessageCustomerSerHistoryConfig.h"

@implementation XKIMMessageCustomerSerHistoryConfig

- (BOOL)shouldShowLeft:(NIMMessageModel *)model {
  return model.shouldShowLeft;
}

@end
