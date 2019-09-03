//
//  XKMineRedEnvelopeRecordsTableViewHeader.h
//  XKSquare
//
//  Created by RyanYuan on 2018/11/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XKMineRedEnvelopeRecordsTableViewHeader;

@protocol XKMineRedEnvelopeRecordsTableViewHeaderDelegate <NSObject>

- (void)headerView:(XKMineRedEnvelopeRecordsTableViewHeader *)headerView categaryButtonAction:(UIButton *)sender;
- (void)headerView:(XKMineRedEnvelopeRecordsTableViewHeader *)headerView dateButtonAction:(UIButton *)sender;

@end

@interface XKMineRedEnvelopeRecordsTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id<XKMineRedEnvelopeRecordsTableViewHeaderDelegate> delegate;

/** 配置下拉列表及已选字段 */
- (void)configHeaderViewWithTitleArray:(NSArray *)titleArr currentCategoryIndex:(NSInteger)index;

/** 配置时间 */
- (void)configHeaderViewWithDateString:(NSString *)dateString;

@end
