//
//  XKOfficialGroupChatListViewTableViewCell.h
//  xkMerchant
//
//  Created by RyanYuan on 2019/1/25.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKOfficialGroupChatListModel;
@interface XKOfficialGroupChatListViewTableViewCell : UITableViewCell

- (void)configOfficialGroupChatListCellWithModel:(XKOfficialGroupChatListModel *)model;
- (void)showCellSeparator;
- (void)clipTopCornerRadius;
- (void)clipBottomCornerRadius;

@end

NS_ASSUME_NONNULL_END
