//
//  XKVideoSubCommentTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoReplyModel;

typedef void(^XKVideoSubCommentUserClickedBlock)(NSString *userId);

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSubCommentTableViewCell : UITableViewCell

@property (nonatomic, copy) XKVideoSubCommentUserClickedBlock userClickedBlock;

- (void)configCellWithReplyModel:(XKVideoReplyModel *) reply;

@end

NS_ASSUME_NONNULL_END
