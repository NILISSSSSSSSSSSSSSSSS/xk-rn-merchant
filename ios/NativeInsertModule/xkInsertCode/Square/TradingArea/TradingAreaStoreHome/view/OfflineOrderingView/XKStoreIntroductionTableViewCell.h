//
//  XKStoreIntroductionTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKAutoScrollView;
@class XKAutoScrollImageItem;
@class XKTradingAreaShopInfoModel;

typedef enum : NSUInteger {
    IntroductionCellType_offlineOrdering,
    IntroductionCellType_serviceBook,
} IntroductionCellType;


typedef void(^AddresButtonBlock)(UIButton *sender);
typedef void(^ReservationButtonBlock)(UIButton *sender, NSArray *phoneArr, IntroductionCellType cellType);
typedef void(^StoreCoverItemBlock)(XKAutoScrollView *autoScrollView, XKAutoScrollImageItem *item, NSInteger index);


@interface XKStoreIntroductionTableViewCell : UITableViewCell

@property (nonatomic, copy  ) AddresButtonBlock      addresBtnBlock;
@property (nonatomic, copy  ) ReservationButtonBlock reservationBtnBlock;
@property (nonatomic, copy  ) StoreCoverItemBlock    coverItemBlock;

@property (nonatomic, assign) IntroductionCellType   cellType;

- (void)setIntroductionTableViewCelltype:(IntroductionCellType)cellType;
- (void)setValueWithModel:(XKTradingAreaShopInfoModel *)model;

@end
