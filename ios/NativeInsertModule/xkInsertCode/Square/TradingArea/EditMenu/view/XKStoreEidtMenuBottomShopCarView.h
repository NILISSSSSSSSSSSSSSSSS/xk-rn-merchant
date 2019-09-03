//
//  XKStoreEidtMenuBottomShopCarView.h
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsSkuVOListItem;

typedef void(^ClearBlock)(void);
typedef void(^RefreshBlock)(void);
typedef void(^GotoBuyBlock)(void);
@interface XKStoreEidtMenuBottomShopCarView : UIView

@property (nonatomic, copy  ) RefreshBlock  refreshBlock;
@property (nonatomic, copy  ) ClearBlock    clearBlock;
@property (nonatomic, copy  ) GotoBuyBlock  gotoBuyBlock;

@property (nonatomic, copy  ) NSString      *shopId;
@property (nonatomic, assign) NSUInteger    xkIndustryType;

- (void)setValueWithModelArr:(NSArray<NSArray<GoodsSkuVOListItem *> *> *)modelArr;

@end
