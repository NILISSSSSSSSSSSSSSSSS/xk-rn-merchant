//
//  XKOderReserveOrderInfoCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    OrderInfoCellType_service,
    OrderInfoCellType_hotel,
} OrderInfoCellType;
/*
typedef void(^ChooseCouponPackageBlock)(NSString *CouponId);*/

typedef void(^OrderInfoValueBlock)(NSString *phoneNun, NSString* userName);

@interface XKOderReserveOrderInfoCell : UITableViewCell

@property (nonatomic, assign) OrderInfoCellType         cellType;
/*
@property (nonatomic, copy  ) ChooseCouponPackageBlock  chooseCouponBlock;*/
@property (nonatomic, copy  ) OrderInfoValueBlock       valueBlock;
@property (nonatomic, assign) BOOL                      hiddenUserName;


- (void)setValueWithSinglePrice:(CGFloat)price num:(NSInteger)num days:(NSInteger)days phoneNum:(NSString *)phone userName:(NSString *)userName;


@end
