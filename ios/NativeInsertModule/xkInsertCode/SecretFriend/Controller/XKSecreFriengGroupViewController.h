//
//  XKSecreFriengGroupViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/12/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKSecreFriengGroupViewController : BaseViewController
/**
 密友id
 */
@property(nonatomic, copy) NSString *secretId;

/**
 分组id
 */
@property(nonatomic, copy) NSString *groupId;
@end

NS_ASSUME_NONNULL_END
