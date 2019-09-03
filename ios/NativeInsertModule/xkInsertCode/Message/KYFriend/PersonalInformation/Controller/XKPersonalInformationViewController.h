//
//  XKPersonalInformationViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKPersonalInformationViewController : BaseViewController

/**信息变化回调*/
@property(nonatomic, copy) void(^infoChange)(void);

@end

NS_ASSUME_NONNULL_END
