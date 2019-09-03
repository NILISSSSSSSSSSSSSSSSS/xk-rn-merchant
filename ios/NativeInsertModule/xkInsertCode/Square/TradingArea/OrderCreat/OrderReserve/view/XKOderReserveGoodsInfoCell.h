//
//  XKOderReserveGoodsInfoCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/28.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsSkuVOListItem;

typedef void(^ReserveGoodsValueBlock)(NSInteger num, NSInteger peopleNum, NSString *tipStr, BOOL refresh);
typedef void(^SeatChooseBlock)(void);

@interface XKOderReserveGoodsInfoCell : UITableViewCell

@property (nonatomic, copy  ) ReserveGoodsValueBlock  valueBlock;
@property (nonatomic, copy  ) SeatChooseBlock         seatChooseBlock;

- (void)setValueWithModel:(GoodsSkuVOListItem *)model reserveTime:(NSString *)reserveTime num:(NSInteger)num peopleNum:(NSInteger)peopleNum seatName:(NSString *)seatNames;
@end
