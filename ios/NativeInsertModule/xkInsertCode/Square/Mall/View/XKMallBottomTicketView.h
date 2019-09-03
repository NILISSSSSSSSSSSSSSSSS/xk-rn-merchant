//
//  XKMallBottomTicketView.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKMallBuyCarItem;
@class XKTradingAreaOrderCouponModel;

typedef enum : NSUInteger {
    TicketViewType_mall,
    TicketViewType_tradingArea,
} TicketViewType;

@interface XKMallBottomTicketView : UIView

- (instancetype)initWithTicketArr:(NSArray *)ticketArr titleStr:(NSString *)title;

@property (nonatomic, assign) TicketViewType viewType;
@property (nonatomic, strong) NSArray        *dataArr;

@property (nonatomic, copy  ) void(^choseBlock)(XKMallBuyCarItem *item);
@property (nonatomic, copy  ) void(^tradingAreaChoseBlock)(XKTradingAreaOrderCouponModel *item);

@end
