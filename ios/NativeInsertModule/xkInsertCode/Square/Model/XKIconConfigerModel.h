//
//  XKIconConfigerModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKIconConfigerModel : NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , assign) NSInteger              moveEnable;
@property (nonatomic , copy) NSString              * status;

/**
 返回新版首页icon分类
 
 @param success icon分类
 @param failed 失败原因
 */
+ (void)requestNewMallIconListSuccess:(void(^)(NSArray *arr))success failed:(void(^)(NSString *failedReason))failed;
@end

NS_ASSUME_NONNULL_END
