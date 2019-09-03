//
//  XKSquareGoodsRecommendModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsItem;

@interface XKSquareGoodsRecommendModel :NSObject

@property (nonatomic , strong) NSArray <GoodsItem *>  *data;
@property (nonatomic , assign) BOOL                   empty;
@property (nonatomic , assign) NSInteger              total;

@end


@interface GoodsItem :NSObject

@property (nonatomic , copy  ) NSString              * price;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * goodsId;
@property (nonatomic , copy  ) NSString              * pic;
@property (nonatomic , copy  ) NSString              * video;
@property (nonatomic , copy  ) NSString              * skuName;
@property (nonatomic , assign) NSInteger              saleQ;

@end







