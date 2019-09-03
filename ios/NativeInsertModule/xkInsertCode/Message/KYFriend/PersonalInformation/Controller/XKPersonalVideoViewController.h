//
//  XKPersonalVideoViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKPersonalVideoViewController : BaseViewController
/**controller的类型*/
@property(nonatomic, assign) XKPersonalVideoControllerType type;
/**userid*/
@property(nonatomic, copy) NSString *rid;

@end

NS_ASSUME_NONNULL_END
