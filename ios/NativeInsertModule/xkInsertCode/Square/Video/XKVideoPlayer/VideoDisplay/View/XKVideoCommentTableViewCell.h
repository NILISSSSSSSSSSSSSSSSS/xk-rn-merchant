//
//  XKVideoCommentTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoCommentModel;

typedef void(^XKVideoCommentUserClickedBlock)(NSString *userId);

typedef void(^XKVideoCommentLikeViewBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoCommentTableViewCell : UITableViewCell

@property (nonatomic, copy) XKVideoCommentUserClickedBlock userClickedBlock;

@property (nonatomic, copy) XKVideoCommentLikeViewBlock likeViewBlock;

- (void)configCellWithCommentModel:(XKVideoCommentModel *) comment;

@end

NS_ASSUME_NONNULL_END
