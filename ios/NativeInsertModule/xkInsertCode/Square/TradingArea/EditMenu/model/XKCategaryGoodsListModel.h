//
//  XKCategaryGoodsListModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CategaryGoodsItem;

@interface XKCategaryGoodsListModel : NSObject

@property (nonatomic , strong) NSArray <CategaryGoodsItem *>    * data;
@property (nonatomic , assign) NSInteger                        total;

@end


@interface CategaryGoodsItem :NSObject

@property (nonatomic , assign) CGFloat              discountPrice;
@property (nonatomic , assign) CGFloat              originalPrice;
@property (nonatomic , assign) NSInteger              saleM;
@property (nonatomic , copy) NSString              * goodsId;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , copy) NSString              * mainPic;

@end



