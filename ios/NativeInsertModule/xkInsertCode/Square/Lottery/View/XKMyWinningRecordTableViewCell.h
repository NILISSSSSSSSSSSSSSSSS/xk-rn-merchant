//
//  XKMyWinningRecordTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/30.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKWinningRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKMyWinningRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

- (void)configCellWithWinningRecordModel:(XKWinningRecordModel *) winningRecord;

- (void)setDownLineHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
