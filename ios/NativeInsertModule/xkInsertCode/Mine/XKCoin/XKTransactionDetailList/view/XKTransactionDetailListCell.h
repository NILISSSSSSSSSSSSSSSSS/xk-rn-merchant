//
//  XKTransactionDetailListCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKTransactionDetailModel;

@interface XKTransactionDetailListCell : UITableViewCell

- (void)setVaules:(XKTransactionDetailModel *)model;
- (void)hiddenLineView:(BOOL)hidden;

@end
