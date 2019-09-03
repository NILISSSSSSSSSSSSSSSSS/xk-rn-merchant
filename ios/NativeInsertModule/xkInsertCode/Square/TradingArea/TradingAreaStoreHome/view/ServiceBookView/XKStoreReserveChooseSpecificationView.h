//
//  XKStoreReserveChooseSpecificationView.h
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XKTradingAreaGoodsInfoModel;
@class GoodsSkuVOListItem;


typedef enum : NSUInteger {
    viewType_service,
    viewType_hetol,
} SpecificationViewType;

typedef void(^CloseBlock)(void);
typedef void(^NextBlock)(GoodsSkuVOListItem *skuItem, NSString *time, SpecificationViewType viewType);

@interface XKStoreReserveChooseSpecificationView : UIView

@property (nonatomic, copy  ) CloseBlock   closeBlock;
@property (nonatomic, copy  ) NextBlock    nextBlock;

- (void)setValueWithModel:(XKTradingAreaGoodsInfoModel *)model viewType:(SpecificationViewType)viewType;

@end
