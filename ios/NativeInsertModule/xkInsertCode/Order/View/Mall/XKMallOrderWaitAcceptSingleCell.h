//
//  XKMallOrderWaitAcceptSingleCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallOrderViewModel.h"
@interface XKMallOrderWaitAcceptSingleCell : UITableViewCell
@property (nonatomic, strong)void(^moreBtnBlock)(UIButton *sender, NSIndexPath *index);

@property (nonatomic, strong)void(^sureBtnBlock)(UIButton *sender, NSIndexPath *index);

- (void)bindData:(MallOrderListDataItem *)item;
@end
