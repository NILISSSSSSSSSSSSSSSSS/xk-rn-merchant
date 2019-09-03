//
//  XKMallCategotyListModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MallIconItem :NSObject
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , assign) NSInteger              moveEnable;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * icon;
@property (nonatomic , assign) NSInteger              weight;
@property (nonatomic , assign) BOOL                isChose;
@end

@interface ChildrenObj :NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , assign) NSInteger              pCode;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@end

@interface ChildrenItem :NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , strong) NSArray <ChildrenObj *> * children;
@property (nonatomic , assign) NSInteger              pCode;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@end

@interface XKMallCategoryListModel : NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , strong) NSArray <ChildrenItem *>              * children;
@property (nonatomic , assign) NSInteger              pCode;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , assign) NSInteger              moveEnable;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * listType;
@property (nonatomic , strong) NSArray <MallIconItem *>              * notFixed;
@property (nonatomic , strong) NSArray <MallIconItem *>              * fixed;
/**
 返回所有商品分类

 @param success 所有商品分类
 @param failed 失败原因
 */
+ (void)requestMallCategotyListSuccess:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;

/**
 返回新版首页icon分类
 
 @param success icon分类
 @param failed 失败原因
 */
+ (void)requestNewMallIconListSuccess:(void(^)(XKMallCategoryListModel *model))success failed:(void(^)(NSString *failedReason))failed;
@end
