//
//  XKWelfareGoodsListViewModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WelfareDataItem :NSObject
@property (nonatomic , copy) NSString              * sequenceId;
@property (nonatomic , copy) NSString              * drawStatus;
@property (nonatomic , assign) NSInteger              perPrice;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , assign) NSInteger              joinCount;
@property (nonatomic , copy) NSString              * drawType;
@property (nonatomic , assign) NSInteger              maxRate;
@property (nonatomic , copy) NSString              * categoryCode;
@property (nonatomic , copy) NSString              * showAttr;
@property (nonatomic , assign) NSInteger              runningDate;
@property (nonatomic , assign) NSInteger              createAt;
@property (nonatomic , copy) NSString              *  expectDrawTime;
@property (nonatomic , assign) NSInteger              currentNper;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , assign) NSInteger              drawDate;
@property (nonatomic , assign) NSInteger              maxStake;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * mainUrl;
@property (nonatomic, copy) NSString             *sharePath;


@end
@interface XKWelfareGoodsListViewModel : NSObject
@property (nonatomic , copy) NSString      *name;
@property (nonatomic , copy) NSString      *keyword;
@property (nonatomic , copy) NSString      *type;
@property (nonatomic , assign) NSInteger   isDesc;
@property (nonatomic , assign) NSInteger   page;
@property (nonatomic , assign) NSInteger   limit;
@property (nonatomic, assign) NSTimeInterval  timestamp;
@property (nonatomic , assign) NSInteger   category;
@property (nonatomic, strong) NSArray  *dataSourceArr;
@property (nonatomic , strong) NSArray <WelfareDataItem *>              * data;

+ (void)requestWelfareGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;

+ (void)requestWelfareRecommendGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;

+ (void)requestWelfarePlatformGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;

+ (void)requestWelfareStoremGoodsListWithParam:(NSDictionary *)dic success:(void(^)(NSArray *modelList))success failed:(void(^)(NSString *failedReason))failed;
@end
