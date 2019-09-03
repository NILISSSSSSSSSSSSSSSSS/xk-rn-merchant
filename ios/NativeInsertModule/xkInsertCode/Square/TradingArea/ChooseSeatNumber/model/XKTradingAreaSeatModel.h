//
//  XKTradingAreaSeatModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XKSetItem;

@interface XKTradingAreaSeatModel : NSObject

@property (nonatomic , strong) NSArray <XKSetItem *>  * data;
@property (nonatomic , assign) NSInteger              total;

@end


@interface XKSetItem :NSObject

@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy  ) NSString              * shopId;
@property (nonatomic , copy  ) NSString              * seatTypeId;
@property (nonatomic , copy  ) NSString              * seatTypeName;

@end

