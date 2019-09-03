//
//  XKBuyCoinListTableViewCell.h
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyCoinDelegate <NSObject>

- (void)buyButtonClicked:(UIButton *)sender binded:(BOOL)binded;

@end

@interface XKBuyCoinListTableViewCell : UITableViewCell

@property (nonatomic, weak  ) id<BuyCoinDelegate> delegate;

@end
