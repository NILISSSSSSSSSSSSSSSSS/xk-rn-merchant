//
//  XKOderReserveHotelInfoCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsSkuVOListItem;

typedef void(^ReserveHotelValueBlock)(NSString *startDateStr, NSString *endDateStr, NSInteger houseNum, NSInteger peopleNum, NSString *tips, BOOL refresh);

@interface XKOderReserveHotelInfoCell : UITableViewCell

@property (nonatomic, copy  ) ReserveHotelValueBlock  valueBlock;

- (void)setValueWithModel:(GoodsSkuVOListItem *)model startDateStr:(NSString *)startDateStr endDateStr:(NSString *)endDateStr hoseNum:(NSInteger)num peopleNum:(NSInteger)peopleNum tipStr:(NSString *)tips;

@end
