//
//  XKBankCardListModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XKBankCardModel;

@interface XKBankCardListModel : NSObject

@property (nonatomic , strong) NSArray <XKBankCardModel *> *data;
@property (nonatomic , assign) NSInteger                    total;

@end


@interface XKBankCardModel :NSObject

@property (nonatomic , copy)   NSString              *bankName;
@property (nonatomic , copy)   NSString              *cardNumber;
@property (nonatomic , copy)   NSString              *createdAt;
@property (nonatomic , copy)   NSString              *cardId;
@property (nonatomic , copy)   NSString              *merchantId;
@property (nonatomic , copy)   NSString              *openBank;
@property (nonatomic , copy)   NSString              *phone;
@property (nonatomic , copy)   NSString              *realName;
@property (nonatomic , copy)   NSString              *status;
@property (nonatomic , copy)   NSString              *updatedAt;

@end
