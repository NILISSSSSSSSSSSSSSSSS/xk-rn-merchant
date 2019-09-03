//
//  NSString+XKSensitive.h
//  XKSquare
//
//  Created by Jamesholy on 2019/4/1.
//  Copyright © 2019 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XKSensitive)

- (instancetype)sensitiveFilter;
- (instancetype)sensitiveFilterForVideo;
- (instancetype)sensitiveFilterForBcircle;

@end

NS_ASSUME_NONNULL_END
