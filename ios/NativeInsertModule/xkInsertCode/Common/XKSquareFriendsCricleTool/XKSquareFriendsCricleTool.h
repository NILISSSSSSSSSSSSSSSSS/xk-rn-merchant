//
//  XKSquareFriendsCricleTool.h
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XKSquareFriendsCricleTool : NSObject

/** 传did */
+ (void)friendsCircleLikeWithParameters:(NSDictionary *)parameters success:(void (^)(NSInteger status))success;

/** 传did 动态id*/
+ (void)requestLikeWithDid:(NSString *)did complete:(void (^)(NSString *, BOOL status))complete;

@end
