//
//  XKWelfareCategoryModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"
@interface WelfareIconItem :NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , assign) NSInteger              moveEnable;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , assign) NSInteger              weight;
@property (nonatomic , assign) BOOL                isChose;
@end
@interface XKWelfareCategoryModel : BaseModel
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , strong) NSArray <WelfareIconItem *>              * notFixed;
@property (nonatomic , strong) NSArray <WelfareIconItem *>              * fixed;

+ (void)requestWelfareCategotyListSuccess:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;

/**
 返回新版首页icon分类
 
 @param success icon分类
 @param failed 失败原因
 */
+ (void)requestNewWelfareIconListSuccess:(void(^)(XKWelfareCategoryModel *model))success failed:(void(^)(NSString *failedReason))failed;
@end
