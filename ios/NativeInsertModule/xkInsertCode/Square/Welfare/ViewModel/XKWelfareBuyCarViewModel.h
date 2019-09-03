
//
//  XKWelfareBuyCarViewModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"
@interface XKWelfareDrawDetail :NSObject
@property (nonatomic , assign) NSInteger              perPrice;
@property (nonatomic , assign) NSInteger              joinCount;
@property (nonatomic , copy) NSString              * drawStatus;
@property (nonatomic , copy) NSString              * drawType;
@property (nonatomic , assign) NSInteger              currentNper;
@property (nonatomic , assign) NSInteger              sId;
@property (nonatomic , assign) NSInteger              maxStake;

@end


@interface XKWelfareGoods :NSObject
@property (nonatomic , copy) NSString              * skuName;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , assign) NSInteger              lotteryNumber;
@property (nonatomic , strong) NSArray <NSString *>              * pic;
@property (nonatomic , copy) NSString              * detail;
@property (nonatomic , copy) NSString              * goodsName;

@end

@interface XKWelfareBuyCarItem : BaseModel
@property (nonatomic , assign) NSInteger              quantity;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , assign) NSInteger              participateStake;
@property (nonatomic , assign) NSInteger              drawTime;
@property (nonatomic , copy) NSString              * drawType;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              lotteryNumber;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              maxStake;
@property (nonatomic, copy) NSString  *sequenceId;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL selected;


@end

@interface XKWelfareBuyCarViewModel : BaseModel
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *choseArr;
@property (nonatomic, assign) BOOL manager;
@property (nonatomic, assign) long totalPoint;
@property (nonatomic, assign) BOOL lostCount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger  limit;

@property (nonatomic , strong) NSArray <XKWelfareBuyCarItem *>              * data;
@property (nonatomic , assign) NSInteger              total;
//详情直接购买
@property (nonatomic , strong) XKWelfareDrawDetail              * drawDetail;
@property (nonatomic , strong) XKWelfareGoods              * goods;
@property (nonatomic , assign) NSInteger              quantity;
/**请求购物车列表*/
+ (void)requestWelfareBuyCarListWithParam:(NSDictionary *)dic success:(void(^)(XKWelfareBuyCarViewModel *model))success failed:(void(^)(NSString *failedReason))failed;

/**批量删除*/
+ (void)deleteWelfareBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed;

/**收藏*/
+ (void)collectWelfareBuyCarListWithDeleteArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed;

/**批量修改数量*/
+ (void)changeWelfareBuyCarListNumberWithAllArr:(NSArray *)arr success:(void(^)(NSArray *modelArr))success failed:(void(^)(NSString *failedReason))failed;

/*下单*/
+ (void)orderWelfareGiveOrderParmDic:(NSDictionary *)dic success:(void(^)(id respson))success failed:(void(^)(NSString *failedReason))failed;
/**支付*/
+ (void)orderWelfarePayParmDic:(NSDictionary *)dic success:(void(^)(id respson))success failed:(void(^)(NSString *failedReason))failed;
@end
