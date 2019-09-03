//
//  XKMallLoseEfficacyBuyCarCell.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMallBuyCarViewModel.h"
@interface XKMallLoseEfficacyBuyCarCell : UITableViewCell
@property (nonatomic, copy)void(^ticketClickBlock)(UIButton *sender, NSInteger index);
@property (nonatomic, copy)void(^choseClickBlock)(UIButton *sender, NSInteger index);

- (void)handleDataModel:(XKMallBuyCarItem *)item managerModel:(BOOL)manager;
@end
