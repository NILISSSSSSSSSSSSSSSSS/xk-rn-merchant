//
//  XKWelfarePastAwardRecordTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKWelfarePastAwardRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKWelfarePastAwardRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

- (void)configCellWithWelfarePastAwardRecordModel:(XKWelfarePastAwardRecordModel *)welfarePastAwardRecord;

@end

NS_ASSUME_NONNULL_END
