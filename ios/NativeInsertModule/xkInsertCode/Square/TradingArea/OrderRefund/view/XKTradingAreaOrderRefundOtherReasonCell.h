//
//  XKTradingAreaOrderRefundOtherReasonCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ValueChangedBlock)(NSString *reson);

@interface XKTradingAreaOrderRefundOtherReasonCell : UITableViewCell

@property (nonatomic, copy  ) ValueChangedBlock   valueChangedBlock;

- (void)setNameLableText:(NSString *)text textColor:(UIColor *)textColor;

@end
