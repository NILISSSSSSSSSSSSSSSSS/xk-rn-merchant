//
//  XKStoreBookingTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATShopGoodsItem;

typedef enum : NSUInteger {
    StoreBookingType_severice,//服务预定
    StoreBookingType_offline,//现场选购
} StoreBookingType;

typedef void(^BuyButtonBlock)(NSString *goodsId);

@interface XKStoreBookingTableViewCell : UITableViewCell

@property (nonatomic, assign) StoreBookingType type;
@property (nonatomic, copy  ) BuyButtonBlock   buyBlock;

- (void)setValueWithModel:(ATShopGoodsItem *)model;

@end
