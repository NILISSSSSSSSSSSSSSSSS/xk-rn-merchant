//
//  XKStoreActivityTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATCouponsItem;

@interface XKStoreActivityTableViewCell : UITableViewCell

- (void)setValueWithModelArr:(NSArray<ATCouponsItem *> *)arr;

@end
