//
//  XKWelfareOrderListViewModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger, WelfareListType) {
    WLT_WelfareListTypeAll = 0,   //全部
    WLT_WelfareListTypeWaitOpen,  //待开奖
    WLT_WelfareListTypeWin,       //已中奖
    WLT_WelfareListTypeFinish     //已完成
};

typedef NS_ENUM(NSInteger, WelfareListPosition) {
    WLP_WelfareListPositionOnly = 0,   //唯一一个
    WLP_WelfareListPositionFirst,      //第一个
    WLP_WelfareListPositionLast,       //最后一个
    WLP_WelfareListPositionOther        //其他
};

@interface WelfareOrderDataItem :NSObject
//订单
@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              joinCount;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * orderNumber;
/**
订单状态
 */
@property (nonatomic , copy) NSString              * state;

/**
 未发货的时候 这个字段来区分是否已经分享 NOT_SHARE  YES_SHARE
 */
@property (nonatomic , copy) NSString              * goodsShare;
@property (nonatomic , assign) NSInteger              termNumber;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * drawType;
@property (nonatomic , copy) NSString              *  expectDrawTime;
@property (nonatomic , copy) NSString              *  factDrawDate;
@property (nonatomic , assign) NSInteger              maxStake;


@property (nonatomic , assign) NSInteger              lotteryTime;
@property (nonatomic , assign) NSInteger              maxRate;
@property (nonatomic , assign) NSInteger              participateStake;
@property (nonatomic , assign) NSInteger              totalStake;
@property (nonatomic , assign) NSInteger              currentIndex;
@property (nonatomic, strong) NSIndexPath          *index;
@end


@interface XKWelfareOrderListViewModel : BaseModel
@property (nonatomic , assign) BOOL   manager;
@property (nonatomic , assign) NSInteger   page;
@property (nonatomic , assign) NSInteger   limit;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, assign) NSTimeInterval  timestamp;
@property (nonatomic , strong) NSArray <WelfareOrderDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

+ (void)requestWelfareGoodsListWithOrderType:(WelfareListType)orderType param:(NSDictionary *)dic success:(void(^)(XKWelfareOrderListViewModel *model))success failed:(void(^)(NSString *failedReason))failed;
@end
