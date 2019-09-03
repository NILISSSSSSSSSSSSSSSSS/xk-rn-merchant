//
//  XKVideoSearchViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchBaseViewController.h"

@class XKVideoSearchTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchViewController : XKVideoSearchBaseViewController

@property (nonatomic, strong) XKVideoSearchTopicModel *searchTopic;

@end

NS_ASSUME_NONNULL_END
