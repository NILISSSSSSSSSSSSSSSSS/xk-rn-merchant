//
//  XKOnlineOrderSureGoodsInfoFooterView.h
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TipStrBlock)(NSString *tipStr);

@interface XKOnlineOrderSureGoodsInfoFooterView : UITableViewHeaderFooterView

@property (nonatomic, copy  ) TipStrBlock   tipStrBlock;

- (void)setValueWithTotalPrice:(CGFloat)totalPrice payPrice:(CGFloat)payPrice yunFei:(CGFloat)yunFei tipStr:(NSString *)tipStr;


@end

