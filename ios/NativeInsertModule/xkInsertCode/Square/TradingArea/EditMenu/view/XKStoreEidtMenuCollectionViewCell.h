//
//  XKStoreEidtMenuCollectionViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategaryGoodsItem;

typedef enum : NSUInteger {
    EidtMenuCellType_default,//现场购买、外卖、服务
    EidtMenuCellType_hotel,
} EidtMenuCellType;

@protocol EidtMenuCollectionViewDelegate <NSObject>

- (void)chooseGuigeButtonSelected:(UIButton *)sender;

@end

@interface XKStoreEidtMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak  ) id<EidtMenuCollectionViewDelegate> delegate;

- (void)hiddenLineView:(BOOL)hidden;
- (void)hiddenChooseView:(BOOL)viewHidden hiddenChooseGuigeBtn:(BOOL)btnHidden;

- (void)setValueWithModel:(CategaryGoodsItem *)model cellType:(EidtMenuCellType)cellType indexPath:(NSIndexPath *)indexPath;

@end
