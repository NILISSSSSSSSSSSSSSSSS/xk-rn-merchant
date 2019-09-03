//
//  XKWelfareShareModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/12/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XKWelfareCommentAward :NSObject
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * type;

@end


@interface XKWelfareShareGoods :NSObject
@property (nonatomic , copy) NSString              * atrrName;
@property (nonatomic , assign) NSInteger             categoryCode;
@property (nonatomic , strong) XKWelfareCommentAward * commentAward;
@property (nonatomic , copy) NSString              * goodsType;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * mainPic;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              purchaseNumber;
@property (nonatomic , copy) NSString              * usage;
@property (nonatomic , copy) NSString              * userType;

@end


@interface XKWelfareLotteryWay :NSObject
@property (nonatomic , assign) NSInteger              eachNotePrice;
@property (nonatomic , assign) NSInteger              eachSequenceNumber;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * jDrawType;
@property (nonatomic , strong) NSArray <NSNumber *>              * lotteryDate;
@property (nonatomic , assign) NSInteger              totalPrice;
@property (nonatomic , assign) NSInteger              totalSequenceNumber;

@end


@interface XKWelfareShareSequence :NSObject
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , assign) NSInteger              currentCustomerNum;
@property (nonatomic , assign) NSInteger              currentNper;
@property (nonatomic , assign) NSInteger              expectLotteryDate;
@property (nonatomic , strong) XKWelfareShareGoods              * goods;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , assign) NSInteger              isDisabled;
@property (nonatomic , assign) NSInteger              isFreeShipping;
@property (nonatomic , assign) NSInteger              isPaused;
@property (nonatomic , copy) NSString              * jPeriodState;
@property (nonatomic , strong) XKWelfareLotteryWay              * lotteryWay;
@property (nonatomic , assign) NSInteger              remaindNumber;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              thirdWinningNumber;
@property (nonatomic , assign) NSInteger              thirdWinningTime;
@property (nonatomic , assign) NSInteger              updatedAt;

@end

@interface XKWelfareShareParam : NSObject
@property (nonatomic , strong) XKWelfareShareSequence              * sequence;
@property (nonatomic , copy) NSString              * detailPics;
@property (nonatomic , strong) NSArray <NSString *>              * mainPics;
@property (nonatomic, assign) NSInteger  quantity;

@end


@interface XKWelfareShareModel :NSObject
@property (nonatomic , copy) NSString              * shareUrl;
@property (nonatomic , strong) XKWelfareShareParam              * param;

@end

NS_ASSUME_NONNULL_END
