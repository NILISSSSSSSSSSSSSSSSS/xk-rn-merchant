//
//  XKVideoSearchUserTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/14.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoSearchUserModel;


NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchUserTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *moreView;

@property (nonatomic, strong) XKVideoSearchUserModel *user;

- (void)setMoreViewHidden:(BOOL) hidden;

@end

NS_ASSUME_NONNULL_END
