//
//  XKSqureMerchantRecommendCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MerchantRecommendItem;

@interface XKSqureMerchantRecommendCell : UITableViewCell

- (void)setTestName:(NSString *)name;

- (void)setValueWithModel:(MerchantRecommendItem *)model;

@end
