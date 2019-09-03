//
//  XKVideoSearchResultModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XKVideoSearchUserModel.h"
#import "XKVideoSearchTopicModel.h"
#import "XKVideoDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchResultModel : NSObject

@property (nonatomic, strong) NSMutableArray <XKVideoSearchUserModel *>*users;

@property (nonatomic, strong) NSMutableArray <XKVideoSearchTopicModel *>*topics;

@property (nonatomic, strong) NSMutableArray <XKVideoDisplayVideoListItemModel *>*videos;

@end

NS_ASSUME_NONNULL_END
