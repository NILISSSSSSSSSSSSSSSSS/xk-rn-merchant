//
//  XKOrderSureGoodsInfoFooterView.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XKOrderSureGoodsInfoFooterView : UITableViewHeaderFooterView

- (void)cutCornerWithRoundedRect:(CGRect)rect;
- (void)hiddenLine1View:(BOOL)hiddenView1 line2View:(BOOL)hiddenView2;
- (void)setPriceValue:(NSString *)price totalPrice:(NSString *)totalPrice;
@end

