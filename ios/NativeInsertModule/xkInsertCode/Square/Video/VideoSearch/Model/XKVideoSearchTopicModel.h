//
//  XKVideoSearchTopicModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchTopicModel : NSObject

@property (nonatomic, assign) NSUInteger id;

@property (nonatomic, copy) NSString *topic_name;

@property (nonatomic, assign) NSUInteger use_num;


@property (nonatomic, copy) NSString *searchKeyword;

@property (nonatomic, assign) NSInteger serialNum;

@end

NS_ASSUME_NONNULL_END
