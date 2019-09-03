//
//  XKVideoCommentMoreTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XKVideoCommentMoreViewBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoCommentMoreTableViewCell : UITableViewCell

@property (nonatomic, copy) XKVideoCommentMoreViewBlock moreViewBlock;

- (void)configMoreLabelWithCount:(NSUInteger) count;

@end

NS_ASSUME_NONNULL_END
