//
//  XKPerfectPersonalViewController.h
//  XKSquare
//
//  Created by Lin Li on 2019/4/28.
//  Copyright © 2019 xk. All rights reserved.
//
/*
 可友资料，个人资料，密友资料都用这个控制器
  */
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKPerfectPersonalViewController : BaseViewController
/**密友资料才使用secretId*/
@property(nonatomic, copy) NSString *secretId;
/**可友资料使用-信息变化回调*/
@property(nonatomic, copy) void(^infoChange)(void);
/**控制器类型*/
@property(nonatomic, assign) perfectPersonalType vcType;
@end

NS_ASSUME_NONNULL_END
