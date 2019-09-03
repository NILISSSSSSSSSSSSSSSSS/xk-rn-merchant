//
//  XKGrandPrizeAlreadyTableViewCell.h
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKGrandPrizeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKGrandPrizeAlreadyTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, copy) void(^shareBtnBlock)(XKGrandPrizeModel *grandPrize);

@property (nonatomic, copy) void(^confirmOrderBtnBlock)(XKGrandPrizeModel *grandPrize);

@property (nonatomic, copy) void(^showOrderBtnBlock)(XKGrandPrizeModel *grandPrize);

@property (nonatomic, copy) void(^logisticsBtnBlock)(XKGrandPrizeModel *grandPrize);

@property (nonatomic, copy) void(^detailBtnBlock)(XKGrandPrizeModel *grandPrize);

- (void)configCellWithGrandPrizeModel:(XKGrandPrizeModel *) grandPrize;

@end

NS_ASSUME_NONNULL_END
