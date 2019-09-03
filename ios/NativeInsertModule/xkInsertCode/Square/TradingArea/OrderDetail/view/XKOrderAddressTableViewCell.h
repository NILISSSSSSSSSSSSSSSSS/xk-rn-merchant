//
//  XKOrderAddressTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddresButtonBlock)(UIButton *sender);
typedef void(^ReservationButtonBlock)(UIButton *sender, NSArray *phoneArr);
typedef void(^ShareStoreButtonBlock)(UIButton *sender);

@interface XKOrderAddressTableViewCell : UITableViewCell

@property (nonatomic, copy  ) AddresButtonBlock      addresBtnBlock;
@property (nonatomic, copy  ) ReservationButtonBlock reservationBtnBlock;
@property (nonatomic, copy  ) ShareStoreButtonBlock  shareStoreButtonBlock;


- (void)showShareButton;
- (void)setValueWithShopName:(NSString *)shopName phoneList:(NSArray *)phoneList address:(NSString *)address lat:(double)lat lng:(double)lng;


@end
