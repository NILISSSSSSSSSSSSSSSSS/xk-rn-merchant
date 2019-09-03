//
//  XKBusinessAreaOrderListModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AreaOrderListModel;

@interface XKBusinessAreaOrderListModel : NSObject

@property (nonatomic , assign) NSInteger                             total;
@property (nonatomic , strong) NSArray <AreaOrderListModel *>       * data;

@end



@interface XKOrderDetailGoodsItem : NSObject

@property (nonatomic , copy  ) NSString              * itemId;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * platformPrice;
@property (nonatomic , assign ) NSInteger              purchaseNum;
@property (nonatomic , assign ) CGFloat                purchasePrice;
@property (nonatomic , copy  ) NSString              * skuName;
@property (nonatomic , copy  ) NSString              * skuUrl;


@end



@interface AreaOrderListModel :NSObject

@property (nonatomic , copy  ) NSString                                  * appointRange;
@property (nonatomic , copy  ) NSString                                  * consumer;
@property (nonatomic , strong) NSArray <XKOrderDetailGoodsItem *>        * goods;
@property (nonatomic , assign) NSInteger                                 itemNum;

@property (nonatomic , copy  ) NSString                                  * orderId;
@property (nonatomic , copy  ) NSString                                  * phone;
@property (nonatomic , copy  ) NSString                                  * shopId;
@property (nonatomic , copy  ) NSString                                  * shopName;
@property (nonatomic , copy  ) NSString                                  * orderStatus;
@property (nonatomic , copy  ) NSString                                  * bcleOrderPayStatus;
@property (nonatomic , copy  ) NSString                                  * sceneStatus;
@property (nonatomic , assign) BOOL                                      isSelfLifting;
@property (nonatomic , assign) BOOL                                      isChose;


@end

