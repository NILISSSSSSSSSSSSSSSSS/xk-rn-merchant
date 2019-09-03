//
//  XKMallOrderSureAddressCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKMallOrderSureAddressCell : XKBaseTableViewCell
- (void)updateInfoWithAddressName:(NSString *)addressName  phone:(NSString *)phone userName:(NSString *)userName;
@end

NS_ASSUME_NONNULL_END
