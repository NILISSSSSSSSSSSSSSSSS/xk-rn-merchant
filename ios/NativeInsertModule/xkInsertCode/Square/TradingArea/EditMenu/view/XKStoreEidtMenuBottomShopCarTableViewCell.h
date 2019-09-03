//
//  XKStoreEidtMenuBottomShopCarTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsSkuVOListItem;
typedef void(^RefreshBlock)(void);

@interface XKStoreEidtMenuBottomShopCarTableViewCell : UITableViewCell

@property (nonatomic, copy  ) RefreshBlock refreshBlock;
@property (nonatomic, assign) NSUInteger   xkIndustryType;
- (void)setValueWithModel:(GoodsSkuVOListItem *)model shopId:(NSString *)shopId num:(NSInteger)num;

@end
