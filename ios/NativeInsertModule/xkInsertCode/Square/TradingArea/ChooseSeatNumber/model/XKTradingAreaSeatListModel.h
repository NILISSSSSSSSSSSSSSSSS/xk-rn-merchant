//
//  XKTradingAreaSeatListModel.h
//  XKSquare
//
//  Created by hupan on 2018/11/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKTradingAreaSeatListModel : NSObject


@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * updatedAt;
@property (nonatomic , copy  ) NSString              * seatId;
@property (nonatomic , strong) NSArray <NSString *>  * images;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * seatTypeId;
@property (nonatomic , copy  ) NSString              * shopId;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , assign) BOOL                  isSelected;

@end
