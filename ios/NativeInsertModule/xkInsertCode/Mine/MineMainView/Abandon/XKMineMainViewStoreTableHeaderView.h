//
//  XKMineMainViewStoreTableHeaderView.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XKMineMainViewStoreTableHeaderViewDelegate <NSObject>

- (void)storeTableHeaderView:(UITableViewHeaderFooterView *)headerView clickWinningRecordsButton:(UIButton *)sender;

@end

@interface XKMineMainViewStoreTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<XKMineMainViewStoreTableHeaderViewDelegate> delegate;

@end
