//
//  XKVideoSearchHotTopicTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoSearchTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchHotTopicTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) XKVideoSearchTopicModel *topic;

@end

NS_ASSUME_NONNULL_END
