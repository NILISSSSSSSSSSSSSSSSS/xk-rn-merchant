//
//  XKGrandPrizeTimeOrProgressTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/31.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKGrandPrizeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKGrandPrizeTimeOrProgressTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

- (void)configCellWithGrandPrizeModel:(XKGrandPrizeModel *) grandPrize detailBtnBlock:(void(^ _Nullable )(void)) detailBtnBlock;

@end

NS_ASSUME_NONNULL_END
