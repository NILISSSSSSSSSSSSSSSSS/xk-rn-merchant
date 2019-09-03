//
//  XKSubscriptionTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/8/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XKSubscriptionCellModel;

typedef void(^SortButtonBlock)(UIButton *sender);

@interface XKSubscriptionTableViewCell : UITableViewCell

@property (nonatomic, copy) SortButtonBlock  sortBtnBlock;

- (void)hiddenLine:(BOOL)hidden;
- (void)setValuesWithModel:(XKSubscriptionCellModel *)model indexPath:(NSIndexPath *)indexPath;

@end
