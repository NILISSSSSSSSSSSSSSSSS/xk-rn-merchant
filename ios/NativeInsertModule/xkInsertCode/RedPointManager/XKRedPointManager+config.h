//
//  XKRedPointManager+config.h
//  XKSquare
//
//  Created by Jamesholy on 2018/11/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedPointManager.h"
#import "XKTabBarMsgRedPointItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKRedPointManager (config)

+ (void)configAllItem;

+ (XKTabBarMsgRedPointItem *)getMsgTabBarRedPointItem;

@end

NS_ASSUME_NONNULL_END
