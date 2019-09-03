//
//  XKTradingAreaCreatOderModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKTradingAreaCreatOderModel : NSObject

@property (nonatomic , copy) NSString                 * orderId;
@property (nonatomic , copy) NSString                 * orderStatus;
@property (nonatomic , assign) NSInteger              isAgree;
@property (nonatomic , copy) NSString                 * orderNo;
@property (nonatomic , copy) NSString                 * payStatus;
@property (nonatomic , copy) NSString                 * sceneStatus;
@property (nonatomic , copy) NSString                 * status;
@property (nonatomic , assign) NSInteger              userAgree;


@end
