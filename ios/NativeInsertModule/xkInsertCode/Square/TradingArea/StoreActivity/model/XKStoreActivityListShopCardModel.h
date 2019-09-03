//
//  XKStoreActivityListShopCardModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopCardModel;

@interface XKStoreActivityListShopCardModel : NSObject

@property (nonatomic , strong) NSArray <ShopCardModel *>         * data;
@property (nonatomic , assign) NSInteger                         total;

@end


@interface ShopCardModel :NSObject

@property (nonatomic , copy  ) NSString              * memberType;
@property (nonatomic , copy  ) NSString              * discount;
@property (nonatomic , copy  ) NSString              * invalidTime;
@property (nonatomic , copy  ) NSString              * memberId;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * shopId;
@property (nonatomic , copy  ) NSString              * shopName;
@property (nonatomic , copy  ) NSString              * shopPic;
@property (nonatomic , assign) NSInteger              totalNum;
@property (nonatomic , copy  ) NSString              * validTime;
@property (nonatomic , assign) BOOL                whetherDraw;


@end





