//
//  XKShowHeaderViewController.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^headerBlock)(NSString *imageUrl);
@interface XKShowHeaderViewController : BaseViewController
/*headerBlock**/
@property(nonatomic, copy) headerBlock headerBlock;
@property(nonatomic, assign) XKFriendHeaderControllerType  type;
@property(nonatomic, copy) NSString * headerUrl;
@property(nonatomic, copy) NSString * secretId;

@end

NS_ASSUME_NONNULL_END
