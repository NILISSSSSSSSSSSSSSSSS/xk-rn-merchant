//
//  XKMineMainViewStoreTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineMainViewStoreTableViewCell;

@protocol XKMineMainViewStoreTableViewCellDelegate <NSObject>

- (void)storeCell:(XKMineMainViewStoreTableViewCell *)cell loadMerchListWithPage:(NSInteger)page;
- (void)storeCell:(XKMineMainViewStoreTableViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XKMineMainViewStoreTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKMineMainViewStoreTableViewCellDelegate> delegate;

- (void)configCellWithMerchListArray:(NSArray *)merchArr;

@end
