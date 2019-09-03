//
//  XKVideoAnchorRankTableViewCell.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKVideoAnchorRankTableViewCell : UITableViewCell

// 上下圆角
- (void)showTopCornerRadius;
- (void)showBottomCornerRadius;
- (void)hiddenCornerRadius;

// 奖牌
- (void)showSecondMedalImageView;
- (void)showThirdMedalImageView;
- (void)hiddenMedalImageView;

@end
