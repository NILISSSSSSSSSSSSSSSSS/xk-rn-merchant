//
//  XKVideoSearchTopicTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoSearchTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchTopicTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) XKVideoSearchTopicModel *topic;

- (void)setSearchImgHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
