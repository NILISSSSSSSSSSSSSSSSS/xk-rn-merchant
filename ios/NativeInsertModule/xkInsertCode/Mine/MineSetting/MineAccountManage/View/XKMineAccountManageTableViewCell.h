//
//  XKAccountManageTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKAccountManageModel;
@class XKMineAccountManageTableViewCell;

@protocol XKAccountManageTableViewCellDelegate <NSObject>

- (void)accountManageCellDidSelected:(XKMineAccountManageTableViewCell *)cell;

@end

@interface XKMineAccountManageTableViewCell : UITableViewCell

@property (nonatomic, weak) id<XKAccountManageTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configAccountManageTableViewCellWithModel:(XKAccountManageModel *)model;
- (void)showCellSeparator;
- (void)hiddenCellSeparator;

@end
