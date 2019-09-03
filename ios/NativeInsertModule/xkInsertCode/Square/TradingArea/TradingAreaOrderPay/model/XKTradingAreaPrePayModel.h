//
//  XKTradingAreaPrePayModel.h
//  XKSquare
//
//  Created by hupan on 2018/12/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChannelConfigsItem;


@interface XKTradingAreaPrePayModel : NSObject

@property (nonatomic , copy  ) NSString                       * amount;
@property (nonatomic , copy  ) NSString                       * body;
@property (nonatomic , strong) NSArray <ChannelConfigsItem *> * channelConfigs;
@property (nonatomic , copy  ) NSString                       * outTradeNo;
@property (nonatomic , copy  ) NSString                       * tradeNo;

@end


@interface ChannelConfigsItem :NSObject

@property (nonatomic , copy  ) NSString          * amount;
@property (nonatomic , copy  ) NSString          * payChannel;
@property (nonatomic , assign) BOOL                isInner;
@property (nonatomic , assign) BOOL                isPreChannel;

@end
