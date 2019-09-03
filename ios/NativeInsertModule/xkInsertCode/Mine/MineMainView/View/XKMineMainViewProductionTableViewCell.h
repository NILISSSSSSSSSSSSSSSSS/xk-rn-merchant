//
//  XKMineMainViewProductionTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoDisplayVideoListItemModel;

@protocol XKMineMainViewProductionTableViewCellDelegate <NSObject>

- (void)productionTableViewCellReloadCollectionViewHeight:(CGFloat)cellHeight;
- (void)productionTableViewCell:(UITableViewCell *)cell clickProductionWithModel:(XKVideoDisplayVideoListItemModel *)model;

@end

@interface XKMineMainViewProductionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKMineMainViewProductionTableViewCellDelegate> delegate;

- (void)configCellWithProductionListArray:(NSArray *)productionArr collectionViewHeight:(CGFloat)collectionViewHeight;

@end
