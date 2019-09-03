//
//  XKEvaluateServiceViewController.h
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKEvaluateServiceViewController : BaseViewController

@property (nonatomic, copy) void(^confirmBtnBlock)(XKEvaluateServiceViewController *evaluateVC, NSUInteger starCount);

@end

NS_ASSUME_NONNULL_END
