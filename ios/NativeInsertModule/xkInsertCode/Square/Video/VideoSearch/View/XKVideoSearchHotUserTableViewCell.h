//
//  XKVideoSearchHotUserTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKVideoSearchUserModel;

typedef void(^FocusBtnBlock)(XKVideoSearchUserModel *user);

NS_ASSUME_NONNULL_BEGIN

@interface XKVideoSearchHotUserTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) XKVideoSearchUserModel *user;

@property (nonatomic, copy) FocusBtnBlock focusBtnBlock;

@end

NS_ASSUME_NONNULL_END
